/**
 *Submitted for verification at Etherscan.io on 2022-01-28
*/

// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;


interface IERC20 {
    function decimals() external view returns (uint8);
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
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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

interface IPolicy {
    function policy() external view returns (address);
    function renouncePolicy() external;
    function pushPolicy( address newPolicy_ ) external;
    function pullPolicy() external;
}

contract Policy is IPolicy {
    address internal _policy;
    address internal _newPolicy;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        _policy = msg.sender;
        emit OwnershipTransferred( address(0), _policy );
    }

    function policy() public view override returns (address) {
        return _policy;
    }

    modifier onlyPolicy() {
        require( _policy == msg.sender, "Ownable: caller is not the owner" );
        _;
    }

    function renouncePolicy() public virtual override onlyPolicy() {
        emit OwnershipTransferred( _policy, address(0) );
        _policy = address(0);
    }

    function pushPolicy( address newPolicy_ ) public virtual override onlyPolicy() {
        require( newPolicy_ != address(0), "Ownable: new owner is the zero address");
        _newPolicy = newPolicy_;
    }

    function pullPolicy() public virtual override {
        require( msg.sender == _newPolicy );
        emit OwnershipTransferred( _policy, _newPolicy );
        _policy = _newPolicy;
    }
}

contract StakingWarmup is Policy {

    address public staking;
    address public sORKAN;

    constructor ( address _staking, address _sORKAN ) {
        require( _staking != address(0) );
        staking = _staking;
        require( _sORKAN != address(0) );
        sORKAN = _sORKAN;
    }

    function retrieve( address _staker, uint _amount ) external {
        require( msg.sender == staking );
        IERC20( sORKAN ).transfer( _staker, _amount );
    }
    
    /**
    * @notice set token address (sORKAN) Reward
    * @param _rToken address
    */
    function setRewardAddress(address _rToken) external onlyPolicy() {
        sORKAN = _rToken;
    }

    /**
    * @notice set staking token address
    * @param _staking address
    */
    function setStakingAddress(address _staking) external onlyPolicy() {
        staking = _staking;
    }
}