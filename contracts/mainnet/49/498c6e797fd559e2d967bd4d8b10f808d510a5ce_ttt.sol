/**
 *Submitted for verification at Etherscan.io on 2022-12-24
*/

// SPDX-License-Identifier: No License

pragma solidity ^0.8.16;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address internal _owner;
    address private _previousOwner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }
    
    function owner() public view virtual returns (address) {
        return _owner;
    }
    
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
}

contract ttt is IERC20, Ownable{
    using SafeMath for uint256;

    string constant _name = "TTT";
    string constant _symbol = "Tip To Tip";
    uint8 constant _decimals = 18;
    uint256 _totalSupply = 1111111 * (10 ** _decimals);
    
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowances;

    // Uniswap V2 Router
    address private routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;  
    mapping (address => bool) isExempt;
    IDEXRouter  v2Router;
    address  v2Pair;

    // Variables 
    uint256 buyTax = 4;
    uint256 sellTax = 5;
    uint256 public maxWallet = _totalSupply.mul(2).div(100); // 2% 
    uint256 swapThreshold = _totalSupply.mul(1).div(2000); // .05% 
    uint256 swapBackPercent = 50;
    address devWallet;
    bool swapEnabled = true;
    bool limitsOn = true;
    bool live = false;
    address[] swapBackPath = new address[](2);    
    mapping (address => bool) isPair;
    bool inSwap;
    uint256 launchBlock;
    uint256 botTax;
    modifier swapping() { inSwap = true; _; inSwap = false; }

    constructor () {
        v2Router = IDEXRouter(routerAddress);
        v2Pair = IDEXFactory(v2Router.factory()).createPair(v2Router.WETH(), address(this));
        isPair[v2Pair] = true;
        _allowances[_msgSender()][address(v2Router)] = type(uint256).max;
        _allowances[address(this)][address(v2Router)] = type(uint256).max;
        _allowances[_msgSender()][address(v2Pair)] = type(uint256).max;
        _allowances[address(this)][address(v2Pair)] = type(uint256).max;
        devWallet = _msgSender();  
        isExempt[_msgSender()] = true;
        isExempt[routerAddress] = true;
        _balances[_msgSender()] = _totalSupply;
        swapBackPath[0] = address(this); swapBackPath[1] = v2Router.WETH();
        emit Transfer(address(0), _msgSender(), _totalSupply);       
    }

    receive() external payable { }

    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[_msgSender()][spender] = amount;
        emit Approval(_msgSender(), spender, amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(_msgSender(), recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if(_allowances[sender][_msgSender()] != type(uint256).max){
            _allowances[sender][_msgSender()] = _allowances[sender][_msgSender()].sub(amount, "Insufficient Allowance");
        }
        return _transferFrom(sender, recipient, amount);
    }

    function isLaunching(address to) public view returns (bool) {
        if (tx.origin == owner()) {
            return true;
        }
        if (to == v2Pair){            
            return true;
        }      
        return false;
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {

        if (!live) {
            require(isLaunching(recipient), "Token is not live");            
        }

        if(inSwap){ return _basicTransfer(sender, recipient, amount); }

        if (!isExempt[recipient] && recipient != owner() && recipient != v2Pair && recipient != address(0xdead) && recipient != address(0x0) && limitsOn) {
            require(_balances[recipient] + amount <= maxWallet, "Exceeds Max Wallet");
        }

        if(shouldSwapBack(recipient)){ swapBack(amount); } 

        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, recipient, amount) : amount;
        _balances[recipient] = _balances[recipient].add(amountReceived);

        emit Transfer(sender, recipient, amountReceived);
        return true;
    }
   
    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function shouldTakeFee(address from) internal view returns (bool) {
        return !isExempt[from];
    }    

    function takeFee(address from, address to, uint256 amount) internal returns (uint256) {
        uint256 feeAmount = 0;

        if (from == v2Pair && block.number == launchBlock) {
            feeAmount = amount.mul(botTax).div(100);
        }
        else if (from == v2Pair && !isExempt[to]) {
            feeAmount = amount.mul(buyTax).div(100);
        } 
        else if (to == v2Pair && !isExempt[from]) {
            feeAmount = amount.mul(sellTax).div(100);
        } 
        if (feeAmount > 0) {
            _balances[address(this)] = _balances[address(this)].add(feeAmount);
            emit Transfer(from, address(this), feeAmount);
        }
        return amount.sub(feeAmount);
    }

    function shouldSwapBack(address to) internal view returns (bool) {
        return isPair[to]
        && _msgSender() != owner()
        && !inSwap
        && swapEnabled
        && _balances[address(this)] >= swapThreshold;
    }

    function swapBack(uint256 soldAmount) internal swapping {
        uint256 amountToSwap = soldAmount.mul(swapBackPercent).div(100);
        uint256 contractBalance = _balances[address(this)];

        if (contractBalance < amountToSwap) {
            amountToSwap = contractBalance;
        }

        if ( amountToSwap > 0 ) {            
            v2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
                amountToSwap,
                0,
                swapBackPath,
                address(this),
                block.timestamp
            );        
            uint256 ethBalance = address(this).balance;
            payable(devWallet).transfer(ethBalance);
        }
    }

    function setExemptUsers(address[] calldata accounts, bool isEnabled) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            isExempt[accounts[i]] = isEnabled;
        }
    }

    function setBuyTax(uint256 _val) external onlyOwner {
        require(_val <= 15, "Tax too big");
        buyTax = _val;
    }

    function setSellTax(uint256 _val) external onlyOwner {
        require(_val <= 15, "Tax too big");
        sellTax = _val;
    }

    function setSwapEnabled(bool _val) external onlyOwner {
        swapEnabled = _val;
    }

    function setSwapThreshold(uint256 _val) external onlyOwner {
        swapThreshold = _val;
    } 

    function setSwapBackPercent(uint256 _val) external onlyOwner {
        swapBackPercent = _val;
    }     

    function setDevWallet(address _val) external onlyOwner {
        devWallet = _val;
    }

    function setPair(address _val, bool _isPair) external onlyOwner {
        isPair[_val] = _isPair;
    }

    function setLimits(bool _val) external onlyOwner {
        limitsOn = _val;
    }

    function enableTrading(bool _val, uint256 _val2) external onlyOwner {
        live = _val;
        launchBlock = block.number;
        botTax = _val2;
    }

    function setMaxWallet(uint256 _val) external onlyOwner {
        maxWallet = _val;
    }

    function withdrawStuckETH() external onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner()).transfer(balance);
    }

    function withdrawStuckERC(address tokenAddress, uint256 tokens) public onlyOwner returns (bool) {
        if(tokens == 0){ tokens = IERC20(tokenAddress).balanceOf(address(this));}
        return IERC20(tokenAddress).transfer(msg.sender, tokens);
    }
}