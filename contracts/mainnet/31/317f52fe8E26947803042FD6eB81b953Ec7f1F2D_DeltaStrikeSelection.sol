// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

import "../utils/Context.sol";

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)

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
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
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

// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

interface IStrikeSelection {
    function getStrikePrice(uint256 expiryTimestamp, bool isPut) external view returns (uint256, uint256);

    function delta() external view returns (uint256);
}

interface IOptionsPremiumPricer {
    function getPremium(
        uint256 strikePrice,
        uint256 timeToExpiry,
        bool isPut
    ) external view returns (uint256);

    function getPremiumInStables(
        uint256 strikePrice,
        uint256 timeToExpiry,
        bool isPut
    ) external view returns (uint256);

    function getOptionDelta(
        uint256 spotPrice,
        uint256 strikePrice,
        uint256 volatility,
        uint256 expiryTimestamp
    ) external view returns (uint256 delta);

    function getUnderlyingPrice() external view returns (uint256);

    function priceOracle() external view returns (address);

    function volatilityOracle() external view returns (address);

    function optionId() external view returns (bytes32);
}

// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

interface IPriceOracle {
    function decimals() external view returns (uint256 _decimals);

    function latestAnswer() external view returns (uint256 price);
}

// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

library Vault {
    /************************************************
     *  IMMUTABLES & CONSTANTS
     ***********************************************/

    // Fees are 6-decimal places. For example: 20 * 10**6 = 20%
    uint256 internal constant FEE_MULTIPLIER = 10**6;

    // Premium discount has 1-decimal place. For example: 80 * 10**1 = 80%. Which represents a 20% discount.
    uint256 internal constant PREMIUM_DISCOUNT_MULTIPLIER = 10;

    struct CollateralVaultParams {
        // Option type the vault is selling
        bool isPut;
        // Token decimals for vault shares
        uint8 decimals;
        // Neuron pool address
        address collateralAsset;
        // Underlying asset of the options sold by vault
        address underlying;
        // Minimum supply of the vault shares issued, for ETH it's 10**10
        uint56 minimumSupply;
        // Vault cap
        uint104 cap;
    }

    struct CollateralUpdate {
        address[] newCollateralVaults;
        address[] newCollateralAssets;
    }

    struct VaultParams {
        // Option type the vault is selling
        bool isPut;
        // Asset used in Theta / Delta Vault
        address[] collateralAssets;
        // Underlying asset of the options sold by vault
        address underlying;
        // Addresses of collateral vaults for collateral assets
        address[] collateralVaults;
    }

    struct AuctionParams {
        // Auction duration
        uint256 auctionDuration;
        // Auction bid token address
        address auctionBiddingToken;
    }

    struct OptionState {
        // Option that the vault is shorting / longing in the next cycle
        address nextOption;
        // Option that the vault is currently shorting / longing
        address currentOption;
        // The timestamp when the `nextOption` can be used by the vault
        uint32 nextOptionReadyAt;
    }

    struct CollateralVaultState {
        // 32 byte slot 1
        //  Current round number. `round` represents the number of `period`s elapsed.
        uint16 round;
        // Amount that is currently locked for selling options
        uint104 lockedAmount;
        // Amount that was locked for selling options in the previous round
        // used for calculating performance fee deduction
        uint104 lastLockedAmount;
        // 32 byte slot 2
        // Stores the total tally of how much of `asset` there is
        // to be used to mint nTHETA tokens
        uint128 totalPending;
        // Amount locked for scheduled withdrawals;
        uint128 queuedWithdrawShares;
        bool isDisabled;
    }

    struct VaultState {
        // 32 byte slot 1
        //  Current round number. `round` represents the number of `period`s elapsed.
        uint16 round;
        // Amount that is currently locked for selling options
        uint104 lockedValue;
        // Amount that was locked for selling options in the previous round
        // used for calculating performance fee deduction
        uint104 lastLockedValue;
    }

    struct DepositReceipt {
        // Maximum of 65535 rounds. Assuming 1 round is 7 days, maximum is 1256 years.
        uint16 round;
        // Deposit amount, max 20,282,409,603,651 or 20 trillion ETH deposit
        uint104 amount;
        // Unredeemed shares balance
        uint128 unredeemedShares;
    }

    struct Withdrawal {
        // Maximum of 65535 rounds. Assuming 1 round is 7 days, maximum is 1256 years.
        uint16 round;
        // Number of shares withdrawn
        uint128 shares;
    }

    struct AuctionSellOrder {
        // Amount of `asset` token offered in auction
        uint96 sellAmount;
        // Amount of onToken requested in auction
        uint96 buyAmount;
        // User Id of delta vault in latest gnosis auction
        uint64 userId;
    }
}

// SPDX-License-Identifier: GPL-3.0
pragma solidity >0.7.0;

interface IManualVolatilityOracle {
    function vol(bytes32 optionId) external view returns (uint256 standardDeviation);

    function annualizedVol(bytes32 optionId) external view returns (uint256 annualStdev);

    function setAnnualizedVol(bytes32[] calldata optionIds, uint256[] calldata newAnnualizedVols) external;
}

// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.9;

import { SafeMath } from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IPriceOracle } from "../interfaces/IPriceOracle.sol";
import { IOptionsPremiumPricer } from "../interfaces/INeuron.sol";
import { IManualVolatilityOracle } from "../tests/interfaces/IManualVolatilityOracle.sol";
import { Vault } from "../libraries/Vault.sol";

contract DeltaStrikeSelection is Ownable {
    using SafeMath for uint256;

    /**
     * Immutables
     */
    IOptionsPremiumPricer public immutable optionsPremiumPricer;

    IManualVolatilityOracle public immutable volatilityOracle;

    // delta for options strike price selection. 1 is 10000 (10**4)
    uint256 public delta;

    // step in absolute terms at which we will increment
    // (ex: 100 * 10 ** assetOracleDecimals means we will move at increments of 100 points)
    uint256 public step;

    // multiplier to shift asset prices
    uint256 private immutable assetOracleMultiplier;

    // Delta are in 4 decimal places. 1 * 10**4 = 1 delta.
    uint256 private constant DELTA_MULTIPLIER = 10**4;

    // ChainLink's USD Price oracles return results in 8 decimal places
    uint256 private constant ORACLE_PRICE_MULTIPLIER = 10**8;

    event DeltaSet(uint256 oldDelta, uint256 newDelta, address indexed owner);
    event StepSet(uint256 oldStep, uint256 newStep, address indexed owner);

    constructor(
        address _optionsPremiumPricer,
        uint256 _delta,
        uint256 _step
    ) {
        require(_optionsPremiumPricer != address(0), "!_optionsPremiumPricer");
        require(_delta > 0, "!_delta");
        require(_delta <= DELTA_MULTIPLIER, "newDelta cannot be more than 1");
        require(_step > 0, "!_step");

        optionsPremiumPricer = IOptionsPremiumPricer(_optionsPremiumPricer);
        volatilityOracle = IManualVolatilityOracle(IOptionsPremiumPricer(_optionsPremiumPricer).volatilityOracle());
        // ex: delta = 7500 (.75)
        delta = _delta;
        uint256 _assetOracleMultiplier = 10 **
            IPriceOracle(IOptionsPremiumPricer(_optionsPremiumPricer).priceOracle()).decimals();

        // ex: step = 1000
        step = _step.mul(_assetOracleMultiplier);

        assetOracleMultiplier = _assetOracleMultiplier;
    }

    /**
     * @notice Gets the strike price satisfying the delta value
     * given the expiry timestamp and whether option is call or put
     * @param expiryTimestamp is the unix timestamp of expiration
     * @param isPut is whether option is put or call
     * @return newStrikePrice is the strike price of the option (ex: for BTC might be 45000 * 10 ** 8)
     * @return newDelta is the delta of the option given its parameters
     */
    function getStrikePrice(uint256 expiryTimestamp, bool isPut)
        external
        view
        returns (uint256 newStrikePrice, uint256 newDelta)
    {
        // asset's annualized volatility
        uint256 annualizedVol = volatilityOracle.annualizedVol(optionsPremiumPricer.optionId()).mul(10**10);
        return _getStrikePrice(expiryTimestamp, isPut, annualizedVol);
    }

    /**
     * @notice Gets the strike price satisfying the delta value
     * given the expiry timestamp and whether option is call or put
     * @param expiryTimestamp is the unix timestamp of expiration
     * @param isPut is whether option is put or call
     * @param annualizedVol is IV of the asset at the specified delta
     * @return newStrikePrice is the strike price of the option (ex: for BTC might be 45000 * 10 ** 8)
     * @return newDelta is the delta of the option given its parameters
     */
    function getStrikePriceWithVol(
        uint256 expiryTimestamp,
        bool isPut,
        uint256 annualizedVol
    ) external view returns (uint256 newStrikePrice, uint256 newDelta) {
        return _getStrikePrice(expiryTimestamp, isPut, annualizedVol.mul(10**10));
    }

    /**
     * @notice Gets the strike price satisfying the delta value
     * given the expiry timestamp and whether option is call or put
     * @param expiryTimestamp is the unix timestamp of expiration
     * @param isPut is whether option is put or call
     * @return newStrikePrice is the strike price of the option (ex: for BTC might be 45000 * 10 ** 8)
     * @return newDelta is the delta of the option given its parameters
     */

    function _getStrikePrice(
        uint256 expiryTimestamp,
        bool isPut,
        uint256 annualizedVol
    ) internal view returns (uint256 newStrikePrice, uint256 newDelta) {
        require(expiryTimestamp > block.timestamp, "Expiry must be in the future!");

        // asset price
        uint256 assetPrice = optionsPremiumPricer.getUnderlyingPrice();

        // For each asset prices with step of 'step' (down if put, up if call)
        //   if asset's getOptionDelta(currStrikePrice, spotPrice, annualizedVol, t) == (isPut ? 1 - delta:delta)
        //   with certain margin of error
        //        return strike price

        uint256 strike = isPut
            ? assetPrice.sub(assetPrice % step).sub(step)
            : assetPrice.add(step - (assetPrice % step)).add(step);
        uint256 targetDelta = isPut ? DELTA_MULTIPLIER.sub(delta) : delta;
        uint256 prevDelta = isPut ? 0 : DELTA_MULTIPLIER;

        while (true) {
            uint256 currDelta = optionsPremiumPricer.getOptionDelta(
                assetPrice.mul(ORACLE_PRICE_MULTIPLIER).div(assetOracleMultiplier),
                strike,
                annualizedVol,
                expiryTimestamp
            );
            //  If the current delta is between the previous
            //  strike price delta and current strike price delta
            //  then we are done
            bool foundTargetStrikePrice = isPut
                ? targetDelta >= prevDelta && targetDelta <= currDelta
                : targetDelta <= prevDelta && targetDelta >= currDelta;

            if (foundTargetStrikePrice) {
                uint256 finalDelta = _getBestDelta(prevDelta, currDelta, targetDelta, isPut);
                uint256 finalStrike = _getBestStrike(finalDelta, prevDelta, strike, isPut);
                require(isPut ? finalStrike <= assetPrice : finalStrike >= assetPrice, "Invalid strike price");
                // make decimals consistent with onToken strike price decimals (10 ** 8)
                return (finalStrike.mul(ORACLE_PRICE_MULTIPLIER).div(assetOracleMultiplier), finalDelta);
            }

            strike = isPut ? strike.sub(step) : strike.add(step);

            prevDelta = currDelta;
        }
    }

    /**
     * @notice Rounds to best delta value
     * @param prevDelta is the delta of the previous strike price
     * @param currDelta is delta of the current strike price
     * @param targetDelta is the delta we are targeting
     * @param isPut is whether its a put
     * @return the best delta value
     */
    function _getBestDelta(
        uint256 prevDelta,
        uint256 currDelta,
        uint256 targetDelta,
        bool isPut
    ) private pure returns (uint256) {
        uint256 finalDelta;

        // for tie breaks (ex: 0.05 <= 0.1 <= 0.15) round to higher strike price
        // for calls and lower strike price for puts for deltas
        if (isPut) {
            uint256 upperBoundDiff = currDelta.sub(targetDelta);
            uint256 lowerBoundDiff = targetDelta.sub(prevDelta);
            finalDelta = lowerBoundDiff <= upperBoundDiff ? prevDelta : currDelta;
        } else {
            uint256 upperBoundDiff = prevDelta.sub(targetDelta);
            uint256 lowerBoundDiff = targetDelta.sub(currDelta);
            finalDelta = lowerBoundDiff <= upperBoundDiff ? currDelta : prevDelta;
        }

        return finalDelta;
    }

    /**
     * @notice Rounds to best delta value
     * @param finalDelta is the best delta value we found
     * @param prevDelta is delta of the previous strike price
     * @param strike is the strike of the previous iteration
     * @param isPut is whether its a put
     * @return the best strike
     */
    function _getBestStrike(
        uint256 finalDelta,
        uint256 prevDelta,
        uint256 strike,
        bool isPut
    ) private view returns (uint256) {
        if (finalDelta != prevDelta) {
            return strike;
        }
        return isPut ? strike.add(step) : strike.sub(step);
    }

    /**
     * @notice Sets new delta value
     * @param newDelta is the new delta value
     */
    function setDelta(uint256 newDelta) external onlyOwner {
        require(newDelta > 0, "!newDelta");
        require(newDelta <= DELTA_MULTIPLIER, "newDelta cannot be more than 1");
        uint256 oldDelta = delta;
        delta = newDelta;
        emit DeltaSet(oldDelta, newDelta, msg.sender);
    }

    /**
     * @notice Sets new step value
     * @param newStep is the new step value
     */
    function setStep(uint256 newStep) external onlyOwner {
        require(newStep > 0, "!newStep");
        uint256 oldStep = step;
        step = newStep.mul(assetOracleMultiplier);
        emit StepSet(oldStep, newStep, msg.sender);
    }
}