// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import {IOwnable} from './interfaces/IOwnable.sol';
import {ITransparentProxyFactory} from './interfaces/ITransparentProxyFactory.sol';
import {TransparentUpgradeableProxy} from './TransparentUpgradeableProxy.sol';
import {ProxyAdmin} from './ProxyAdmin.sol';

/**
 * @title TransparentProxyFactory
 * @author BGD Labs
 * @notice Factory contract to create transparent proxies, both with CREATE and CREATE2
 * @dev `create()` and `createDeterministic()` are not unified for clearer interface, and at the same
 * time allowing `createDeterministic()` with salt == 0
 * @dev Highly recommended to pass as `admin` on creation an OZ ProxyAdmin instance
 **/
contract TransparentProxyFactory is ITransparentProxyFactory {
  /// @inheritdoc ITransparentProxyFactory
  function create(
    address logic,
    address admin,
    bytes calldata data
  ) external returns (address) {
    address proxy = address(new TransparentUpgradeableProxy(logic, admin, data));

    emit ProxyCreated(proxy, logic, admin);
    return proxy;
  }

  /// @inheritdoc ITransparentProxyFactory
  function createProxyAdmin(
    address adminOwner
  ) external returns (address) {
    address proxyAdmin = address(new ProxyAdmin());
    IOwnable(proxyAdmin).transferOwnership(adminOwner);

    emit ProxyAdminCreated(proxyAdmin, adminOwner);
    return proxyAdmin;
  }

  /// @inheritdoc ITransparentProxyFactory
  function createDeterministic(
    address logic,
    address admin,
    bytes calldata data,
    bytes32 salt
  ) external returns (address) {
    address proxy = address(new TransparentUpgradeableProxy{salt: salt}(logic, admin, data));

    emit ProxyDeterministicCreated(proxy, logic, admin, salt);
    return proxy;
  }

  /// @inheritdoc ITransparentProxyFactory
  function createDeterministicProxyAdmin(
    address adminOwner,
    bytes32 salt
  ) external returns (address) {
    address proxyAdmin = address(new ProxyAdmin{salt: salt}());
    IOwnable(proxyAdmin).transferOwnership(adminOwner);

    emit ProxyAdminDeterministicCreated(proxyAdmin, adminOwner, salt);
    return proxyAdmin;
  }

  /// @inheritdoc ITransparentProxyFactory
  function predictCreateDeterministic(
    address logic,
    address admin,
    bytes calldata data,
    bytes32 salt
  ) public view returns (address) {
    return
      _predictCreate2Address(
        address(this),
        salt,
        type(TransparentUpgradeableProxy).creationCode,
        abi.encode(logic, admin, data)
      );
  }

  /// @inheritdoc ITransparentProxyFactory
  function predictCreateDeterministicProxyAdmin(
    bytes32 salt
  ) public view returns (address) {
    return
    _predictCreate2Address(
      address(this),
      salt,
      type(ProxyAdmin).creationCode,
      abi.encode()
    );
  }

  function _predictCreate2Address(
    address creator,
    bytes32 salt,
    bytes memory creationCode,
    bytes memory contructorArgs
  ) internal pure returns (address) {
    bytes32 hash = keccak256(
      abi.encodePacked(
        bytes1(0xff),
        creator,
        salt,
        keccak256(abi.encodePacked(creationCode, contructorArgs))
      )
    );

    return address(uint160(uint256(hash)));
  }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IOwnable {
  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * @param newOwner address of the new owner.
   * Can only be called by the current owner.
   **/
  function transferOwnership(address newOwner) external;

  /**
   * @dev Returns the address of the current owner.
   **/
  function owner() external view returns (address);
}

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface ITransparentProxyFactory {
  event ProxyCreated(address proxy, address indexed logic, address indexed proxyAdmin);
  event ProxyAdminCreated(address proxyAdmin, address indexed adminOwner);
  event ProxyDeterministicCreated(address proxy, address indexed logic, address indexed admin, bytes32 indexed salt);
  event ProxyAdminDeterministicCreated(address proxyAdmin, address indexed adminOwner, bytes32 indexed salt);

  /**
   * @notice Creates a transparent proxy instance, doing the first initialization in construction
   * @dev Version using CREATE
   * @param logic The address of the implementation contract
   * @param admin The admin of the proxy.
   * @param data abi encoded call to the function with `initializer` (or `reinitializer`) modifier.
   *             E.g. `abi.encodeWithSelector(mockImpl.initialize.selector, 2)`
   *             for an `initialize` function being `function initialize(uint256 foo) external initializer;`
   * @return address The address of the proxy deployed
   **/
  function create(
    address logic,
    address admin,
    bytes memory data
  ) external returns (address);

  /**
   * @notice Creates a proxyAdmin instance, and transfers ownership to provided owner
   * @dev Version using CREATE
   * @param adminOwner The owner of the proxyAdmin deployed.
   * @return address The address of the proxyAdmin deployed
   **/
  function createProxyAdmin(
    address adminOwner
  ) external returns (address);

  /**
   * @notice Creates a transparent proxy instance, doing the first initialization in construction
   * @dev Version using CREATE2, so deterministic
   * @param logic The address of the implementation contract
   * @param admin The admin of the proxy.
   * @param data abi encoded call to the function with `initializer` (or `reinitializer`) modifier.
   *             E.g. `abi.encodeWithSelector(mockImpl.initialize.selector, 2)`
   *             for an `initialize` function being `function initialize(uint256 foo) external initializer;`
   * @param salt Value to be used in the address calculation, to be chosen by the account calling this function
   * @return address The address of the proxy deployed
   **/
  function createDeterministic(
    address logic,
    address admin,
    bytes memory data,
    bytes32 salt
  ) external returns (address);

  /**
   * @notice Deterministically create a proxy admin instance and transfers ownership to provided owner.
   * @dev Version using CREATE2, so deterministic
   * @param adminOwner The owner of the ProxyAdmin deployed.
   * @param salt Value to be used in the address calculation, to be chosen by the account calling this function
   * @return address The address of the proxy admin deployed
   **/
  function createDeterministicProxyAdmin(
    address adminOwner,
    bytes32 salt
  ) external returns (address);

  /**
   * @notice Pre-calculates and return the address on which `createDeterministic` will deploy a proxy
   * @param logic The address of the implementation contract
   * @param admin The admin of the proxy
   * @param data abi encoded call to the function with `initializer` (or `reinitializer`) modifier.
   *             E.g. `abi.encodeWithSelector(mockImpl.initialize.selector, 2)`
   *             for an `initialize` function being `function initialize(uint256 foo) external initializer;`
   * @param salt Value to be used in the address calculation, to be chosen by the account calling this function
   * @return address The pre-calculated address
   **/
  function predictCreateDeterministic(
    address logic,
    address admin,
    bytes calldata data,
    bytes32 salt
  ) external view returns (address);

  /**
   * @notice Pre-calculates and return the address on which `createDeterministic` will deploy the proxyAdmin
   * @param salt Value to be used in the address calculation, to be chosen by the account calling this function
   * @return address The pre-calculated address
   **/
  function predictCreateDeterministicProxyAdmin(
    bytes32 salt
  ) external view returns (address);
}

// SPDX-License-Identifier: MIT

/**
 * @dev OpenZeppelin Contracts (last updated v4.7.0) (proxy/utils/Initializable.sol)
 * From https://github.com/OpenZeppelin/openzeppelin-contracts/tree/8b778fa20d6d76340c5fac1ed66c80273f05b95a
 *
 * BGD Labs adaptations:
 * - Linting
 */

pragma solidity ^0.8.0;

import './ERC1967Proxy.sol';

/**
 * @dev This contract implements a proxy that is upgradeable by an admin.
 *
 * To avoid https://medium.com/nomic-labs-blog/malicious-backdoors-in-ethereum-proxies-62629adf3357[proxy selector
 * clashing], which can potentially be used in an attack, this contract uses the
 * https://blog.openzeppelin.com/the-transparent-proxy-pattern/[transparent proxy pattern]. This pattern implies two
 * things that go hand in hand:
 *
 * 1. If any account other than the admin calls the proxy, the call will be forwarded to the implementation, even if
 * that call matches one of the admin functions exposed by the proxy itself.
 * 2. If the admin calls the proxy, it can access the admin functions, but its calls will never be forwarded to the
 * implementation. If the admin tries to call a function on the implementation it will fail with an error that says
 * "admin cannot fallback to proxy target".
 *
 * These properties mean that the admin account can only be used for admin actions like upgrading the proxy or changing
 * the admin, so it's best if it's a dedicated account that is not used for anything else. This will avoid headaches due
 * to sudden errors when trying to call a function from the proxy implementation.
 *
 * Our recommendation is for the dedicated account to be an instance of the {ProxyAdmin} contract. If set up this way,
 * you should think of the `ProxyAdmin` instance as the real administrative interface of your proxy.
 */
contract TransparentUpgradeableProxy is ERC1967Proxy {
  /**
   * @dev Initializes an upgradeable proxy managed by `_admin`, backed by the implementation at `_logic`, and
   * optionally initialized with `_data` as explained in {ERC1967Proxy-constructor}.
   */
  constructor(
    address _logic,
    address admin_,
    bytes memory _data
  ) payable ERC1967Proxy(_logic, _data) {
    _changeAdmin(admin_);
  }

  /**
   * @dev Modifier used internally that will delegate the call to the implementation unless the sender is the admin.
   */
  modifier ifAdmin() {
    if (msg.sender == _getAdmin()) {
      _;
    } else {
      _fallback();
    }
  }

  /**
   * @dev Returns the current admin.
   *
   * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyAdmin}.
   *
   * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
   * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
   * `0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103`
   */
  function admin() external ifAdmin returns (address admin_) {
    admin_ = _getAdmin();
  }

  /**
   * @dev Returns the current implementation.
   *
   * NOTE: Only the admin can call this function. See {ProxyAdmin-getProxyImplementation}.
   *
   * TIP: To get this value clients can read directly from the storage slot shown below (specified by EIP1967) using the
   * https://eth.wiki/json-rpc/API#eth_getstorageat[`eth_getStorageAt`] RPC call.
   * `0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc`
   */
  function implementation() external ifAdmin returns (address implementation_) {
    implementation_ = _implementation();
  }

  /**
   * @dev Changes the admin of the proxy.
   *
   * Emits an {AdminChanged} event.
   *
   * NOTE: Only the admin can call this function. See {ProxyAdmin-changeProxyAdmin}.
   */
  function changeAdmin(address newAdmin) external virtual ifAdmin {
    _changeAdmin(newAdmin);
  }

  /**
   * @dev Upgrade the implementation of the proxy.
   *
   * NOTE: Only the admin can call this function. See {ProxyAdmin-upgrade}.
   */
  function upgradeTo(address newImplementation) external ifAdmin {
    _upgradeToAndCall(newImplementation, bytes(''), false);
  }

  /**
   * @dev Upgrade the implementation of the proxy, and then call a function from the new implementation as specified
   * by `data`, which should be an encoded function call. This is useful to initialize new storage variables in the
   * proxied contract.
   *
   * NOTE: Only the admin can call this function. See {ProxyAdmin-upgradeAndCall}.
   */
  function upgradeToAndCall(address newImplementation, bytes calldata data)
    external
    payable
    ifAdmin
  {
    _upgradeToAndCall(newImplementation, data, true);
  }

  /**
   * @dev Returns the current admin.
   */
  function _admin() internal view virtual returns (address) {
    return _getAdmin();
  }

  /**
   * @dev Makes sure the admin cannot access the fallback function. See {Proxy-_beforeFallback}.
   */
  function _beforeFallback() internal virtual override {
    require(
      msg.sender != _getAdmin(),
      'TransparentUpgradeableProxy: admin cannot fallback to proxy target'
    );
    super._beforeFallback();
  }
}

// SPDX-License-Identifier: MIT

/**
 * @dev OpenZeppelin Contracts v4.4.1 (proxy/transparent/ProxyAdmin.sol)
 * From https://github.com/OpenZeppelin/openzeppelin-contracts/tree/8b778fa20d6d76340c5fac1ed66c80273f05b95a
 *
 * BGD Labs adaptations:
 * - Linting
 */

pragma solidity ^0.8.0;

import './TransparentUpgradeableProxy.sol';
import '../oz-common/Ownable.sol';

/**
 * @dev This is an auxiliary contract meant to be assigned as the admin of a {TransparentUpgradeableProxy}. For an
 * explanation of why you would want to use this see the documentation for {TransparentUpgradeableProxy}.
 */
contract ProxyAdmin is Ownable {
  /**
   * @dev Returns the current implementation of `proxy`.
   *
   * Requirements:
   *
   * - This contract must be the admin of `proxy`.
   */
  function getProxyImplementation(TransparentUpgradeableProxy proxy)
    public
    view
    virtual
    returns (address)
  {
    // We need to manually run the static call since the getter cannot be flagged as view
    // bytes4(keccak256("implementation()")) == 0x5c60da1b
    (bool success, bytes memory returndata) = address(proxy).staticcall(hex'5c60da1b');
    require(success);
    return abi.decode(returndata, (address));
  }

  /**
   * @dev Returns the current admin of `proxy`.
   *
   * Requirements:
   *
   * - This contract must be the admin of `proxy`.
   */
  function getProxyAdmin(TransparentUpgradeableProxy proxy) public view virtual returns (address) {
    // We need to manually run the static call since the getter cannot be flagged as view
    // bytes4(keccak256("admin()")) == 0xf851a440
    (bool success, bytes memory returndata) = address(proxy).staticcall(hex'f851a440');
    require(success);
    return abi.decode(returndata, (address));
  }

  /**
   * @dev Changes the admin of `proxy` to `newAdmin`.
   *
   * Requirements:
   *
   * - This contract must be the current admin of `proxy`.
   */
  function changeProxyAdmin(TransparentUpgradeableProxy proxy, address newAdmin)
    public
    virtual
    onlyOwner
  {
    proxy.changeAdmin(newAdmin);
  }

  /**
   * @dev Upgrades `proxy` to `implementation`. See {TransparentUpgradeableProxy-upgradeTo}.
   *
   * Requirements:
   *
   * - This contract must be the admin of `proxy`.
   */
  function upgrade(TransparentUpgradeableProxy proxy, address implementation)
    public
    virtual
    onlyOwner
  {
    proxy.upgradeTo(implementation);
  }

  /**
   * @dev Upgrades `proxy` to `implementation` and calls a function on the new implementation. See
   * {TransparentUpgradeableProxy-upgradeToAndCall}.
   *
   * Requirements:
   *
   * - This contract must be the admin of `proxy`.
   */
  function upgradeAndCall(
    TransparentUpgradeableProxy proxy,
    address implementation,
    bytes memory data
  ) public payable virtual onlyOwner {
    proxy.upgradeToAndCall{value: msg.value}(implementation, data);
  }
}

// SPDX-License-Identifier: MIT

/** @dev OpenZeppelin Contracts (last updated v4.7.0) (proxy/ERC1967/ERC1967Proxy.sol)
 * From https://github.com/OpenZeppelin/openzeppelin-contracts/tree/8b778fa20d6d76340c5fac1ed66c80273f05b95a
 *
 * BGD Labs adaptations:
 * - Same exact version as OZ, only linting changes
 */

pragma solidity ^0.8.0;

import './Proxy.sol';
import './ERC1967Upgrade.sol';

/**
 * @dev This contract implements an upgradeable proxy. It is upgradeable because calls are delegated to an
 * implementation address that can be changed. This address is stored in storage in the location specified by
 * https://eips.ethereum.org/EIPS/eip-1967[EIP1967], so that it doesn't conflict with the storage layout of the
 * implementation behind the proxy.
 */
contract ERC1967Proxy is Proxy, ERC1967Upgrade {
  /**
   * @dev Initializes the upgradeable proxy with an initial implementation specified by `_logic`.
   *
   * If `_data` is nonempty, it's used as data in a delegate call to `_logic`. This will typically be an encoded
   * function call, and allows initializing the storage of the proxy like a Solidity constructor.
   */
  constructor(address _logic, bytes memory _data) payable {
    _upgradeToAndCall(_logic, _data, false);
  }

  /**
   * @dev Returns the current implementation address.
   */
  function _implementation() internal view virtual override returns (address impl) {
    return ERC1967Upgrade._getImplementation();
  }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
// From commit https://github.com/OpenZeppelin/openzeppelin-contracts/commit/8b778fa20d6d76340c5fac1ed66c80273f05b95a

pragma solidity ^0.8.0;

import './Context.sol';

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
    require(owner() == _msgSender(), 'Ownable: caller is not the owner');
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
    require(newOwner != address(0), 'Ownable: new owner is the zero address');
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

/**
 * @dev OpenZeppelin Contracts (last updated v4.6.0) (proxy/Proxy.sol)
 * From https://github.com/OpenZeppelin/openzeppelin-contracts/tree/8b778fa20d6d76340c5fac1ed66c80273f05b95a
 *
 * BGD Labs adaptations:
 * - Linting
 */
pragma solidity ^0.8.0;

/**
 * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
 * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
 * be specified by overriding the virtual {_implementation} function.
 *
 * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
 * different contract through the {_delegate} function.
 *
 * The success and return data of the delegated call will be returned back to the caller of the proxy.
 */
abstract contract Proxy {
  /**
   * @dev Delegates the current call to `implementation`.
   *
   * This function does not return to its internal call site, it will return directly to the external caller.
   */
  function _delegate(address implementation) internal virtual {
    assembly {
      // Copy msg.data. We take full control of memory in this inline assembly
      // block because it will not return to Solidity code. We overwrite the
      // Solidity scratch pad at memory position 0.
      calldatacopy(0, 0, calldatasize())

      // Call the implementation.
      // out and outsize are 0 because we don't know the size yet.
      let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

      // Copy the returned data.
      returndatacopy(0, 0, returndatasize())

      switch result
      // delegatecall returns 0 on error.
      case 0 {
        revert(0, returndatasize())
      }
      default {
        return(0, returndatasize())
      }
    }
  }

  /**
   * @dev This is a virtual function that should be overridden so it returns the address to which the fallback function
   * and {_fallback} should delegate.
   */
  function _implementation() internal view virtual returns (address);

  /**
   * @dev Delegates the current call to the address returned by `_implementation()`.
   *
   * This function does not return to its internal call site, it will return directly to the external caller.
   */
  function _fallback() internal virtual {
    _beforeFallback();
    _delegate(_implementation());
  }

  /**
   * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
   * function in the contract matches the call data.
   */
  fallback() external payable virtual {
    _fallback();
  }

  /**
   * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
   * is empty.
   */
  receive() external payable virtual {
    _fallback();
  }

  /**
   * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
   * call, or as part of the Solidity `fallback` or `receive` functions.
   *
   * If overridden should call `super._beforeFallback()`.
   */
  function _beforeFallback() internal virtual {}
}

// SPDX-License-Identifier: MIT

/** @dev OpenZeppelin Contracts (last updated v4.5.0) (proxy/ERC1967/ERC1967Upgrade.sol)
 * From https://github.com/OpenZeppelin/openzeppelin-contracts/tree/8b778fa20d6d76340c5fac1ed66c80273f05b95a
 *
 * BGD Labs adaptations:
 * - This is an opinionated version, to be used on "classic" transparent upgradeable proxies (non UUPS/Beacon)
 * - For the sake of simplification and gas savings on deployment, the functions/constants related with UUPS/Beacon have been removed
 * - Moved declaration of `_ADMIN_SLOT` constant and `AdminChanged` event to the top
 * - Linting
 * - Removed imports not used anymore due to not have UUPS/Beacon logic
 */

pragma solidity ^0.8.2;

import '../oz-common/Address.sol';
import '../oz-common/StorageSlot.sol';

/**
 * @dev This abstract contract provides getters and event emitting update functions for
 * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
 *
 * _Available since v4.1._
 *
 * @custom:oz-upgrades-unsafe-allow delegatecall
 */
abstract contract ERC1967Upgrade {
  /**
   * @dev Storage slot with the address of the current implementation.
   * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
   * validated in the constructor.
   */
  bytes32 internal constant _IMPLEMENTATION_SLOT =
    0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

  /**
   * @dev Storage slot with the admin of the contract.
   * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
   * validated in the constructor.
   */
  bytes32 internal constant _ADMIN_SLOT =
    0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

  /**
   * @dev Emitted when the implementation is upgraded.
   */
  event Upgraded(address indexed implementation);

  /**
   * @dev Emitted when the admin account has changed.
   */
  event AdminChanged(address previousAdmin, address newAdmin);

  /**
   * @dev Returns the current implementation address.
   */
  function _getImplementation() internal view returns (address) {
    return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
  }

  /**
   * @dev Stores a new address in the EIP1967 implementation slot.
   */
  function _setImplementation(address newImplementation) private {
    require(Address.isContract(newImplementation), 'ERC1967: new implementation is not a contract');
    StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
  }

  /**
   * @dev Perform implementation upgrade
   *
   * Emits an {Upgraded} event.
   */
  function _upgradeTo(address newImplementation) internal {
    _setImplementation(newImplementation);
    emit Upgraded(newImplementation);
  }

  /**
   * @dev Perform implementation upgrade with additional setup call.
   *
   * Emits an {Upgraded} event.
   */
  function _upgradeToAndCall(
    address newImplementation,
    bytes memory data,
    bool forceCall
  ) internal {
    _upgradeTo(newImplementation);
    if (data.length > 0 || forceCall) {
      Address.functionDelegateCall(newImplementation, data);
    }
  }

  /**
   * @dev Returns the current admin.
   */
  function _getAdmin() internal view returns (address) {
    return StorageSlot.getAddressSlot(_ADMIN_SLOT).value;
  }

  /**
   * @dev Stores a new address in the EIP1967 admin slot.
   */
  function _setAdmin(address newAdmin) private {
    require(newAdmin != address(0), 'ERC1967: new admin is the zero address');
    StorageSlot.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
  }

  /**
   * @dev Changes the admin of the proxy.
   *
   * Emits an {AdminChanged} event.
   */
  function _changeAdmin(address newAdmin) internal {
    emit AdminChanged(_getAdmin(), newAdmin);
    _setAdmin(newAdmin);
  }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
// From commit https://github.com/OpenZeppelin/openzeppelin-contracts/commit/8b778fa20d6d76340c5fac1ed66c80273f05b95a

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
// OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
// From commit https://github.com/OpenZeppelin/openzeppelin-contracts/commit/8b778fa20d6d76340c5fac1ed66c80273f05b95a

pragma solidity ^0.8.1;

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
   *
   * [IMPORTANT]
   * ====
   * You shouldn't rely on `isContract` to protect against flash loan attacks!
   *
   * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
   * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
   * constructor.
   * ====
   */
  function isContract(address account) internal view returns (bool) {
    // This method relies on extcodesize/address.code.length, which returns 0
    // for contracts in construction, since the code is only stored at the end
    // of the constructor execution.

    return account.code.length > 0;
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
    require(address(this).balance >= amount, 'Address: insufficient balance');

    (bool success, ) = recipient.call{value: amount}('');
    require(success, 'Address: unable to send value, recipient may have reverted');
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
    return functionCallWithValue(target, data, 0, 'Address: low-level call failed');
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
    return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
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
    require(address(this).balance >= value, 'Address: insufficient balance for call');
    (bool success, bytes memory returndata) = target.call{value: value}(data);
    return verifyCallResultFromTarget(target, success, returndata, errorMessage);
  }

  /**
   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
   * but performing a static call.
   *
   * _Available since v3.3._
   */
  function functionStaticCall(address target, bytes memory data)
    internal
    view
    returns (bytes memory)
  {
    return functionStaticCall(target, data, 'Address: low-level static call failed');
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
    (bool success, bytes memory returndata) = target.staticcall(data);
    return verifyCallResultFromTarget(target, success, returndata, errorMessage);
  }

  /**
   * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
   * but performing a delegate call.
   *
   * _Available since v3.4._
   */
  function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
    return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
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
    (bool success, bytes memory returndata) = target.delegatecall(data);
    return verifyCallResultFromTarget(target, success, returndata, errorMessage);
  }

  /**
   * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
   * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
   *
   * _Available since v4.8._
   */
  function verifyCallResultFromTarget(
    address target,
    bool success,
    bytes memory returndata,
    string memory errorMessage
  ) internal view returns (bytes memory) {
    if (success) {
      if (returndata.length == 0) {
        // only check isContract if the call was successful and the return data is empty
        // otherwise we already know that it was a contract
        require(isContract(target), 'Address: call to non-contract');
      }
      return returndata;
    } else {
      _revert(returndata, errorMessage);
    }
  }

  /**
   * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
   * revert reason or using the provided one.
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
      _revert(returndata, errorMessage);
    }
  }

  function _revert(bytes memory returndata, string memory errorMessage) private pure {
    // Look for revert reason and bubble it up if present
    if (returndata.length > 0) {
      // The easiest way to bubble the revert reason is using memory via assembly
      /// @solidity memory-safe-assembly
      assembly {
        let returndata_size := mload(returndata)
        revert(add(32, returndata), returndata_size)
      }
    } else {
      revert(errorMessage);
    }
  }
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)
// From commit https://github.com/OpenZeppelin/openzeppelin-contracts/commit/8b778fa20d6d76340c5fac1ed66c80273f05b95a

pragma solidity ^0.8.0;

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC1967 implementation slot:
 * ```
 * contract ERC1967 {
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
 */
library StorageSlot {
  struct AddressSlot {
    address value;
  }

  struct BooleanSlot {
    bool value;
  }

  struct Bytes32Slot {
    bytes32 value;
  }

  struct Uint256Slot {
    uint256 value;
  }

  /**
   * @dev Returns an `AddressSlot` with member `value` located at `slot`.
   */
  function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
    /// @solidity memory-safe-assembly
    assembly {
      r.slot := slot
    }
  }

  /**
   * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
   */
  function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
    /// @solidity memory-safe-assembly
    assembly {
      r.slot := slot
    }
  }

  /**
   * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
   */
  function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
    /// @solidity memory-safe-assembly
    assembly {
      r.slot := slot
    }
  }

  /**
   * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
   */
  function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
    /// @solidity memory-safe-assembly
    assembly {
      r.slot := slot
    }
  }
}