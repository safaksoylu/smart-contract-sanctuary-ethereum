// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract VoteDelegation is Initializable{
    address public collectiveAddress;
   
    struct Delegation {
        address delegatee;
        string command;
        uint256 maxValue;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() initializer {}

    function initialize(address _collectiveAddress) public initializer {
        collectiveAddress = _collectiveAddress; 
    }

    mapping (address => Delegation[]) public delegationsMap;
    
    event GrantDelegations(address delegator, Delegation[] delegationGrants);
    event DeleteDelegations(address delegator);
    
    function grantDelegates(address[] calldata addresses, string[] calldata commands, uint256[] calldata maxValues) external {
        if (delegationsMap[msg.sender].length > 0) {
            delete delegationsMap[msg.sender];
        }

        for (uint256 i=0; i < addresses.length; i++) { 
            delegationsMap[msg.sender].push(Delegation(addresses[i], commands[i], maxValues[i]));
        }

        emit GrantDelegations(msg.sender, delegationsMap[msg.sender]);
    }

    function removeDelegates() public {
        if (delegationsMap[msg.sender].length > 0) {
            delete delegationsMap[msg.sender];
        }

        emit DeleteDelegations(msg.sender);
    }
  
    function getDelegations(address delegator) public view returns(Delegation[] memory delegations) {
        return delegationsMap[delegator];
    }
     
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.0 (proxy/utils/Initializable.sol)

pragma solidity ^0.8.0;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
 * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() initializer {}
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        require(_initializing || !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }
}