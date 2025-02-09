// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

/**
 * @title Curve Convex Strategy
 * @notice Investment strategy for investing stablecoins via Curve 3Pool
 * @author Origin Protocol Inc
 */
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

import { IRewardStaking } from "./IRewardStaking.sol";
import { IConvexDeposits } from "./IConvexDeposits.sol";
import { ICurvePool } from "./ICurvePool.sol";
import { IERC20 } from "./BaseCurveStrategy.sol";
import { BaseConvexMetaStrategy } from "./BaseConvexMetaStrategy.sol";
import { StableMath } from "../utils/StableMath.sol";
import { IVault } from "../interfaces/IVault.sol";

contract ConvexOUSDMetaStrategy is BaseConvexMetaStrategy {
    using StableMath for uint256;
    using SafeERC20 for IERC20;

    /* Take 3pool LP and mint the corresponding amount of ousd. Deposit and stake that to
     * ousd Curve Metapool. Take the LP from metapool and deposit them to Convex.
     */
    function _lpDepositAll() internal override {
        ICurvePool curvePool = ICurvePool(platformAddress);

        uint256 threePoolLpBalance = IERC20(pTokenAddress).balanceOf(
            address(this)
        );
        uint256 curve3PoolVirtualPrice = curvePool.get_virtual_price();
        uint256 threePoolLpDollarValue = threePoolLpBalance.mulTruncate(
            curve3PoolVirtualPrice
        );

        // safe to cast since min value is at least 0
        uint256 ousdToAdd = uint256(
            _max(
                0,
                int256(
                    metapool.balances(crvCoinIndex).mulTruncate(
                        curve3PoolVirtualPrice
                    )
                ) -
                    int256(metapool.balances(mainCoinIndex)) +
                    int256(threePoolLpDollarValue)
            )
        );

        /* Add so much OUSD so that the pool ends up being balanced. And at minimum
         * add twice as much OUSD as 3poolLP and at maximum at twice as
         * much OUSD.
         */
        ousdToAdd = Math.max(ousdToAdd, threePoolLpDollarValue);
        ousdToAdd = Math.min(ousdToAdd, threePoolLpDollarValue * 2);

        /* Mint OUSD with a strategy that attempts to contribute to stability of OUSD metapool. Try
         * to mint so much OUSD that after deployment of liquidity pool ends up being balanced.
         *
         * To manage unpredictability minimal OUSD minted will always be at least equal or greater
         * to stablecoin(DAI, USDC, USDT) amount of 3CRVLP deployed. And never larger than twice the
         * stablecoin amount of 3CRVLP deployed even if it would have a further beneficial effect
         * on pool stability.
         */
        if (ousdToAdd > 0) {
            IVault(vaultAddress).mintForStrategy(ousdToAdd);
        }

        uint256[2] memory _amounts = [ousdToAdd, threePoolLpBalance];

        uint256 metapoolVirtualPrice = metapool.get_virtual_price();
        /**
         * First convert all the deposited tokens to dollar values,
         * then divide by virtual price to convert to metapool LP tokens
         * and apply the max slippage
         */
        uint256 minReceived = (ousdToAdd + threePoolLpDollarValue)
            .divPrecisely(metapoolVirtualPrice)
            .mulTruncate(uint256(1e18) - MAX_SLIPPAGE);

        uint256 metapoolLp = metapool.add_liquidity(_amounts, minReceived);

        bool success = IConvexDeposits(cvxDepositorAddress).deposit(
            cvxDepositorPTokenId,
            metapoolLp,
            true // Deposit with staking
        );

        require(success, "Failed to deposit to Convex");
    }

    /**
     * Withdraw the specified amount of tokens from the gauge. And use all the resulting tokens
     * to remove liquidity from metapool
     * @param num3CrvTokens Number of 3CRV tokens to withdraw from metapool
     */
    function _lpWithdraw(uint256 num3CrvTokens) internal override {
        ICurvePool curvePool = ICurvePool(platformAddress);
        /* The rate between coins in the metapool determines the rate at which metapool returns
         * tokens when doing balanced removal (remove_liquidity call). And by knowing how much 3crvLp
         * we want we can determine how much of OUSD we receive by removing liquidity.
         *
         * Because we are doing balanced removal we should be making profit when removing liquidity in a
         * pool tilted to either side.
         *
         * Important: A downside is that the Strategist / Governor needs to be
         * cognisant of not removing too much liquidity. And while the proposal to remove liquidity
         * is being voted on the pool tilt might change so much that the proposal that has been valid while
         * created is no longer valid.
         */

        uint256 crvPoolBalance = metapool.balances(crvCoinIndex);
        /* K is multiplied by 1e36 which is used for higher precision calculation of required
         * metapool LP tokens. Without it the end value can have rounding errors up to precision of
         * 10 digits. This way we move the decimal point by 36 places when doing the calculation
         * and again by 36 places when we are done with it.
         */
        uint256 k = (1e36 * metapoolLPToken.totalSupply()) / crvPoolBalance;
        // simplifying below to: `uint256 diff = (num3CrvTokens - 1) * k` causes loss of precision
        // prettier-ignore
        // slither-disable-next-line divide-before-multiply
        uint256 diff = crvPoolBalance * k -
            (crvPoolBalance - num3CrvTokens - 1) * k;
        uint256 lpToBurn = diff / 1e36;

        uint256 gaugeTokens = IRewardStaking(cvxRewardStakerAddress).balanceOf(
            address(this)
        );

        require(
            lpToBurn <= gaugeTokens,
            string(
                bytes.concat(
                    bytes("Attempting to withdraw "),
                    bytes(Strings.toString(lpToBurn)),
                    bytes(", metapoolLP but only "),
                    bytes(Strings.toString(gaugeTokens)),
                    bytes(" available.")
                )
            )
        );

        // withdraw and unwrap with claim takes back the lpTokens and also collects the rewards for deposit
        IRewardStaking(cvxRewardStakerAddress).withdrawAndUnwrap(
            lpToBurn,
            true
        );

        // calculate the min amount of OUSD expected for the specified amount of LP tokens
        uint256 minOUSDAmount = lpToBurn.mulTruncate(
            metapool.get_virtual_price()
        ) -
            num3CrvTokens.mulTruncate(curvePool.get_virtual_price()) -
            1;

        // withdraw the liquidity from metapool
        uint256[2] memory _removedAmounts = metapool.remove_liquidity(
            lpToBurn,
            [minOUSDAmount, num3CrvTokens]
        );

        IVault(vaultAddress).burnForStrategy(_removedAmounts[mainCoinIndex]);
    }

    function _lpWithdrawAll() internal override {
        IERC20 metapoolErc20 = IERC20(address(metapool));
        uint256 gaugeTokens = IRewardStaking(cvxRewardStakerAddress).balanceOf(
            address(this)
        );
        IRewardStaking(cvxRewardStakerAddress).withdrawAndUnwrap(
            gaugeTokens,
            true
        );

        uint256[2] memory _minAmounts = [uint256(0), uint256(0)];
        uint256[2] memory _removedAmounts = metapool.remove_liquidity(
            metapoolErc20.balanceOf(address(this)),
            _minAmounts
        );

        IVault(vaultAddress).burnForStrategy(_removedAmounts[mainCoinIndex]);
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)

pragma solidity ^0.8.0;

import "../IERC20.sol";
import "../../../utils/Address.sol";

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/math/Math.sol)

pragma solidity ^0.8.0;

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a / b + (a % b == 0 ? 0 : 1);
    }
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface IRewardStaking {
    function stakeFor(address, uint256) external;

    function stake(uint256) external;

    function withdraw(uint256 amount, bool claim) external;

    function withdrawAndUnwrap(uint256 amount, bool claim) external;

    function earned(address account) external view returns (uint256);

    function getReward() external;

    function getReward(address _account, bool _claimExtras) external;

    function extraRewardsLength() external returns (uint256);

    function extraRewards(uint256 _pid) external returns (address);

    function rewardToken() external returns (address);

    function balanceOf(address account) external view returns (uint256);
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface IConvexDeposits {
    function deposit(
        uint256 _pid,
        uint256 _amount,
        bool _stake
    ) external returns (bool);

    function deposit(
        uint256 _amount,
        bool _lock,
        address _stakeAddress
    ) external;
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface ICurvePool {
    function get_virtual_price() external view returns (uint256);

    function add_liquidity(uint256[3] calldata _amounts, uint256 _min) external;

    function balances(uint256) external view returns (uint256);

    function calc_token_amount(uint256[3] calldata _amounts, bool _deposit)
        external
        returns (uint256);

    function fee() external view returns (uint256);

    function remove_liquidity_one_coin(
        uint256 _amount,
        int128 _index,
        uint256 _minAmount
    ) external;

    function remove_liquidity(
        uint256 _amount,
        uint256[3] calldata _minWithdrawAmounts
    ) external;

    function calc_withdraw_one_coin(uint256 _amount, int128 _index)
        external
        view
        returns (uint256);

    function coins(uint256 _index) external view returns (address);

    function remove_liquidity_imbalance(
        uint256[3] calldata _amounts,
        uint256 maxBurnAmount
    ) external;
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

/**
 * @title Curve 3Pool Strategy
 * @notice Investment strategy for investing stablecoins via Curve 3Pool
 * @author Origin Protocol Inc
 */
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import { ICurvePool } from "./ICurvePool.sol";
import { IERC20, InitializableAbstractStrategy } from "../utils/InitializableAbstractStrategy.sol";
import { StableMath } from "../utils/StableMath.sol";
import { Helpers } from "../utils/Helpers.sol";

abstract contract BaseCurveStrategy is InitializableAbstractStrategy {
    using StableMath for uint256;
    using SafeERC20 for IERC20;

    uint256 internal constant MAX_SLIPPAGE = 1e16; // 1%, same as the Curve UI
    // number of assets in Curve 3Pool (USDC, DAI, USDT)
    uint256 internal constant THREEPOOL_ASSET_COUNT = 3;
    address internal pTokenAddress;

    int256[49] private __reserved;

    /**
     * @dev Deposit asset into the Curve 3Pool
     * @param _asset Address of asset to deposit
     * @param _amount Amount of asset to deposit
     */
    function deposit(address _asset, uint256 _amount)
        external
        override
        onlyVault
        nonReentrant
    {
        require(_amount > 0, "Must deposit something");
        emit Deposit(_asset, pTokenAddress, _amount);

        // 3Pool requires passing deposit amounts for all 3 assets, set to 0 for
        // all
        uint256[3] memory _amounts;
        uint256 poolCoinIndex = _getCoinIndex(_asset);
        // Set the amount on the asset we want to deposit
        _amounts[poolCoinIndex] = _amount;
        ICurvePool curvePool = ICurvePool(platformAddress);
        uint256 assetDecimals = Helpers.getDecimals(_asset);
        uint256 depositValue = _amount.scaleBy(18, assetDecimals).divPrecisely(
            curvePool.get_virtual_price()
        );
        uint256 minMintAmount = depositValue.mulTruncate(
            uint256(1e18) - MAX_SLIPPAGE
        );
        // Do the deposit to 3pool
        curvePool.add_liquidity(_amounts, minMintAmount);
        _lpDepositAll();
    }

    function _lpDepositAll() internal virtual;

    /**
     * @dev Deposit the entire balance of any supported asset into the Curve 3pool
     */
    function depositAll() external override onlyVault nonReentrant {
        uint256[3] memory _amounts = [uint256(0), uint256(0), uint256(0)];
        uint256 depositValue = 0;
        ICurvePool curvePool = ICurvePool(platformAddress);
        uint256 curveVirtualPrice = curvePool.get_virtual_price();

        for (uint256 i = 0; i < assetsMapped.length; i++) {
            address assetAddress = assetsMapped[i];
            uint256 balance = IERC20(assetAddress).balanceOf(address(this));
            if (balance > 0) {
                uint256 poolCoinIndex = _getCoinIndex(assetAddress);
                // Set the amount on the asset we want to deposit
                _amounts[poolCoinIndex] = balance;
                uint256 assetDecimals = Helpers.getDecimals(assetAddress);
                // Get value of deposit in Curve LP token to later determine
                // the minMintAmount argument for add_liquidity
                depositValue =
                    depositValue +
                    balance.scaleBy(18, assetDecimals).divPrecisely(
                        curveVirtualPrice
                    );
                emit Deposit(assetAddress, pTokenAddress, balance);
            }
        }

        uint256 minMintAmount = depositValue.mulTruncate(
            uint256(1e18) - MAX_SLIPPAGE
        );
        // Do the deposit to 3pool
        curvePool.add_liquidity(_amounts, minMintAmount);

        /* In case of Curve Strategy all assets are mapped to the same pToken (3CrvLP). Let
         * descendants further handle the pToken. By either deploying it to the metapool and
         * resulting tokens in Gauge. Or deploying pTokens directly to the Gauge.
         */
        _lpDepositAll();
    }

    function _lpWithdraw(uint256 numCrvTokens) internal virtual;

    function _lpWithdrawAll() internal virtual;

    /**
     * @dev Withdraw asset from Curve 3Pool
     * @param _recipient Address to receive withdrawn asset
     * @param _asset Address of asset to withdraw
     * @param _amount Amount of asset to withdraw
     */
    function withdraw(
        address _recipient,
        address _asset,
        uint256 _amount
    ) external override onlyVault nonReentrant {
        require(_amount > 0, "Invalid amount");

        emit Withdrawal(_asset, pTokenAddress, _amount);

        uint256 contractCrv3Tokens = IERC20(pTokenAddress).balanceOf(
            address(this)
        );

        uint256 coinIndex = _getCoinIndex(_asset);
        ICurvePool curvePool = ICurvePool(platformAddress);

        uint256 requiredCrv3Tokens = _calcCurveTokenAmount(coinIndex, _amount);

        // We have enough LP tokens, make sure they are all on this contract
        if (contractCrv3Tokens < requiredCrv3Tokens) {
            _lpWithdraw(requiredCrv3Tokens - contractCrv3Tokens);
        }

        uint256[3] memory _amounts = [uint256(0), uint256(0), uint256(0)];
        _amounts[coinIndex] = _amount;

        curvePool.remove_liquidity_imbalance(_amounts, requiredCrv3Tokens);
        IERC20(_asset).safeTransfer(_recipient, _amount);
    }

    /**
     * @dev Calculate amount of LP required when withdrawing specific amount of one
     * of the underlying assets accounting for fees and slippage.
     *
     * Curve pools unfortunately do not contain a calculation function for
     * amount of LP required when withdrawing a specific amount of one of the
     * underlying tokens and also accounting for fees (Curve's calc_token_amount
     * does account for slippage but not fees).
     *
     * Steps taken to calculate the metric:
     *  - get amount of LP required if fees wouldn't apply
     *  - increase the LP amount as if fees would apply to the entirety of the underlying
     *    asset withdrawal. (when withdrawing only one coin fees apply only to amounts
     *    of other assets pool would return in case of balanced removal - since those need
     *    to be swapped for the single underlying asset being withdrawn)
     *  - get amount of underlying asset withdrawn (this Curve function does consider slippage
     *    and fees) when using the increased LP amount. As LP amount is slightly over-increased
     *    so is amount of underlying assets returned.
     *  - since we know exactly how much asset we require take the rate of LP required for asset
     *    withdrawn to get the exact amount of LP.
     */
    function _calcCurveTokenAmount(uint256 _coinIndex, uint256 _amount)
        internal
        returns (uint256 required3Crv)
    {
        ICurvePool curvePool = ICurvePool(platformAddress);

        uint256[3] memory _amounts = [uint256(0), uint256(0), uint256(0)];
        _amounts[_coinIndex] = _amount;

        // LP required when removing required asset ignoring fees
        uint256 lpRequiredNoFees = curvePool.calc_token_amount(_amounts, false);
        /* LP required if fees would apply to entirety of removed amount
         *
         * fee is 1e10 denominated number: https://curve.readthedocs.io/exchange-pools.html#StableSwap.fee
         */
        uint256 lpRequiredFullFees = lpRequiredNoFees.mulTruncateScale(
            1e10 + curvePool.fee(),
            1e10
        );

        /* asset received when withdrawing full fee applicable LP accounting for
         * slippage and fees
         */
        uint256 assetReceivedForFullLPFees = curvePool.calc_withdraw_one_coin(
            lpRequiredFullFees,
            int128(uint128(_coinIndex))
        );

        // exact amount of LP required
        required3Crv =
            (lpRequiredFullFees * _amount) /
            assetReceivedForFullLPFees;
    }

    /**
     * @dev Remove all assets from platform and send them to Vault contract.
     */
    function withdrawAll() external override onlyVaultOrGovernor nonReentrant {
        _lpWithdrawAll();
        // Withdraws are proportional to assets held by 3Pool
        uint256[3] memory minWithdrawAmounts = [
            uint256(0),
            uint256(0),
            uint256(0)
        ];

        // Remove liquidity
        ICurvePool threePool = ICurvePool(platformAddress);
        threePool.remove_liquidity(
            IERC20(pTokenAddress).balanceOf(address(this)),
            minWithdrawAmounts
        );
        // Transfer assets out of Vault
        // Note that Curve will provide all 3 of the assets in 3pool even if
        // we have not set PToken addresses for all of them in this strategy
        for (uint256 i = 0; i < assetsMapped.length; i++) {
            IERC20 asset = IERC20(threePool.coins(i));
            asset.safeTransfer(vaultAddress, asset.balanceOf(address(this)));
        }
    }

    /**
     * @dev Get the total asset value held in the platform
     * @param _asset      Address of the asset
     * @return balance    Total value of the asset in the platform
     */
    function checkBalance(address _asset)
        public
        view
        virtual
        override
        returns (uint256 balance)
    {
        require(assetToPToken[_asset] != address(0), "Unsupported asset");
        // LP tokens in this contract. This should generally be nothing as we
        // should always stake the full balance in the Gauge, but include for
        // safety
        uint256 totalPTokens = IERC20(pTokenAddress).balanceOf(address(this));
        ICurvePool curvePool = ICurvePool(platformAddress);
        if (totalPTokens > 0) {
            uint256 virtual_price = curvePool.get_virtual_price();
            uint256 value = (totalPTokens * virtual_price) / 1e18;
            uint256 assetDecimals = Helpers.getDecimals(_asset);
            balance = value.scaleBy(assetDecimals, 18) / THREEPOOL_ASSET_COUNT;
        }
    }

    /**
     * @dev Retuns bool indicating whether asset is supported by strategy
     * @param _asset Address of the asset
     */
    function supportsAsset(address _asset)
        external
        view
        override
        returns (bool)
    {
        return assetToPToken[_asset] != address(0);
    }

    /**
     * @dev Approve the spending of all assets by their corresponding pool tokens,
     *      if for some reason is it necessary.
     */
    function safeApproveAllTokens()
        external
        override
        onlyGovernor
        nonReentrant
    {
        _approveBase();
        // This strategy is a special case since it only supports one asset
        for (uint256 i = 0; i < assetsMapped.length; i++) {
            _approveAsset(assetsMapped[i]);
        }
    }

    /**
     * @dev Call the necessary approvals for the Curve pool and gauge
     * @param _asset Address of the asset
     */
    // solhint-disable-next-line no-unused-vars
    function _abstractSetPToken(address _asset, address _pToken)
        internal
        override
    {
        _approveAsset(_asset);
    }

    function _approveAsset(address _asset) internal {
        IERC20 asset = IERC20(_asset);
        // 3Pool for asset (required for adding liquidity)
        asset.safeApprove(platformAddress, 0);
        asset.safeApprove(platformAddress, type(uint256).max);
    }

    function _approveBase() internal virtual;

    /**
     * @dev Get the index of the coin
     */
    function _getCoinIndex(address _asset) internal view returns (uint256) {
        for (uint256 i = 0; i < 3; i++) {
            if (assetsMapped[i] == _asset) return i;
        }
        revert("Invalid 3pool asset");
    }
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

/**
 * @title Curve Convex Strategy
 * @notice Investment strategy for investing stablecoins via Curve 3Pool
 * @author Origin Protocol Inc
 */
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import { IRewardStaking } from "./IRewardStaking.sol";
import { ICurvePool } from "./ICurvePool.sol";
import { ICurveMetaPool } from "./ICurveMetaPool.sol";
import { IERC20, BaseCurveStrategy } from "./BaseCurveStrategy.sol";
import { StableMath } from "../utils/StableMath.sol";
import { Helpers } from "../utils/Helpers.sol";

abstract contract BaseConvexMetaStrategy is BaseCurveStrategy {
    using StableMath for uint256;
    using SafeERC20 for IERC20;
    event MaxWithdrawalSlippageUpdated(
        uint256 _prevMaxSlippagePercentage,
        uint256 _newMaxSlippagePercentage
    );

    // used to circumvent the stack too deep issue
    struct InitConfig {
        address platformAddress; //Address of the Curve 3pool
        address vaultAddress; //Address of the vault
        address cvxDepositorAddress; //Address of the Convex depositor(AKA booster) for this pool
        address metapoolAddress; //Address of the Curve MetaPool
        address metapoolMainToken; //Address of Main metapool token
        address cvxRewardStakerAddress; //Address of the CVX rewards staker
        address metapoolLPToken; //Address of metapool LP token
        uint256 cvxDepositorPTokenId; //Pid of the pool referred to by Depositor and staker
    }

    address internal cvxDepositorAddress;
    address internal cvxRewardStakerAddress;
    uint256 internal cvxDepositorPTokenId;
    ICurveMetaPool internal metapool;
    IERC20 internal metapoolMainToken;
    IERC20 internal metapoolLPToken;
    // Ordered list of metapool assets
    address[] internal metapoolAssets;
    // Max withdrawal slippage denominated in 1e18 (1e18 == 100%)
    uint256 public maxWithdrawalSlippage;
    uint128 internal crvCoinIndex;
    uint128 internal mainCoinIndex;

    int256[41] private ___reserved;

    /**
     * Initializer for setting up strategy internal state. This overrides the
     * InitializableAbstractStrategy initializer as Curve strategies don't fit
     * well within that abstraction.
     * @param _rewardTokenAddresses Address of CRV & CVX
     * @param _assets Addresses of supported assets. MUST be passed in the same
     *                order as returned by coins on the pool contract, i.e.
     *                DAI, USDC, USDT
     * @param _pTokens Platform Token corresponding addresses
     * @param initConfig Various addresses and info for initialization state
     */
    function initialize(
        address[] calldata _rewardTokenAddresses, // CRV + CVX
        address[] calldata _assets,
        address[] calldata _pTokens,
        InitConfig calldata initConfig
    ) external onlyGovernor initializer {
        require(_assets.length == 3, "Must have exactly three assets");
        // Should be set prior to abstract initialize call otherwise
        // abstractSetPToken calls will fail
        cvxDepositorAddress = initConfig.cvxDepositorAddress;
        pTokenAddress = _pTokens[0];
        metapool = ICurveMetaPool(initConfig.metapoolAddress);
        metapoolMainToken = IERC20(initConfig.metapoolMainToken);
        cvxRewardStakerAddress = initConfig.cvxRewardStakerAddress;
        metapoolLPToken = IERC20(initConfig.metapoolLPToken);
        cvxDepositorPTokenId = initConfig.cvxDepositorPTokenId;
        maxWithdrawalSlippage = 1e16;

        metapoolAssets = [metapool.coins(0), metapool.coins(1)];
        crvCoinIndex = _getMetapoolCoinIndex(pTokenAddress);
        mainCoinIndex = _getMetapoolCoinIndex(initConfig.metapoolMainToken);
        super._initialize(
            initConfig.platformAddress,
            initConfig.vaultAddress,
            _rewardTokenAddresses,
            _assets,
            _pTokens
        );
        _approveBase();
    }

    /**
     * @dev Get the total asset value held in the platform
     * @param _asset      Address of the asset
     * @return balance    Total value of the asset in the platform
     */
    function checkBalance(address _asset)
        public
        view
        virtual
        override
        returns (uint256 balance)
    {
        require(assetToPToken[_asset] != address(0), "Unsupported asset");
        balance = 0;

        // LP tokens in this contract. This should generally be nothing as we
        // should always stake the full balance in the Gauge, but include for
        // safety
        uint256 contractPTokens = IERC20(pTokenAddress).balanceOf(
            address(this)
        );
        ICurvePool curvePool = ICurvePool(platformAddress);
        if (contractPTokens > 0) {
            uint256 virtual_price = curvePool.get_virtual_price();
            uint256 value = contractPTokens.mulTruncate(virtual_price);
            balance += value;
        }

        /* We intentionally omit the metapoolLp tokens held by the metastrategyContract
         * since the contract should never (except in the middle of deposit/withdrawal
         * transaction) hold any amount of those tokens in normal operation. There
         * could be tokens sent to it by a 3rd party and we decide to actively ignore
         * those.
         */
        uint256 metapoolGaugePTokens = IRewardStaking(cvxRewardStakerAddress)
            .balanceOf(address(this));

        if (metapoolGaugePTokens > 0) {
            uint256 value = metapoolGaugePTokens.mulTruncate(
                metapool.get_virtual_price()
            );
            balance += value;
        }

        uint256 assetDecimals = Helpers.getDecimals(_asset);
        balance = balance.scaleBy(assetDecimals, 18) / THREEPOOL_ASSET_COUNT;
    }

    /**
     * @dev This function is completely analogous to _calcCurveTokenAmount[BaseCurveStrategy]
     * and just utilizes different Curve (meta)pool API
     */
    function _calcCurveMetaTokenAmount(uint128 _coinIndex, uint256 _amount)
        internal
        returns (uint256 requiredMetapoolLP)
    {
        uint256[2] memory _amounts = [uint256(0), uint256(0)];
        _amounts[uint256(_coinIndex)] = _amount;

        // LP required when removing required asset ignoring fees
        uint256 lpRequiredNoFees = metapool.calc_token_amount(_amounts, false);
        /* LP required if fees would apply to entirety of removed amount
         *
         * fee is 1e10 denominated number: https://curve.readthedocs.io/exchange-pools.html#StableSwap.fee
         */
        uint256 lpRequiredFullFees = lpRequiredNoFees.mulTruncateScale(
            1e10 + metapool.fee(),
            1e10
        );

        /* asset received when withdrawing full fee applicable LP accounting for
         * slippage and fees
         */
        uint256 assetReceivedForFullLPFees = metapool.calc_withdraw_one_coin(
            lpRequiredFullFees,
            int128(_coinIndex)
        );

        // exact amount of LP required
        requiredMetapoolLP =
            (lpRequiredFullFees * _amount) /
            assetReceivedForFullLPFees;
    }

    function _approveBase() internal override {
        IERC20 pToken = IERC20(pTokenAddress);
        // 3Pool for LP token (required for removing liquidity)
        pToken.safeApprove(platformAddress, 0);
        pToken.safeApprove(platformAddress, type(uint256).max);
        // Gauge for LP token
        metapoolLPToken.safeApprove(cvxDepositorAddress, 0);
        metapoolLPToken.safeApprove(cvxDepositorAddress, type(uint256).max);
        // Metapool for LP token
        pToken.safeApprove(address(metapool), 0);
        pToken.safeApprove(address(metapool), type(uint256).max);
        // Metapool for Metapool main token
        metapoolMainToken.safeApprove(address(metapool), 0);
        metapoolMainToken.safeApprove(address(metapool), type(uint256).max);
    }

    /**
     * @dev Get the index of the coin
     */
    function _getMetapoolCoinIndex(address _asset)
        internal
        view
        returns (uint128)
    {
        for (uint128 i = 0; i < 2; i++) {
            if (metapoolAssets[i] == _asset) return i;
        }
        revert("Invalid Metapool asset");
    }

    /**
     * @dev Sets max withdrawal slippage that is considered when removing
     * liquidity from Metapools.
     * @param _maxWithdrawalSlippage Max withdrawal slippage denominated in
     *        wad (number with 18 decimals): 1e18 == 100%, 1e16 == 1%
     *
     * IMPORTANT Minimum maxWithdrawalSlippage should actually be 0.1% (1e15)
     * for production usage. Contract allows as low value as 0% for confirming
     * correct behavior in test suite.
     */
    function setMaxWithdrawalSlippage(uint256 _maxWithdrawalSlippage)
        external
        onlyVaultOrGovernorOrStrategist
    {
        require(
            _maxWithdrawalSlippage <= 1e18,
            "Max withdrawal slippage needs to be between 0% - 100%"
        );
        emit MaxWithdrawalSlippageUpdated(
            maxWithdrawalSlippage,
            _maxWithdrawalSlippage
        );
        maxWithdrawalSlippage = _maxWithdrawalSlippage;
    }

    /**
     * @dev Collect accumulated CRV and CVX and send to Harvester.
     */
    function collectRewardTokens()
        external
        override
        onlyHarvester
        nonReentrant
    {
        // Collect CRV and CVX
        IRewardStaking(cvxRewardStakerAddress).getReward();
        _collectRewardTokens();
    }

    /**
     * @dev Returns the largest of two numbers int256 version
     */
    function _max(int256 a, int256 b) internal pure returns (int256) {
        return a >= b ? a : b;
    }
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";

// Based on StableMath from Stability Labs Pty. Ltd.
// https://github.com/mstable/mStable-contracts/blob/master/contracts/shared/StableMath.sol

library StableMath {
    using SafeMath for uint256;

    /**
     * @dev Scaling unit for use in specific calculations,
     * where 1 * 10**18, or 1e18 represents a unit '1'
     */
    uint256 private constant FULL_SCALE = 1e18;

    /***************************************
                    Helpers
    ****************************************/

    /**
     * @dev Adjust the scale of an integer
     * @param to Decimals to scale to
     * @param from Decimals to scale from
     */
    function scaleBy(
        uint256 x,
        uint256 to,
        uint256 from
    ) internal pure returns (uint256) {
        if (to > from) {
            x = x.mul(10**(to - from));
        } else if (to < from) {
            x = x.div(10**(from - to));
        }
        return x;
    }

    /***************************************
               Precise Arithmetic
    ****************************************/

    /**
     * @dev Multiplies two precise units, and then truncates by the full scale
     * @param x Left hand input to multiplication
     * @param y Right hand input to multiplication
     * @return Result after multiplying the two inputs and then dividing by the shared
     *         scale unit
     */
    function mulTruncate(uint256 x, uint256 y) internal pure returns (uint256) {
        return mulTruncateScale(x, y, FULL_SCALE);
    }

    /**
     * @dev Multiplies two precise units, and then truncates by the given scale. For example,
     * when calculating 90% of 10e18, (10e18 * 9e17) / 1e18 = (9e36) / 1e18 = 9e18
     * @param x Left hand input to multiplication
     * @param y Right hand input to multiplication
     * @param scale Scale unit
     * @return Result after multiplying the two inputs and then dividing by the shared
     *         scale unit
     */
    function mulTruncateScale(
        uint256 x,
        uint256 y,
        uint256 scale
    ) internal pure returns (uint256) {
        // e.g. assume scale = fullScale
        // z = 10e18 * 9e17 = 9e36
        uint256 z = x.mul(y);
        // return 9e36 / 1e18 = 9e18
        return z.div(scale);
    }

    /**
     * @dev Multiplies two precise units, and then truncates by the full scale, rounding up the result
     * @param x Left hand input to multiplication
     * @param y Right hand input to multiplication
     * @return Result after multiplying the two inputs and then dividing by the shared
     *          scale unit, rounded up to the closest base unit.
     */
    function mulTruncateCeil(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        // e.g. 8e17 * 17268172638 = 138145381104e17
        uint256 scaled = x.mul(y);
        // e.g. 138145381104e17 + 9.99...e17 = 138145381113.99...e17
        uint256 ceil = scaled.add(FULL_SCALE.sub(1));
        // e.g. 13814538111.399...e18 / 1e18 = 13814538111
        return ceil.div(FULL_SCALE);
    }

    /**
     * @dev Precisely divides two units, by first scaling the left hand operand. Useful
     *      for finding percentage weightings, i.e. 8e18/10e18 = 80% (or 8e17)
     * @param x Left hand input to division
     * @param y Right hand input to division
     * @return Result after multiplying the left operand by the scale, and
     *         executing the division on the right hand input.
     */
    function divPrecisely(uint256 x, uint256 y)
        internal
        pure
        returns (uint256)
    {
        // e.g. 8e18 * 1e18 = 8e36
        uint256 z = x.mul(FULL_SCALE);
        // e.g. 8e36 / 10e18 = 8e17
        return z.div(y);
    }
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface IVault {
    event AssetSupported(address _asset);
    event AssetDefaultStrategyUpdated(address _asset, address _strategy);
    event AssetAllocated(address _asset, address _strategy, uint256 _amount);
    event StrategyApproved(address _addr);
    event StrategyRemoved(address _addr);
    event Mint(address _addr, uint256 _value);
    event Redeem(address _addr, uint256 _value);
    event CapitalPaused();
    event CapitalUnpaused();
    event RebasePaused();
    event RebaseUnpaused();
    event VaultBufferUpdated(uint256 _vaultBuffer);
    event RedeemFeeUpdated(uint256 _redeemFeeBps);
    event PriceProviderUpdated(address _priceProvider);
    event AllocateThresholdUpdated(uint256 _threshold);
    event RebaseThresholdUpdated(uint256 _threshold);
    event StrategistUpdated(address _address);
    event MaxSupplyDiffChanged(uint256 maxSupplyDiff);
    event YieldDistribution(address _to, uint256 _yield, uint256 _fee);
    event TrusteeFeeBpsChanged(uint256 _basis);
    event TrusteeAddressChanged(address _address);

    // Governable.sol
    function transferGovernance(address _newGovernor) external;

    function claimGovernance() external;

    function governor() external view returns (address);

    // VaultAdmin.sol
    function setPriceProvider(address _priceProvider) external;

    function priceProvider() external view returns (address);

    function setRedeemFeeBps(uint256 _redeemFeeBps) external;

    function redeemFeeBps() external view returns (uint256);

    function setVaultBuffer(uint256 _vaultBuffer) external;

    function vaultBuffer() external view returns (uint256);

    function setAutoAllocateThreshold(uint256 _threshold) external;

    function autoAllocateThreshold() external view returns (uint256);

    function setRebaseThreshold(uint256 _threshold) external;

    function rebaseThreshold() external view returns (uint256);

    function setStrategistAddr(address _address) external;

    function strategistAddr() external view returns (address);

    function setMaxSupplyDiff(uint256 _maxSupplyDiff) external;

    function maxSupplyDiff() external view returns (uint256);

    function setTrusteeAddress(address _address) external;

    function trusteeAddress() external view returns (address);

    function setTrusteeFeeBps(uint256 _basis) external;

    function trusteeFeeBps() external view returns (uint256);

    function ousdMetaStrategy() external view returns (address);

    function supportAsset(address _asset) external;

    function approveStrategy(address _addr) external;

    function removeStrategy(address _addr) external;

    function setAssetDefaultStrategy(address _asset, address _strategy)
        external;

    function assetDefaultStrategies(address _asset)
        external
        view
        returns (address);

    function pauseRebase() external;

    function unpauseRebase() external;

    function rebasePaused() external view returns (bool);

    function pauseCapital() external;

    function unpauseCapital() external;

    function capitalPaused() external view returns (bool);

    function transferToken(address _asset, uint256 _amount) external;

    function priceUSDMint(address asset) external view returns (uint256);

    function priceUSDRedeem(address asset) external view returns (uint256);

    function withdrawAllFromStrategy(address _strategyAddr) external;

    function withdrawAllFromStrategies() external;

    function reallocate(
        address _strategyFromAddress,
        address _strategyToAddress,
        address[] calldata _assets,
        uint256[] calldata _amounts
    ) external;

    // VaultCore.sol
    function mint(
        address _asset,
        uint256 _amount,
        uint256 _minimumOusdAmount
    ) external;

    function mintForStrategy(uint256 _amount) external;

    function redeem(uint256 _amount, uint256 _minimumUnitAmount) external;

    function burnForStrategy(uint256 _amount) external;

    function redeemAll(uint256 _minimumUnitAmount) external;

    function allocate() external;

    function rebase() external;

    function totalValue() external view returns (uint256 value);

    function checkBalance(address _asset) external view returns (uint256);

    function calculateRedeemOutputs(uint256 _amount)
        external
        view
        returns (uint256[] memory);

    function getAssetCount() external view returns (uint256);

    function getAllAssets() external view returns (address[] memory);

    function getStrategyCount() external view returns (uint256);

    function getAllStrategies() external view returns (address[] memory);

    function isSupportedAsset(address _asset) external view returns (bool);

    function netOusdMintForStrategyThreshold() external view returns (uint256);

    function setOusdMetaStrategy(address _ousdMetaStrategy) external;

    function setNetOusdMintForStrategyThreshold(uint256 _threshold) external;

    function netOusdMintedForStrategy() external view returns (int256);
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Address.sol)

pragma solidity ^0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";

import { Initializable } from "../utils/Initializable.sol";
import { Governable } from "../governance/Governable.sol";
import { IVault } from "../interfaces/IVault.sol";

abstract contract InitializableAbstractStrategy is Initializable, Governable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    event PTokenAdded(address indexed _asset, address _pToken);
    event PTokenRemoved(address indexed _asset, address _pToken);
    event Deposit(address indexed _asset, address _pToken, uint256 _amount);
    event Withdrawal(address indexed _asset, address _pToken, uint256 _amount);
    event RewardTokenCollected(
        address recipient,
        address rewardToken,
        uint256 amount
    );
    event RewardTokenAddressesUpdated(
        address[] _oldAddresses,
        address[] _newAddresses
    );
    event HarvesterAddressesUpdated(
        address _oldHarvesterAddress,
        address _newHarvesterAddress
    );

    // Core address for the given platform
    address public platformAddress;

    address public vaultAddress;

    // asset => pToken (Platform Specific Token Address)
    mapping(address => address) public assetToPToken;

    // Full list of all assets supported here
    address[] internal assetsMapped;

    // Deprecated: Reward token address
    // slither-disable-next-line constable-states
    address public _deprecated_rewardTokenAddress;

    // Deprecated: now resides in Harvester's rewardTokenConfigs
    // slither-disable-next-line constable-states
    uint256 public _deprecated_rewardLiquidationThreshold;

    // Address of the one address allowed to collect reward tokens
    address public harvesterAddress;

    // Reward token addresses
    address[] public rewardTokenAddresses;
    /* Reserved for future expansion. Used to be 100 storage slots
     * and has decreased to accommodate:
     * - harvesterAddress
     * - rewardTokenAddresses
     */
    int256[98] private _reserved;

    /**
     * @dev Internal initialize function, to set up initial internal state
     * @param _platformAddress Generic platform address
     * @param _vaultAddress Address of the Vault
     * @param _rewardTokenAddresses Address of reward token for platform
     * @param _assets Addresses of initial supported assets
     * @param _pTokens Platform Token corresponding addresses
     */
    function initialize(
        address _platformAddress,
        address _vaultAddress,
        address[] calldata _rewardTokenAddresses,
        address[] calldata _assets,
        address[] calldata _pTokens
    ) external onlyGovernor initializer {
        InitializableAbstractStrategy._initialize(
            _platformAddress,
            _vaultAddress,
            _rewardTokenAddresses,
            _assets,
            _pTokens
        );
    }

    function _initialize(
        address _platformAddress,
        address _vaultAddress,
        address[] calldata _rewardTokenAddresses,
        address[] memory _assets,
        address[] memory _pTokens
    ) internal {
        platformAddress = _platformAddress;
        vaultAddress = _vaultAddress;
        rewardTokenAddresses = _rewardTokenAddresses;

        uint256 assetCount = _assets.length;
        require(assetCount == _pTokens.length, "Invalid input arrays");
        for (uint256 i = 0; i < assetCount; i++) {
            _setPTokenAddress(_assets[i], _pTokens[i]);
        }
    }

    /**
     * @dev Collect accumulated reward token and send to Vault.
     */
    function collectRewardTokens() external virtual onlyHarvester nonReentrant {
        _collectRewardTokens();
    }

    function _collectRewardTokens() internal {
        for (uint256 i = 0; i < rewardTokenAddresses.length; i++) {
            IERC20 rewardToken = IERC20(rewardTokenAddresses[i]);
            uint256 balance = rewardToken.balanceOf(address(this));
            emit RewardTokenCollected(
                harvesterAddress,
                rewardTokenAddresses[i],
                balance
            );
            rewardToken.safeTransfer(harvesterAddress, balance);
        }
    }

    /**
     * @dev Verifies that the caller is the Vault.
     */
    modifier onlyVault() {
        require(msg.sender == vaultAddress, "Caller is not the Vault");
        _;
    }

    /**
     * @dev Verifies that the caller is the Harvester.
     */
    modifier onlyHarvester() {
        require(msg.sender == harvesterAddress, "Caller is not the Harvester");
        _;
    }

    /**
     * @dev Verifies that the caller is the Vault or Governor.
     */
    modifier onlyVaultOrGovernor() {
        require(
            msg.sender == vaultAddress || msg.sender == governor(),
            "Caller is not the Vault or Governor"
        );
        _;
    }

    /**
     * @dev Verifies that the caller is the Vault, Governor, or Strategist.
     */
    modifier onlyVaultOrGovernorOrStrategist() {
        require(
            msg.sender == vaultAddress ||
                msg.sender == governor() ||
                msg.sender == IVault(vaultAddress).strategistAddr(),
            "Caller is not the Vault, Governor, or Strategist"
        );
        _;
    }

    /**
     * @dev Set the reward token addresses.
     * @param _rewardTokenAddresses Address array of the reward token
     */
    function setRewardTokenAddresses(address[] calldata _rewardTokenAddresses)
        external
        onlyGovernor
    {
        for (uint256 i = 0; i < _rewardTokenAddresses.length; i++) {
            require(
                _rewardTokenAddresses[i] != address(0),
                "Can not set an empty address as a reward token"
            );
        }

        emit RewardTokenAddressesUpdated(
            rewardTokenAddresses,
            _rewardTokenAddresses
        );
        rewardTokenAddresses = _rewardTokenAddresses;
    }

    /**
     * @dev Get the reward token addresses.
     * @return address[] the reward token addresses.
     */
    function getRewardTokenAddresses()
        external
        view
        returns (address[] memory)
    {
        return rewardTokenAddresses;
    }

    /**
     * @dev Provide support for asset by passing its pToken address.
     *      This method can only be called by the system Governor
     * @param _asset    Address for the asset
     * @param _pToken   Address for the corresponding platform token
     */
    function setPTokenAddress(address _asset, address _pToken)
        external
        onlyGovernor
    {
        _setPTokenAddress(_asset, _pToken);
    }

    /**
     * @dev Remove a supported asset by passing its index.
     *      This method can only be called by the system Governor
     * @param _assetIndex Index of the asset to be removed
     */
    function removePToken(uint256 _assetIndex) external onlyGovernor {
        require(_assetIndex < assetsMapped.length, "Invalid index");
        address asset = assetsMapped[_assetIndex];
        address pToken = assetToPToken[asset];

        if (_assetIndex < assetsMapped.length - 1) {
            assetsMapped[_assetIndex] = assetsMapped[assetsMapped.length - 1];
        }
        assetsMapped.pop();
        assetToPToken[asset] = address(0);

        emit PTokenRemoved(asset, pToken);
    }

    /**
     * @dev Provide support for asset by passing its pToken address.
     *      Add to internal mappings and execute the platform specific,
     * abstract method `_abstractSetPToken`
     * @param _asset    Address for the asset
     * @param _pToken   Address for the corresponding platform token
     */
    function _setPTokenAddress(address _asset, address _pToken) internal {
        require(assetToPToken[_asset] == address(0), "pToken already set");
        require(
            _asset != address(0) && _pToken != address(0),
            "Invalid addresses"
        );

        assetToPToken[_asset] = _pToken;
        assetsMapped.push(_asset);

        emit PTokenAdded(_asset, _pToken);

        _abstractSetPToken(_asset, _pToken);
    }

    /**
     * @dev Transfer token to governor. Intended for recovering tokens stuck in
     *      strategy contracts, i.e. mistaken sends.
     * @param _asset Address for the asset
     * @param _amount Amount of the asset to transfer
     */
    function transferToken(address _asset, uint256 _amount)
        public
        onlyGovernor
    {
        IERC20(_asset).safeTransfer(governor(), _amount);
    }

    /**
     * @dev Set the reward token addresses.
     * @param _harvesterAddress Address of the harvester
     */
    function setHarvesterAddress(address _harvesterAddress)
        external
        onlyGovernor
    {
        harvesterAddress = _harvesterAddress;
        emit HarvesterAddressesUpdated(harvesterAddress, _harvesterAddress);
    }

    /***************************************
                 Abstract
    ****************************************/

    function _abstractSetPToken(address _asset, address _pToken)
        internal
        virtual;

    function safeApproveAllTokens() external virtual;

    /**
     * @dev Deposit an amount of asset into the platform
     * @param _asset               Address for the asset
     * @param _amount              Units of asset to deposit
     */
    function deposit(address _asset, uint256 _amount) external virtual;

    /**
     * @dev Deposit balance of all supported assets into the platform
     */
    function depositAll() external virtual;

    /**
     * @dev Withdraw an amount of asset from the platform.
     * @param _recipient         Address to which the asset should be sent
     * @param _asset             Address of the asset
     * @param _amount            Units of asset to withdraw
     */
    function withdraw(
        address _recipient,
        address _asset,
        uint256 _amount
    ) external virtual;

    /**
     * @dev Withdraw all assets from strategy sending assets to Vault.
     */
    function withdrawAll() external virtual;

    /**
     * @dev Get the total asset value held in the platform.
     *      This includes any interest that was generated since depositing.
     * @param _asset      Address of the asset
     * @return balance    Total value of the asset in the platform
     */
    function checkBalance(address _asset)
        external
        view
        virtual
        returns (uint256 balance);

    /**
     * @dev Check if an asset is supported.
     * @param _asset    Address of the asset
     * @return bool     Whether asset is supported
     */
    function supportsAsset(address _asset) external view virtual returns (bool);
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

import { IBasicToken } from "../interfaces/IBasicToken.sol";

library Helpers {
    /**
     * @notice Fetch the `symbol()` from an ERC20 token
     * @dev Grabs the `symbol()` from a contract
     * @param _token Address of the ERC20 token
     * @return string Symbol of the ERC20 token
     */
    function getSymbol(address _token) internal view returns (string memory) {
        string memory symbol = IBasicToken(_token).symbol();
        return symbol;
    }

    /**
     * @notice Fetch the `decimals()` from an ERC20 token
     * @dev Grabs the `decimals()` from a contract and fails if
     *      the decimal value does not live within a certain range
     * @param _token Address of the ERC20 token
     * @return uint256 Decimals of the ERC20 token
     */
    function getDecimals(address _token) internal view returns (uint256) {
        uint256 decimals = IBasicToken(_token).decimals();
        require(
            decimals >= 4 && decimals <= 18,
            "Token must have sufficient decimal places"
        );

        return decimals;
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(
            initializing || !initialized,
            "Initializable: contract is already initialized"
        );

        bool isTopLevelCall = !initializing;
        if (isTopLevelCall) {
            initializing = true;
            initialized = true;
        }

        _;

        if (isTopLevelCall) {
            initializing = false;
        }
    }

    uint256[50] private ______gap;
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

/**
 * @title OUSD Governable Contract
 * @dev Copy of the openzeppelin Ownable.sol contract with nomenclature change
 *      from owner to governor and renounce methods removed. Does not use
 *      Context.sol like Ownable.sol does for simplification.
 * @author Origin Protocol Inc
 */
contract Governable {
    // Storage position of the owner and pendingOwner of the contract
    // keccak256("OUSD.governor");
    bytes32 private constant governorPosition =
        0x7bea13895fa79d2831e0a9e28edede30099005a50d652d8957cf8a607ee6ca4a;

    // keccak256("OUSD.pending.governor");
    bytes32 private constant pendingGovernorPosition =
        0x44c4d30b2eaad5130ad70c3ba6972730566f3e6359ab83e800d905c61b1c51db;

    // keccak256("OUSD.reentry.status");
    bytes32 private constant reentryStatusPosition =
        0x53bf423e48ed90e97d02ab0ebab13b2a235a6bfbe9c321847d5c175333ac4535;

    // See OpenZeppelin ReentrancyGuard implementation
    uint256 constant _NOT_ENTERED = 1;
    uint256 constant _ENTERED = 2;

    event PendingGovernorshipTransfer(
        address indexed previousGovernor,
        address indexed newGovernor
    );

    event GovernorshipTransferred(
        address indexed previousGovernor,
        address indexed newGovernor
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial Governor.
     */
    constructor() {
        _setGovernor(msg.sender);
        emit GovernorshipTransferred(address(0), _governor());
    }

    /**
     * @dev Returns the address of the current Governor.
     */
    function governor() public view returns (address) {
        return _governor();
    }

    /**
     * @dev Returns the address of the current Governor.
     */
    function _governor() internal view returns (address governorOut) {
        bytes32 position = governorPosition;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            governorOut := sload(position)
        }
    }

    /**
     * @dev Returns the address of the pending Governor.
     */
    function _pendingGovernor()
        internal
        view
        returns (address pendingGovernor)
    {
        bytes32 position = pendingGovernorPosition;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            pendingGovernor := sload(position)
        }
    }

    /**
     * @dev Throws if called by any account other than the Governor.
     */
    modifier onlyGovernor() {
        require(isGovernor(), "Caller is not the Governor");
        _;
    }

    /**
     * @dev Returns true if the caller is the current Governor.
     */
    function isGovernor() public view returns (bool) {
        return msg.sender == _governor();
    }

    function _setGovernor(address newGovernor) internal {
        bytes32 position = governorPosition;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            sstore(position, newGovernor)
        }
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        bytes32 position = reentryStatusPosition;
        uint256 _reentry_status;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            _reentry_status := sload(position)
        }

        // On the first call to nonReentrant, _notEntered will be true
        require(_reentry_status != _ENTERED, "Reentrant call");

        // Any calls to nonReentrant after this point will fail
        // solhint-disable-next-line no-inline-assembly
        assembly {
            sstore(position, _ENTERED)
        }

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        // solhint-disable-next-line no-inline-assembly
        assembly {
            sstore(position, _NOT_ENTERED)
        }
    }

    function _setPendingGovernor(address newGovernor) internal {
        bytes32 position = pendingGovernorPosition;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            sstore(position, newGovernor)
        }
    }

    /**
     * @dev Transfers Governance of the contract to a new account (`newGovernor`).
     * Can only be called by the current Governor. Must be claimed for this to complete
     * @param _newGovernor Address of the new Governor
     */
    function transferGovernance(address _newGovernor) external onlyGovernor {
        _setPendingGovernor(_newGovernor);
        emit PendingGovernorshipTransfer(_governor(), _newGovernor);
    }

    /**
     * @dev Claim Governance of the contract to a new account (`newGovernor`).
     * Can only be called by the new Governor.
     */
    function claimGovernance() external {
        require(
            msg.sender == _pendingGovernor(),
            "Only the pending Governor can complete the claim"
        );
        _changeGovernor(msg.sender);
    }

    /**
     * @dev Change Governance of the contract to a new account (`newGovernor`).
     * @param _newGovernor Address of the new Governor
     */
    function _changeGovernor(address _newGovernor) internal {
        require(_newGovernor != address(0), "New Governor is address(0)");
        emit GovernorshipTransferred(_governor(), _newGovernor);
        _setGovernor(_newGovernor);
    }
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.0;

interface IBasicToken {
    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.8.4;

interface ICurveMetaPool {
    function add_liquidity(uint256[2] calldata amounts, uint256 min_mint_amount)
        external
        returns (uint256);

    function get_virtual_price() external view returns (uint256);

    function remove_liquidity(uint256 _amount, uint256[2] calldata min_amounts)
        external
        returns (uint256[2] calldata);

    function remove_liquidity_one_coin(
        uint256 _token_amount,
        int128 i,
        uint256 min_amount
    ) external returns (uint256);

    function remove_liquidity_imbalance(
        uint256[2] calldata amounts,
        uint256 max_burn_amount
    ) external returns (uint256);

    function calc_withdraw_one_coin(uint256 _token_amount, int128 i)
        external
        view
        returns (uint256);

    function balances(uint256 i) external view returns (uint256);

    function calc_token_amount(uint256[2] calldata amounts, bool deposit)
        external
        view
        returns (uint256);

    function base_pool() external view returns (address);

    function fee() external view returns (uint256);

    function coins(uint256 i) external view returns (address);

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    ) external returns (uint256);

    function get_dy(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256);
}