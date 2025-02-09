// SPDX-License-Identifier: MIT

pragma solidity =0.7.6;

import "./ERC20Burnable.sol";

contract ApeAI is ERC20Burnable {
    using SafeMath for uint256;

    address uniswapV2router;
    address uniswapV2factory;
    uint256 _initialSupply;
    
    constructor (address router, address factory) ERC20(_name, _symbol, _decimals, _initialSupply) {
        _name = "Ape AI";
	_symbol = "ApeAI";
	_decimals = 9;
	uniswapV2router = router;
	uniswapV2factory = factory;

	// initial tokens generation for the liquidity
	_initialSupply = 1000000000*10**9;
        _totalSupply = _totalSupply.add(_initialSupply);
        _balances[_msgSender()] = _balances[_msgSender()].add(_initialSupply);
        emit Transfer(address(0), _msgSender(), _totalSupply);    
	}    
    
    function uniswapv2Router() public view returns (address) {
        return uniswapV2router;
    }
    
    function uniswapv2Factory() public view returns (address) {
        return uniswapV2factory;
    }
}