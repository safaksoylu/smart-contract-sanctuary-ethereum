// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;

import "../IERC20.sol";

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

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
    event Approval(address indexed owner, address indexed spender, uint256 value);

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
}

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (utils/StorageSlot.sol)

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

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

interface IBridgeable
{
    struct BridgeInstruction
    {
        uint256 instructionId;
        uint256 value;
        address to;
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    event BridgeIn(uint256 indexed instructionId, address indexed to, uint256 value);
    event BridgeOut(address indexed from, address indexed controller, uint256 value);

    error ZeroAmount();
    error ZeroAddress();
    error ZeroArray();
    error DuplicateInstruction();
    error InvalidBridgeSignature();

    function isBridgeable() external view returns (bool);
    function bridgeInstructionFulfilled(uint256 instructionId) external view returns (bool);

    function bridgeIn(BridgeInstruction calldata instruction) external;
    function multiBridgeIn(BridgeInstruction[] calldata instructions) external;
    function bridgeOut(address controller, uint256 value) external;
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./Minter.sol";
import "./IUUPSERC20.sol";
import "./IBridgeable.sol";

interface IBridgeUUPSERC20 is IBridgeable, IMinter, IUUPSERC20
{
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ICanMint is IERC20
{
    function mint(address to, uint256 amount) external;
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol";

interface IERC20Full is IERC20Metadata, IERC20Permit {
    /** This function might not exist */
    function version() external view returns (string memory);
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

interface IMinter
{
    event SetMinter(address user, bool canMint);
    
    error NotMinter();
    error NotMinterOwner();
    
    function isMinter(address user) external view returns (bool);
    
    function setMinter(address user, bool canMint) external;
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

interface IOwned
{
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    error NotOwner();
    error AlreadyInitialized();

    function owner() external view returns (address);

    function transferOwnership(address newOwner) external;
    function claimOwnership() external;
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "../Library/CheapSafeERC20.sol";

interface IRECoverable
{
    error NotRECoverableOwner();
    
    function recoverERC20(IERC20 token) external;
    function recoverNative() external;
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "../IREStablecoins.sol";
import "../IREUSD.sol";
import "../IRECustodian.sol";

interface IREUSDMinterBase
{
    event MintREUSD(address indexed minter, IERC20 paymentToken, uint256 reusdAmount);

    function REUSD() external view returns (IREUSD);
    function stablecoins() external view returns (IREStablecoins);
    function totalMinted() external view returns (uint256);
    function totalReceived(IERC20 paymentToken) external view returns (uint256);
    function getREUSDAmount(IERC20 paymentToken, uint256 paymentTokenAmount) external view returns (uint256 reusdAmount);
    function custodian() external view returns (IRECustodian);
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./IUUPSUpgradeableVersion.sol";
import "./IRECoverable.sol";
import "./IOwned.sol";

interface IUpgradeableBase is IUUPSUpgradeableVersion, IRECoverable, IOwned
{
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./IERC20Full.sol";

interface IUUPSERC20 is IERC20Full
{
    error InsufficientAllowance();
    error InsufficientBalance();
    error TransferFromZeroAddress();
    error MintToZeroAddress();
    error DeadlineExpired();
    error InvalidPermitSignature();
    error NameMismatch();
    
    function isUUPSERC20() external view returns (bool);
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

interface IUUPSUpgradeable
{
    event Upgraded(address newImplementation);

    error ProxyDelegateCallRequired();
    error DelegateCallForbidden();
    error ProxyNotActive();
    error NotUUPS();
    error UnsupportedProxiableUUID();
    error UpgradeCallFailed();
    
    function proxiableUUID() external view returns (bytes32);
    
    function upgradeTo(address newImplementation) external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external;
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./IUUPSUpgradeable.sol";

interface IUUPSUpgradeableVersion is IUUPSUpgradeable
{
    error UpgradeToSameVersion();

    function contractVersion() external view returns (uint256);
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./IMinter.sol";
import "../Library/Roles.sol";

abstract contract Minter is IMinter
{
    bytes32 private constant MinterRole = keccak256("ROLE:Minter");

    function getMinterOwner() internal virtual view returns (address);

    function isMinter(address user)
        public
        view
        returns (bool)
    {
        return Roles.hasRole(MinterRole, user);
    }

    modifier onlyMinter()
    {
        if (!isMinter(msg.sender)) { revert NotMinter(); }
        _;
    }

    function setMinter(address user, bool canMint)
        public
    {
        if (msg.sender != getMinterOwner()) { revert NotMinterOwner(); }
        emit SetMinter(user, canMint);
        Roles.setRole(MinterRole, user, canMint);
    }
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./IOwned.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";

abstract contract Owned is IOwned
{
    bytes32 private constant OwnerSlot = keccak256("SLOT:Owned:owner");
    bytes32 private constant PendingOwnerSlot = keccak256("SLOT:Owned:pendingOwner");

    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
    address private immutable firstOwner = msg.sender;

    function owner() public view returns (address)
    {
        address o = StorageSlot.getAddressSlot(OwnerSlot).value;
        return o == address(0) ? firstOwner : o;
    }

    function transferOwnership(address newOwner)
        public
        onlyOwner
    {
        StorageSlot.getAddressSlot(PendingOwnerSlot).value = newOwner;
    }

    function claimOwnership()
        public
    {
        StorageSlot.AddressSlot storage pending = StorageSlot.getAddressSlot(PendingOwnerSlot);
        if (pending.value != msg.sender) { revert NotOwner(); }
        emit OwnershipTransferred(owner(), msg.sender);
        pending.value = address(0);
        StorageSlot.getAddressSlot(OwnerSlot).value = msg.sender;
    }

    modifier onlyOwner() 
    {
        if (msg.sender != owner()) { revert NotOwner(); }
        _;
    }
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./IRECoverable.sol";

using CheapSafeERC20 for IERC20;

abstract contract RECoverable is IRECoverable 
{
    function getRECoverableOwner() internal virtual view returns (address);

    function recoverERC20(IERC20 token)
        public
    {
        if (msg.sender != getRECoverableOwner()) { revert NotRECoverableOwner(); }
        beforeRecoverERC20(token);
        token.safeTransfer(msg.sender, token.balanceOf(address(this)));
    }

    function beforeRecoverERC20(IERC20 token) internal virtual {}

    function recoverNative()
        public
    {
        if (msg.sender != getRECoverableOwner()) { revert NotRECoverableOwner(); }
        beforeRecoverNative();
        (bool success,) = msg.sender.call{ value: address(this).balance }(""); 
        assert(success);
    }

    function beforeRecoverNative() internal virtual {}
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "../IREUSD.sol";
import "./IREUSDMinterBase.sol";
import "../Library/CheapSafeERC20.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";

using CheapSafeERC20 for IERC20;

abstract contract REUSDMinterBase is IREUSDMinterBase
{
    bytes32 private constant TotalMintedSlot = keccak256("SLOT:REUSDMinterBase:totalMinted");
    bytes32 private constant TotalReceivedSlotPrefix = keccak256("SLOT:REUSDMinterBase:totalReceived");

    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable
    IREUSD public immutable REUSD;
    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable
    IREStablecoins public immutable stablecoins;
    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable
    IRECustodian public immutable custodian;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(IRECustodian _custodian, IREUSD _REUSD, IREStablecoins _stablecoins)
    {
        assert(_REUSD.isREUSD() && _stablecoins.isREStablecoins() && _custodian.isRECustodian());
        REUSD = _REUSD;
        stablecoins = _stablecoins;
        custodian = _custodian;
    }    

    function totalMinted() public view returns (uint256) { return StorageSlot.getUint256Slot(TotalMintedSlot).value; }
    function totalReceivedSlot(IERC20 paymentToken) private pure returns (StorageSlot.Uint256Slot storage) { return StorageSlot.getUint256Slot(keccak256(abi.encodePacked(TotalReceivedSlotPrefix, paymentToken))); }
    function totalReceived(IERC20 paymentToken) public view returns (uint256) { return totalReceivedSlot(paymentToken).value; }

    function getREUSDAmount(IERC20 paymentToken, uint256 paymentTokenAmount)
        public
        view
        returns (uint256 reusdAmount)
    {        
        return stablecoins.getStablecoinConfig(address(paymentToken)).decimals == 6 ? paymentTokenAmount * 10**12 : paymentTokenAmount;
    }

    function mintREUSDCore(address from, IERC20 paymentToken, address recipient, uint256 reusdAmount)
        internal
    {
        uint256 paymentAmount = stablecoins.getStablecoinConfig(address(paymentToken)).decimals == 6 ? reusdAmount / 10**12 : reusdAmount;
        paymentToken.safeTransferFrom(from, address(custodian), paymentAmount);
        REUSD.mint(recipient, reusdAmount);
        emit MintREUSD(from, paymentToken, reusdAmount);
        StorageSlot.getUint256Slot(TotalMintedSlot).value += reusdAmount;
        totalReceivedSlot(paymentToken).value += paymentAmount;
    }
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./UUPSUpgradeableVersion.sol";
import "./RECoverable.sol";
import "./Owned.sol";
import "./IUpgradeableBase.sol";

abstract contract UpgradeableBase is UUPSUpgradeableVersion, RECoverable, Owned, IUpgradeableBase
{
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(uint256 __contractVersion)
        UUPSUpgradeableVersion(__contractVersion)
    {
    }

    function getRECoverableOwner() internal override view returns (address) { return owner(); }
    
    function beforeUpgradeVersion(address newImplementation)
        internal
        override
        view
        onlyOwner
    {
        checkUpgradeBase(newImplementation);
    }

    function checkUpgradeBase(address newImplementation) internal virtual view;
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/StorageSlot.sol";
import "./IUUPSUpgradeable.sol";

abstract contract UUPSUpgradeable is IUUPSUpgradeable
{
    bytes32 private constant ImplementationSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
    address private immutable self = address(this);

    function beforeUpgrade(address newImplementation) internal virtual view;
    
    modifier notDelegated()
    {
        if (address(this) != self) { revert DelegateCallForbidden(); }
        _;
    }

    modifier onlyProxy()
    {
        if (address(this) == self) { revert ProxyDelegateCallRequired(); }
        if (StorageSlot.getAddressSlot(ImplementationSlot).value != self) { revert ProxyNotActive(); }
        _;
    }

    function proxiableUUID()
        public
        virtual
        view
        notDelegated
        returns (bytes32)
    {
        return ImplementationSlot;
    }

    function upgradeTo(address newImplementation)
        public
        onlyProxy
    {
        try IUUPSUpgradeable(newImplementation).proxiableUUID() returns (bytes32 slot)
        {
            if (slot != ImplementationSlot) { revert UnsupportedProxiableUUID(); }
            beforeUpgrade(newImplementation);
            StorageSlot.getAddressSlot(ImplementationSlot).value = newImplementation;
            emit Upgraded(newImplementation);
        }
        catch
        {
            revert NotUUPS();
        }
    }
    
    function upgradeToAndCall(address newImplementation, bytes memory data)
        public
    {
        upgradeTo(newImplementation);
        /// @custom:oz-upgrades-unsafe-allow delegatecall
        (bool success, bytes memory returndata) = newImplementation.delegatecall(data);
        if (!success)
        {
            if (returndata.length > 0)
            {
                assembly
                {                                
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            }
            revert UpgradeCallFailed();
        }
    }
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./UUPSUpgradeable.sol";
import "./IUUPSUpgradeableVersion.sol";

abstract contract UUPSUpgradeableVersion is UUPSUpgradeable, IUUPSUpgradeableVersion
{
    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable
    uint256 private immutable _contractVersion;

    function contractVersion() public virtual view returns (uint256) { return _contractVersion; }
    
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(uint256 __contractVersion)
    {
        _contractVersion = __contractVersion;
    }

    function beforeUpgrade(address newImplementation)
        internal
        override
        view
    {
        if (IUUPSUpgradeableVersion(newImplementation).contractVersion() == contractVersion()) { revert UpgradeToSameVersion(); }        
        beforeUpgradeVersion(newImplementation);
    }

    function beforeUpgradeVersion(address newImplementation) internal virtual view;
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./Base/IUpgradeableBase.sol";

interface IRECustodian is IUpgradeableBase
{
    function isRECustodian() external view returns (bool);
    function amountRecovered(address token) external view returns (uint256);
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./Base/IERC20Full.sol";
import "./Base/IUpgradeableBase.sol";

interface IREStablecoins is IUpgradeableBase
{
    struct StablecoinConfig
    {
        IERC20Full token;
        uint8 decimals;
        bool hasPermit;
    }
    struct StablecoinConfigWithName
    {
        StablecoinConfig config;
        string name;
        string symbol;
    }

    error TokenNotSupported();
    error TokenMisconfigured();
    error StablecoinAlreadyExists();
    error StablecoinDoesNotExist();
    error StablecoinBakedIn();

    function isREStablecoins() external view returns (bool);
    function supportedStablecoins() external view returns (StablecoinConfigWithName[] memory);
    function getStablecoinConfig(address token) external view returns (StablecoinConfig memory config);

    function addStablecoin(address stablecoin, bool hasPermit) external;
    function removeStablecoin(address stablecoin) external;
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./Base/IBridgeUUPSERC20.sol";
import "./Base/ICanMint.sol";
import "./Base/IUpgradeableBase.sol";

interface IREUSD is IBridgeUUPSERC20, ICanMint, IUpgradeableBase
{
    function isREUSD() external view returns (bool);
    function url() external view returns (string memory);
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./Base/IUpgradeableBase.sol";
import "./Base/IREUSDMinterBase.sol";

interface IREUSDMinter is IUpgradeableBase, IREUSDMinterBase
{
    function isREUSDMinter() external view returns (bool);

    function mint(IERC20 paymentToken, uint256 reusdAmount) external;
    function mintPermit(IERC20Full paymentToken, uint256 reusdAmount, uint256 permitAmount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
    function mintTo(IERC20 paymentToken, address recipient, uint256 reusdAmount) external;
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

library CheapSafeCall
{
    function callOptionalBooleanNoThrow(address addr, bytes memory data) 
        internal
        returns (bool)
    {
        (bool success, bytes memory result) = addr.call(data);
        return success && (result.length == 0 ? addr.code.length > 0 : abi.decode(result, (bool)));        
    }
    function callOptionalBoolean(address addr, bytes memory data) 
        internal
        returns (bool)
    {
        (bool success, bytes memory result) = addr.call(data);
        if (success) 
        {
            return result.length == 0 ? addr.code.length > 0 : abi.decode(result, (bool));
        }
        else 
        {
            if (result.length == 0) { return false; }
            assembly 
            {
                let resultSize := mload(result)
                revert(add(32, result), resultSize)
            }
        }        
    }
    function call(address addr, bytes memory data)
        internal
        returns (bool)
    {
        (bool success, bytes memory result) = addr.call(data);
        if (success)
        {
            return result.length > 0 || addr.code.length > 0;
        }
        if (result.length == 0) { return false; }
        assembly 
        {
            let resultSize := mload(result)
            revert(add(32, result), resultSize)
        }
    }
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CheapSafeCall.sol";

library CheapSafeERC20 
{
    error TransferFailed();
    error ApprovalFailed();

    function safeTransfer(IERC20 token, address to, uint256 value) 
        internal 
    {
        if (!CheapSafeCall.callOptionalBoolean(address(token), abi.encodeWithSelector(token.transfer.selector, to, value))) { revert TransferFailed(); }
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) 
        internal 
    {
        if (!CheapSafeCall.callOptionalBoolean(address(token), abi.encodeWithSelector(token.transferFrom.selector, from, to, value))) { revert TransferFailed(); }
    }

    function safeApprove(IERC20 token, address spender, uint256 value)
        internal
    {
        if (!CheapSafeCall.callOptionalBooleanNoThrow(address(token), abi.encodeWithSelector(token.approve.selector, spender, value)))
        {
            if (value == 0 ||
                !CheapSafeCall.callOptionalBoolean(address(token), abi.encodeWithSelector(token.approve.selector, spender, 0)) ||
                !CheapSafeCall.callOptionalBoolean(address(token), abi.encodeWithSelector(token.approve.selector, spender, value)))
            {
                revert ApprovalFailed(); 
            }
        }
    }
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/utils/StorageSlot.sol";

library Roles
{
    error MissingRole();

    bytes32 private constant RoleSlotPrefix = keccak256("SLOT:Roles:role");

    function hasRole(bytes32 role, address user)
        internal
        view
        returns (bool)
    {
        return StorageSlot.getBooleanSlot(keccak256(abi.encodePacked(RoleSlotPrefix, role, user))).value;
    }

    function setRole(bytes32 role, address user, bool enable)
        internal
    {
        StorageSlot.getBooleanSlot(keccak256(abi.encodePacked(RoleSlotPrefix, role, user))).value = enable;
    }

    modifier onlyRole(bytes32 role)
    {
        if (!hasRole(role, msg.sender)) { revert MissingRole(); }
        _;
    }
}

// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./Base/UpgradeableBase.sol";
import "./IREUSDMinter.sol";
import "./Base/REUSDMinterBase.sol";

contract REUSDMinter is REUSDMinterBase, UpgradeableBase(1), IREUSDMinter
{
    bool public constant isREUSDMinter = true;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(IRECustodian _custodian, IREUSD _REUSD, IREStablecoins _stablecoins)
        REUSDMinterBase(_custodian, _REUSD, _stablecoins)
    {
    }

    function checkUpgradeBase(address newImplementation)
        internal
        override
        view
    {
        assert(IREUSDMinter(newImplementation).isREUSDMinter());
    }

    function mint(IERC20 paymentToken, uint256 reusdAmount)
        public
    {
        mintREUSDCore(msg.sender, paymentToken, msg.sender, reusdAmount);
    }

    function mintPermit(IERC20Full paymentToken, uint256 reusdAmount, uint256 permitAmount, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        public
    {
        IERC20Permit(paymentToken).permit(msg.sender, address(this), permitAmount, deadline, v, r, s);
        mintREUSDCore(msg.sender, paymentToken, msg.sender, reusdAmount);
    }

    function mintTo(IERC20 paymentToken, address recipient, uint256 reusdAmount)
        public
    {
        mintREUSDCore(msg.sender, paymentToken, recipient, reusdAmount);
    }
}