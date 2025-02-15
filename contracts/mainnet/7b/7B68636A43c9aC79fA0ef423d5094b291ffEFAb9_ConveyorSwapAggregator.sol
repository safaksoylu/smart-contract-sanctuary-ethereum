// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function decimals() external view returns (uint8);
}

// SPDX-License-Identifier: PLACEHOLDER
pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.16;

error InsufficientWalletBalance(
    address account,
    uint256 balance,
    uint256 balanceNeeded
);
error OrderDoesNotExist(bytes32 orderId);
error OrderQuantityIsZero();
error InsufficientOrderInputValue();
error IncongruentInputTokenInOrderGroup(address token, address expectedToken);
error TokenInIsTokenOut();
error IncongruentOutputTokenInOrderGroup(address token, address expectedToken);
error InsufficientOutputAmount(uint256 amountOut, uint256 expectedAmountOut);
error InsufficientInputAmount(uint256 amountIn, uint256 expectedAmountIn);
error InsufficientLiquidity();
error InsufficientAllowanceForOrderPlacement(
    address token,
    uint256 approvedQuantity,
    uint256 approvedQuantityNeeded
);
error InsufficientAllowanceForOrderUpdate(
    address token,
    uint256 approvedQuantity,
    uint256 approvedQuantityNeeded
);
error InvalidOrderGroupSequence();
error IncongruentFeeInInOrderGroup();
error IncongruentFeeOutInOrderGroup();
error IncongruentTaxedTokenInOrderGroup();
error IncongruentStoplossStatusInOrderGroup();
error IncongruentBuySellStatusInOrderGroup();
error NonEOAStoplossExecution();
error MsgSenderIsNotTxOrigin();
error MsgSenderIsNotLimitOrderRouter();
error MsgSenderIsNotLimitOrderExecutor();
error MsgSenderIsNotSandboxRouter();
error MsgSenderIsNotOwner();
error MsgSenderIsNotOrderOwner();
error MsgSenderIsNotOrderBook();
error MsgSenderIsNotLimitOrderBook();
error MsgSenderIsNotTempOwner();
error Reentrancy();
error ETHTransferFailed();
error InvalidAddress();
error UnauthorizedUniswapV3CallbackCaller();
error DuplicateOrderIdsInOrderGroup();
error InvalidCalldata();
error InsufficientMsgValue();
error UnauthorizedCaller();
error AmountInIsZero();
///@notice Returns the index of the call that failed within the SandboxRouter.Call[] array
error SandboxCallFailed(uint256 callIndex);
error InvalidTransferAddressArray();
error AddressIsZero();
error IdenticalTokenAddresses();
error InvalidInputTokenForOrderPlacement();
error SandboxFillAmountNotSatisfied(
    bytes32 orderId,
    uint256 amountFilled,
    uint256 fillAmountRequired
);
error OrderNotEligibleForRefresh(bytes32 orderId);

error SandboxAmountOutRequiredNotSatisfied(
    bytes32 orderId,
    uint256 amountOut,
    uint256 amountOutRequired
);

error AmountOutRequiredIsZero(bytes32 orderId);

error FillAmountSpecifiedGreaterThanAmountRemaining(
    uint256 fillAmountSpecified,
    uint256 amountInRemaining,
    bytes32 orderId
);
error ConveyorFeesNotPaid(
    uint256 expectedFees,
    uint256 feesPaid,
    uint256 unpaidFeesRemaining
);
error InsufficientFillAmountSpecified(
    uint128 fillAmountSpecified,
    uint128 amountInRemaining
);
error InsufficientExecutionCredit(uint256 msgValue, uint256 minExecutionCredit);
error WithdrawAmountExceedsExecutionCredit(
    uint256 amount,
    uint256 executionCredit
);
error MsgValueIsNotCumulativeExecutionCredit(
    uint256 msgValue,
    uint256 cumulativeExecutionCredit
);

error ExecutorNotCheckedIn();
error InvalidToAddressBits();
error V2SwapFailed();
error V3SwapFailed();

// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.16;

import "../lib/interfaces/token/IERC20.sol";
import "./ConveyorErrors.sol";
import "../lib/interfaces/uniswap-v2/IUniswapV2Pair.sol";

interface IConveyorSwapExecutor {
    function executeMulticall(
        ConveyorSwapAggregator.SwapAggregatorMulticall
            calldata swapAggregatorMulticall,
        uint256 amountIn,
        address receiver
    ) external;
}

/// @title ConveyorSwapAggregator
/// @author 0xKitsune, 0xOsiris, Conveyor Labs
/// @notice Multicall contract for token Swaps.
contract ConveyorSwapAggregator {
    address public immutable CONVEYOR_SWAP_EXECUTOR;
    address public immutable WETH;
    /**@notice Event that is emitted when a token to token swap has filled successfully.
     **/
    event Swap(
        address indexed tokenIn,
        uint256 amountIn,
        address indexed tokenOut,
        uint256 amountOut,
        address indexed receiver
    );

    /**@notice Event that is emitted when a token to ETH swap has filled successfully.
     **/
    event SwapExactTokenForEth(
        address indexed tokenIn,
        uint256 amountIn,
        uint256 amountOut,
        address indexed receiver
    );

    /**@notice Event that is emitted when a ETH to token swap has filled successfully.
     **/
    event SwapExactEthForToken(
        uint256 amountIn,
        address indexed tokenOut,
        uint256 amountOut,
        address indexed receiver
    );

    ///@dev Deploys the ConveyorSwapExecutor contract.
    ///@param _weth Address of Wrapped Native Asset.
    constructor(address _weth) {
        require(_weth != address(0), "WETH address is zero");
        CONVEYOR_SWAP_EXECUTOR = address(
            new ConveyorSwapExecutor(address(this))
        );
        WETH = _weth;
    }

    /// @notice SwapAggregatorMulticall struct for token Swaps.
    /// @param zeroForOneBitmap for zeroForOne bool along the swap calls.
    /// @param isUniV2Bitmap for isUniV2 bool along the swap calls.
    /// @param toAddressBitmap for toAddress address along the swap calls.
    /// @param feeBitmap for uniV2 custom fee's along the swap calls.
    /// @param tokenInDestination Address to send tokenIn to.
    /// @param calls Array of calls to be executed.
    struct SwapAggregatorMulticall {
        uint32 zeroForOneBitmap;
        uint32 isUniV2Bitmap;
        uint64 toAddressBitmap;
        uint128 feeBitmap;
        address tokenInDestination;
        Call[] calls;
    }

    /// @notice Call struct for token Swaps.
    /// @param target Address to call.
    /// @param callData Data to call.
    struct Call {
        address target;
        bytes callData;
    }

    /// @notice Swap tokens for tokens.
    /// @param tokenIn Address of token to swap.
    /// @param amountIn Amount of tokenIn to swap.
    /// @param tokenOut Address of token to receive.
    /// @param amountOutMin Minimum amount of tokenOut to receive.
    /// @param swapAggregatorMulticall Multicall to be executed.
    function swap(
        address tokenIn,
        uint256 amountIn,
        address tokenOut,
        uint256 amountOutMin,
        SwapAggregatorMulticall calldata swapAggregatorMulticall
    ) external {
        ///@notice Transfer tokenIn from msg.sender to tokenInDestination address.
        IERC20(tokenIn).transferFrom(
            msg.sender,
            swapAggregatorMulticall.tokenInDestination,
            amountIn
        );

        ///@notice Get tokenOut balance of msg.sender.
        uint256 balanceBefore = IERC20(tokenOut).balanceOf(msg.sender);
        ///@notice Calculate tokenOut amount required.
        uint256 tokenOutAmountRequired = balanceBefore + amountOutMin;

        ///@notice Execute Multicall.
        IConveyorSwapExecutor(CONVEYOR_SWAP_EXECUTOR).executeMulticall(
            swapAggregatorMulticall,
            amountIn,
            msg.sender
        );

        uint256 balanceAfter = IERC20(tokenOut).balanceOf(msg.sender);

        ///@notice Check if tokenOut balance of msg.sender is sufficient.
        if (balanceAfter < tokenOutAmountRequired) {
            revert InsufficientOutputAmount(
                tokenOutAmountRequired - balanceAfter,
                amountOutMin
            );
        }

        ///@notice Emit Swap event.
        emit Swap(
            tokenIn,
            amountIn,
            tokenOut,
            balanceAfter - balanceBefore,
            msg.sender
        );
    }

    /// @notice Swap ETH for tokens.
    /// @param tokenOut Address of token to receive.
    /// @param amountOutMin Minimum amount of tokenOut to receive.
    /// @param swapAggregatorMulticall Multicall to be executed.
    function swapExactEthForToken(
        address tokenOut,
        uint256 amountOutMin,
        SwapAggregatorMulticall calldata swapAggregatorMulticall
    ) external payable {
        ///@notice Deposit the msg.value into WETH.
        _depositEth(msg.value, WETH);

        ///@notice Transfer WETH from WETH to tokenInDestination address.
        IERC20(WETH).transfer(
            swapAggregatorMulticall.tokenInDestination,
            msg.value
        );
        ///@notice Get tokenOut balance of msg.sender.
        uint256 balanceBefore = IERC20(tokenOut).balanceOf(msg.sender);

        ///@notice Calculate tokenOut amount required.
        uint256 tokenOutAmountRequired = balanceBefore + amountOutMin;

        ///@notice Execute Multicall.
        IConveyorSwapExecutor(CONVEYOR_SWAP_EXECUTOR).executeMulticall(
            swapAggregatorMulticall,
            msg.value,
            msg.sender
        );

        ///@notice Get tokenOut balance of msg.sender after multicall execution.
        uint256 balanceAfter = IERC20(tokenOut).balanceOf(msg.sender);

        ///@notice Revert if tokenOut balance of msg.sender is insufficient.
        if (balanceAfter < tokenOutAmountRequired) {
            revert InsufficientOutputAmount(
                tokenOutAmountRequired - balanceAfter,
                amountOutMin
            );
        }

        ///@notice Emit SwapExactEthForToken event.
        emit SwapExactEthForToken(
            msg.value,
            tokenOut,
            balanceAfter - balanceBefore,
            msg.sender
        );
    }

    /// @notice Swap tokens for ETH.
    /// @param tokenIn Address of token to swap.
    /// @param amountIn Amount of tokenIn to swap.
    /// @param amountOutMin Minimum amount of ETH to receive.
    /// @param swapAggregatorMulticall Multicall to be executed.
    function swapExactTokenForEth(
        address tokenIn,
        uint256 amountIn,
        uint256 amountOutMin,
        SwapAggregatorMulticall calldata swapAggregatorMulticall
    ) external {
        ///@dev Ignore if the tokenInDestination is address(0).
        if (swapAggregatorMulticall.tokenInDestination != address(0)) {
            ///@notice Transfer tokenIn from msg.sender to tokenInDestination address.
            IERC20(tokenIn).transferFrom(
                msg.sender,
                swapAggregatorMulticall.tokenInDestination,
                amountIn
            );
        }
        ///@notice Get ETH balance of msg.sender.
        uint256 balanceBefore = msg.sender.balance;

        ///@notice Calculate amountOutRequired.
        uint256 amountOutRequired = balanceBefore + amountOutMin;

        ///@notice Execute Multicall.
        IConveyorSwapExecutor(CONVEYOR_SWAP_EXECUTOR).executeMulticall(
            swapAggregatorMulticall,
            amountIn,
            msg.sender
        );

        ///@notice Get WETH balance of this contract.
        uint256 balanceWeth = IERC20(WETH).balanceOf(address(this));

        ///@notice Withdraw WETH from this contract.
        _withdrawEth(balanceWeth, WETH);

        ///@notice Transfer ETH to msg.sender.
        _safeTransferETH(msg.sender, address(this).balance);

        ///@notice Revert if Eth balance of the caller is insufficient.
        if (msg.sender.balance < amountOutRequired) {
            revert InsufficientOutputAmount(
                amountOutRequired - msg.sender.balance,
                amountOutMin
            );
        }

        ///@notice Emit SwapExactTokenForEth event.
        emit SwapExactTokenForEth(
            tokenIn,
            amountIn,
            msg.sender.balance - balanceBefore,
            msg.sender
        );
    }

    ///@notice Helper function to transfer ETH.
    function _safeTransferETH(address to, uint256 amount) internal {
        bool success;
        assembly {
            // Transfer the ETH and store if it succeeded or not.
            success := call(gas(), to, amount, 0, 0, 0, 0)
        }

        if (!success) {
            revert ETHTransferFailed();
        }
    }

    /// @notice Helper function to Withdraw ETH from WETH.
    function _withdrawEth(uint256 amount, address weth) internal {
        assembly {
            mstore(
                0x0,
                shl(224, 0x2e1a7d4d) /* keccak256("withdraw(uint256)") */
            )
            mstore(4, amount)
            if iszero(
                call(
                    gas() /* gas */,
                    weth /* to */,
                    0 /* value */,
                    0 /* in */,
                    68 /* in size */,
                    0 /* out */,
                    0 /* out size */
                )
            ) {
                revert("Native Token Withdraw failed", amount)
            }
        }
    }

    /// @notice Helper function to Deposit ETH into WETH.
    function _depositEth(uint256 amount, address weth) internal {
        assembly {
            mstore(0x0, shl(224, 0xd0e30db0)) /* keccak256("deposit()") */
            if iszero(
                call(
                    gas() /* gas */,
                    weth /* to */,
                    amount /* value */,
                    0 /* in */,
                    0 /* in size */,
                    0 /* out */,
                    0 /* out size */
                )
            ) {
                revert("Native token deposit failed", amount)
            }
        }
    }

    /// @notice Fallback receiver function.
    receive() external payable {}
}

/// @title ConveyorSwapExecutor
/// @author 0xOsiris, 0xKitsune, Conveyor Labs
/// @notice Optimized multicall execution contract.
contract ConveyorSwapExecutor {
    address immutable CONVEYOR_SWAP_AGGREGATOR;

    ///@param conveyorSwapAggregator Address of the ConveyorSwapAggregator contract.
    constructor(address conveyorSwapAggregator) {
        CONVEYOR_SWAP_AGGREGATOR = conveyorSwapAggregator;
    }

    ///@notice Executes a multicall.
    ///@param swapAggregatorMulticall Multicall to be executed.
    ///@param amountIn Amount of tokenIn to swap.
    ///@param recipient Recipient of the output tokens.
    function executeMulticall(
        ConveyorSwapAggregator.SwapAggregatorMulticall
            calldata swapAggregatorMulticall,
        uint256 amountIn,
        address payable recipient
    ) public {
        ///@notice Get the length of the calls array.
        uint256 callsLength = swapAggregatorMulticall.calls.length;

        ///@notice Create a bytes array to store the calldata for v2 swaps.
        bytes memory callData;

        ///@notice Cache the feeBitmap in memory.
        uint128 feeBitmap = swapAggregatorMulticall.feeBitmap;
        ///@notice Iterate through the calls array.
        for (uint256 i = 0; i < callsLength; ) {
            ///@notice Get the call from the calls array.
            ConveyorSwapAggregator.Call memory call = swapAggregatorMulticall
                .calls[i];

            ///@notice Get the zeroForOne value from the zeroForOneBitmap.
            bool zeroForOne = deriveBoolFromBitmap(
                swapAggregatorMulticall.zeroForOneBitmap,
                i
            );
            ///@notice Check if the call is a v2 swap.
            if (
                deriveBoolFromBitmap(swapAggregatorMulticall.isUniV2Bitmap, i)
            ) {
                ///@notice Instantiate the receiver address for the v2 swap.
                address receiver;
                {
                    ///@notice Get the toAddressBitPattern from the toAddressBitmap.
                    uint256 toAddressBitPattern = deriveToAddressFromBitmap(
                        swapAggregatorMulticall.toAddressBitmap,
                        i
                    );
                    ///@notice Set the receiver address based on the toAddressBitPattern.
                    if (toAddressBitPattern == 0x3) {
                        if (i == callsLength - 1) {
                            revert InvalidToAddressBits();
                        }
                        receiver = swapAggregatorMulticall.calls[i + 1].target;
                    } else if (toAddressBitPattern == 0x2) {
                        receiver = address(this);
                    } else if (toAddressBitPattern == 0x1) {
                        receiver = recipient;
                    } else {
                        receiver = CONVEYOR_SWAP_AGGREGATOR;
                    }
                }

                ///@notice Construct the calldata for the v2 swap.
                (callData, amountIn, feeBitmap) = constructV2SwapCalldata(
                    amountIn,
                    zeroForOne,
                    receiver,
                    call.target,
                    feeBitmap
                );

                ///@notice Execute the v2 swap.
                (bool success, ) = call.target.call(callData);

                if (!success) {
                    revert V2SwapFailed();
                }
            } else {
                ///@notice Execute the v3 swap.
                (bool success, bytes memory data) = call.target.call(
                    call.callData
                );
                if (!success) {
                    revert V3SwapFailed();
                }
                ///@notice Decode the amountIn from the v3 swap.
                (int256 amount0, int256 amount1) = abi.decode(
                    data,
                    (int256, int256)
                );

                amountIn = zeroForOne ? uint256(-amount1) : uint256(-amount0);
            }

            unchecked {
                ++i;
            }
        }
    }

    ///@notice Uniswap V3 callback function called during a swap on a v3 liqudity pool.
    ///@param amount0Delta - The change in token0 reserves from the swap.
    ///@param amount1Delta - The change in token1 reserves from the swap.
    ///@param data - The data packed into the swap.
    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external {
        ///@notice Decode all of the swap data.
        (bool _zeroForOne, address tokenIn, address _sender) = abi.decode(
            data,
            (bool, address, address)
        );

        ///@notice Set amountIn to the amountInDelta depending on boolean zeroForOne.
        uint256 amountIn = _zeroForOne
            ? uint256(amount0Delta)
            : uint256(amount1Delta);

        if (!(_sender == address(this))) {
            ///@notice Transfer the amountIn of tokenIn to the liquidity pool from the sender.
            IERC20(tokenIn).transferFrom(_sender, msg.sender, amountIn);
        } else {
            IERC20(tokenIn).transfer(msg.sender, amountIn);
        }
    }

    ///@notice Constructs the calldata for a v2 swap.
    ///@param amountIn - The amount of tokenIn to swap.
    ///@param zeroForOne - The direction of the swap.
    ///@param to - The address to send the swapped tokens to.
    ///@param pool - The address of the v2 liquidity pool.
    ///@param feeBitmap - The bitmap of fees to use for the swap.
    ///@return callData - The calldata for the v2 swap.
    ///@return amountOut - The amount of tokenOut received from the swap.
    ///@return updatedFeeBitmap - The updated feeBitmap.
    function constructV2SwapCalldata(
        uint256 amountIn,
        bool zeroForOne,
        address to,
        address pool,
        uint128 feeBitmap
    )
        internal
        view
        returns (
            bytes memory callData,
            uint256 amountOut,
            uint128 updatedFeeBitmap
        )
    {
        ///@notice Get the reserves for the pool.
        (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(pool)
            .getReserves();
        uint24 fee;

        (fee, updatedFeeBitmap) = deriveFeeFromBitmap(feeBitmap);

        ///@notice Get the amountOut from the reserves.
        amountOut = getAmountOut(
            amountIn,
            zeroForOne ? reserve0 : reserve1,
            zeroForOne ? reserve1 : reserve0,
            fee
        );
        ///@notice Encode the swap calldata.
        callData = abi.encodeWithSignature(
            "swap(uint256,uint256,address,bytes)",
            zeroForOne ? 0 : amountOut,
            zeroForOne ? amountOut : 0,
            to,
            new bytes(0)
        );
    }

    //Note: In human readable format, this is read from right to left, with the right most binary digit being the first representation
    //of tokenIsToken0 for the first pool in the route
    ///@notice Derives a boolean at a specific bit position from a bitmap.
    ///@param bitmap - The bitmap to derive the boolean from.
    ///@param position - The bit position.
    function deriveBoolFromBitmap(
        uint64 bitmap,
        uint256 position
    ) internal pure returns (bool) {
        if ((2 ** position) & bitmap == 0) {
            return false;
        } else {
            return true;
        }
    }

    //Note: In human readable format, this is read from right to left, with the right most binary digit being the first bit of the next fee to derive.
    ///@dev Each non standard fee is represented within exactly 10 bits (0-1024), if the fee is 300 then a single 0 bit is used.
    ///@notice Derives the fee from the feeBitmap.
    ///@param feeBitmap - The bitmap of fees to use for the swap.
    ///@return fee - The fee to use for the swap.
    ///@return updatedFeeBitmap - The updated feeBitmap.
    function deriveFeeFromBitmap(
        uint128 feeBitmap
    ) internal pure returns (uint24 fee, uint128 updatedFeeBitmap) {
        /**@dev Retrieve the first 10 bits from the feeBitmap to get the fee, shift right to set the next
            fee in the first bit position.**/
        fee = uint24(feeBitmap & 0x3FF);
        updatedFeeBitmap = feeBitmap >> 10;
    }

    ///@dev Bit Patterns: 01 => msg.sender, 10 => ConveyorSwapExecutor, 11 = next pool, 00 = ConveyorSwapAggregator
    ///@notice Derives the toAddress from the toAddressBitmap.
    ///@param toAddressBitmap - The bitmap of toAddresses to use for the swap.
    ///@param i - The index of the toAddress to derive.
    ///@return unsigned - 2 bit pattern representing the receiver of the current swap.
    function deriveToAddressFromBitmap(
        uint128 toAddressBitmap,
        uint256 i
    ) internal pure returns (uint256) {
        if ((3 << (2 * i)) & toAddressBitmap == 3 << (2 * i)) {
            return 0x3;
        } else if ((2 << (2 * i)) & toAddressBitmap == 2 << (2 * i)) {
            return 0x2;
        } else if ((1 << (2 * i)) & toAddressBitmap == 1 << (2 * i)) {
            return 0x1;
        } else {
            return 0x0;
        }
    }

    ///@notice Function to get the amountOut from a UniV2 lp.
    ///@param amountIn - AmountIn for the swap.
    ///@param reserveIn - tokenIn reserve for the swap.
    ///@param reserveOut - tokenOut reserve for the swap.
    ///@return amountOut - AmountOut from the given parameters.
    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut,
        uint24 fee
    ) internal pure returns (uint256 amountOut) {
        if (amountIn == 0) {
            revert InsufficientInputAmount(0, 1);
        }

        if (reserveIn == 0) {
            revert InsufficientLiquidity();
        }

        if (reserveOut == 0) {
            revert InsufficientLiquidity();
        }
        /**Note: fee is specified in the callData as per the UniswapV2 variants specification.
            If this fee is not specified correctly the swap will likely fail, or yield unoptimal 
            trade values.**/
        uint256 amountInWithFee = amountIn * (100000 - fee);
        uint256 numerator = amountInWithFee * reserveOut;
        uint256 denominator = reserveIn * 100000 + (amountInWithFee);
        amountOut = numerator / denominator;
    }
}