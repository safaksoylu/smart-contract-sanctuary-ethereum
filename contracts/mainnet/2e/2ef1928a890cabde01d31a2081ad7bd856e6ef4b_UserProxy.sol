// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;
pragma abicoder v2;

import "./utils/UserProxyStorage.sol";
import "./utils/Multicall.sol";

/**
 * @dev UserProxy contract
 */
contract UserProxy is Multicall {
    // Below are the variables which consume storage slots.
    address public operator;
    string public version; // Current version of the contract
    address private nominatedOperator;

    // Operator events
    event OperatorNominated(address indexed newOperator);
    event OperatorChanged(address indexed oldOperator, address indexed newOperator);
    event SetAMMStatus(bool enable);
    event UpgradeAMMWrapper(address newAMMWrapper);
    event SetPMMStatus(bool enable);
    event UpgradePMM(address newPMM);
    event SetRFQStatus(bool enable);
    event UpgradeRFQ(address newRFQ);
    event SetLimitOrderStatus(bool enable);
    event UpgradeLimitOrder(address newLimitOrder);

    receive() external payable {}

    /************************************************************
     *          Access control and ownership management          *
     *************************************************************/
    modifier onlyOperator() {
        require(operator == msg.sender, "UserProxy: not the operator");
        _;
    }

    function nominateNewOperator(address _newOperator) external onlyOperator {
        require(_newOperator != address(0), "UserProxy: operator can not be zero address");
        nominatedOperator = _newOperator;

        emit OperatorNominated(_newOperator);
    }

    function acceptOwnership() external {
        require(msg.sender == nominatedOperator, "UserProxy: not nominated");
        emit OperatorChanged(operator, nominatedOperator);

        operator = nominatedOperator;
        nominatedOperator = address(0);
    }

    /************************************************************
     *              Constructor and init functions               *
     *************************************************************/
    /// @dev Replacing constructor and initialize the contract. This function should only be called once.
    function initialize(address _operator) external {
        require(keccak256(abi.encodePacked(version)) == keccak256(abi.encodePacked("")), "UserProxy: not upgrading from empty");
        require(_operator != address(0), "UserProxy: operator can not be zero address");
        operator = _operator;

        // Upgrade version
        version = "5.3.0";
    }

    /************************************************************
     *                     Getter functions                      *
     *************************************************************/
    function ammWrapperAddr() public view returns (address) {
        return AMMWrapperStorage.getStorage().ammWrapperAddr;
    }

    function isAMMEnabled() public view returns (bool) {
        return AMMWrapperStorage.getStorage().isEnabled;
    }

    function pmmAddr() public view returns (address) {
        return PMMStorage.getStorage().pmmAddr;
    }

    function isPMMEnabled() public view returns (bool) {
        return PMMStorage.getStorage().isEnabled;
    }

    function rfqAddr() public view returns (address) {
        return RFQStorage.getStorage().rfqAddr;
    }

    function isRFQEnabled() public view returns (bool) {
        return RFQStorage.getStorage().isEnabled;
    }

    function limitOrderAddr() public view returns (address) {
        return LimitOrderStorage.getStorage().limitOrderAddr;
    }

    function isLimitOrderEnabled() public view returns (bool) {
        return LimitOrderStorage.getStorage().isEnabled;
    }

    /************************************************************
     *           Management functions for Operator               *
     *************************************************************/
    function setAMMStatus(bool _enable) public onlyOperator {
        AMMWrapperStorage.getStorage().isEnabled = _enable;

        emit SetAMMStatus(_enable);
    }

    /**
     * @dev Update AMMWrapper contract address. Used only when ABI of AMMWrapeer remain unchanged.
     * Otherwise, UserProxy contract should be upgraded altogether.
     */
    function upgradeAMMWrapper(address _newAMMWrapperAddr, bool _enable) external onlyOperator {
        AMMWrapperStorage.getStorage().ammWrapperAddr = _newAMMWrapperAddr;
        AMMWrapperStorage.getStorage().isEnabled = _enable;

        emit UpgradeAMMWrapper(_newAMMWrapperAddr);
        emit SetAMMStatus(_enable);
    }

    function setPMMStatus(bool _enable) public onlyOperator {
        PMMStorage.getStorage().isEnabled = _enable;

        emit SetPMMStatus(_enable);
    }

    /**
     * @dev Update PMM contract address. Used only when ABI of PMM remain unchanged.
     * Otherwise, UserProxy contract should be upgraded altogether.
     */
    function upgradePMM(address _newPMMAddr, bool _enable) external onlyOperator {
        PMMStorage.getStorage().pmmAddr = _newPMMAddr;
        PMMStorage.getStorage().isEnabled = _enable;

        emit UpgradePMM(_newPMMAddr);
        emit SetPMMStatus(_enable);
    }

    function setRFQStatus(bool _enable) public onlyOperator {
        RFQStorage.getStorage().isEnabled = _enable;

        emit SetRFQStatus(_enable);
    }

    /**
     * @dev Update RFQ contract address. Used only when ABI of RFQ remain unchanged.
     * Otherwise, UserProxy contract should be upgraded altogether.
     */
    function upgradeRFQ(address _newRFQAddr, bool _enable) external onlyOperator {
        RFQStorage.getStorage().rfqAddr = _newRFQAddr;
        RFQStorage.getStorage().isEnabled = _enable;

        emit UpgradeRFQ(_newRFQAddr);
        emit SetRFQStatus(_enable);
    }

    function setLimitOrderStatus(bool _enable) public onlyOperator {
        LimitOrderStorage.getStorage().isEnabled = _enable;

        emit SetLimitOrderStatus(_enable);
    }

    /**
     * @dev Update Limit Order contract address. Used only when ABI of Limit Order remain unchanged.
     * Otherwise, UserProxy contract should be upgraded altogether.
     */
    function upgradeLimitOrder(address _newLimitOrderAddr, bool _enable) external onlyOperator {
        LimitOrderStorage.getStorage().limitOrderAddr = _newLimitOrderAddr;
        LimitOrderStorage.getStorage().isEnabled = _enable;

        emit UpgradeLimitOrder(_newLimitOrderAddr);
        emit SetLimitOrderStatus(_enable);
    }

    /************************************************************
     *                   External functions                      *
     *************************************************************/
    /**
     * @dev proxy the call to AMM
     */
    function toAMM(bytes calldata _payload) external payable {
        require(isAMMEnabled(), "UserProxy: AMM is disabled");

        (bool callSucceed, ) = ammWrapperAddr().call{ value: msg.value }(_payload);
        if (!callSucceed) {
            // Get the error message returned
            assembly {
                let ptr := mload(0x40)
                let size := returndatasize()
                returndatacopy(ptr, 0, size)
                revert(ptr, size)
            }
        }
    }

    /**
     * @dev proxy the call to PMM
     */
    function toPMM(bytes calldata _payload) external payable {
        require(isPMMEnabled(), "UserProxy: PMM is disabled");
        require(msg.sender == tx.origin, "UserProxy: only EOA");

        (bool callSucceed, ) = pmmAddr().call{ value: msg.value }(_payload);
        if (!callSucceed) {
            // Get the error message returned
            assembly {
                let ptr := mload(0x40)
                let size := returndatasize()
                returndatacopy(ptr, 0, size)
                revert(ptr, size)
            }
        }
    }

    /**
     * @dev proxy the call to RFQ
     */
    function toRFQ(bytes calldata _payload) external payable {
        require(isRFQEnabled(), "UserProxy: RFQ is disabled");
        require(msg.sender == tx.origin, "UserProxy: only EOA");

        (bool callSucceed, ) = rfqAddr().call{ value: msg.value }(_payload);
        if (!callSucceed) {
            // Get the error message returned
            assembly {
                let ptr := mload(0x40)
                let size := returndatasize()
                returndatacopy(ptr, 0, size)
                revert(ptr, size)
            }
        }
    }

    function toLimitOrder(bytes calldata _payload) external {
        require(isLimitOrderEnabled(), "UserProxy: Limit Order is disabled");
        require(msg.sender == tx.origin, "UserProxy: only EOA");

        (bool callSucceed, ) = limitOrderAddr().call(_payload);
        if (!callSucceed) {
            // Get the error message returned
            assembly {
                let ptr := mload(0x40)
                let size := returndatasize()
                returndatacopy(ptr, 0, size)
                revert(ptr, size)
            }
        }
    }
}

pragma solidity >=0.7.0;
pragma abicoder v2;

interface IMulticall {
    event MulticallFailure(uint256 index, string reason);

    function multicall(bytes[] calldata data, bool revertOnFail) external returns (bool[] memory successes, bytes[] memory results);
}

// SPDX-License-Identifier: MIT
pragma solidity 0.7.6;
pragma abicoder v2;

import "../interfaces/IMulticall.sol";

// Modified from https://github.com/Uniswap/uniswap-v3-periphery/blob/v1.1.1/contracts/base/Multicall.sol
abstract contract Multicall is IMulticall {
    function multicall(bytes[] calldata data, bool revertOnFail) external override returns (bool[] memory successes, bytes[] memory results) {
        successes = new bool[](data.length);
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; ++i) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            successes[i] = success;
            results[i] = result;

            if (!success) {
                // Get failed reason
                string memory revertReason;
                if (result.length < 68) {
                    revertReason = "Delegatecall failed";
                } else {
                    assembly {
                        result := add(result, 0x04)
                    }
                    revertReason = abi.decode(result, (string));
                }

                if (revertOnFail) {
                    revert(revertReason);
                }
                emit MulticallFailure(i, revertReason);
            }
        }
    }
}

pragma solidity ^0.7.6;

library AMMWrapperStorage {
    bytes32 private constant STORAGE_SLOT = 0xbf49677e3150252dfa801a673d2d5ec21eaa360a4674864e55e79041e3f65a6b;

    /// @dev Storage bucket for proxy contract.
    struct Storage {
        // The address of the AMMWrapper contract.
        address ammWrapperAddr;
        // Is AMM enabled
        bool isEnabled;
    }

    /// @dev Get the storage bucket for this contract.
    function getStorage() internal pure returns (Storage storage stor) {
        assert(STORAGE_SLOT == bytes32(uint256(keccak256("userproxy.ammwrapper.storage")) - 1));
        bytes32 slot = STORAGE_SLOT;

        // Dip into assembly to change the slot pointed to by the local
        // variable `stor`.
        // See https://solidity.readthedocs.io/en/v0.6.8/assembly.html?highlight=slot#access-to-external-variables-functions-and-libraries
        assembly {
            stor.slot := slot
        }
    }
}

library PMMStorage {
    bytes32 private constant STORAGE_SLOT = 0x8f135983375ba6442123d61647e7325c1753eabc2e038e44d3b888a970def89a;

    /// @dev Storage bucket for proxy contract.
    struct Storage {
        // The address of the PMM contract.
        address pmmAddr;
        // Is PMM enabled
        bool isEnabled;
    }

    /// @dev Get the storage bucket for this contract.
    function getStorage() internal pure returns (Storage storage stor) {
        assert(STORAGE_SLOT == bytes32(uint256(keccak256("userproxy.pmm.storage")) - 1));
        bytes32 slot = STORAGE_SLOT;

        // Dip into assembly to change the slot pointed to by the local
        // variable `stor`.
        // See https://solidity.readthedocs.io/en/v0.6.8/assembly.html?highlight=slot#access-to-external-variables-functions-and-libraries
        assembly {
            stor.slot := slot
        }
    }
}

library RFQStorage {
    bytes32 private constant STORAGE_SLOT = 0x857df08bd185dc66e3cc5e11acb4e1dd65290f3fee6426f52f84e8faccf229cf;

    /// @dev Storage bucket for proxy contract.
    struct Storage {
        // The address of the RFQ contract.
        address rfqAddr;
        // Is RFQ enabled
        bool isEnabled;
    }

    /// @dev Get the storage bucket for this contract.
    function getStorage() internal pure returns (Storage storage stor) {
        assert(STORAGE_SLOT == bytes32(uint256(keccak256("userproxy.rfq.storage")) - 1));
        bytes32 slot = STORAGE_SLOT;

        // Dip into assembly to change the slot pointed to by the local
        // variable `stor`.
        // See https://solidity.readthedocs.io/en/v0.6.8/assembly.html?highlight=slot#access-to-external-variables-functions-and-libraries
        assembly {
            stor.slot := slot
        }
    }
}

library LimitOrderStorage {
    bytes32 private constant STORAGE_SLOT = 0xf1a59a985b4002cdf0db464f05bed7182ee06372a999d820ea1883b8bf067ce5;

    /// @dev Storage bucket for proxy contract.
    struct Storage {
        // The address of the Limit Order contract.
        address limitOrderAddr;
        // Is Limit Order enabled
        bool isEnabled;
    }

    /// @dev Get the storage bucket for this contract.
    function getStorage() internal pure returns (Storage storage stor) {
        assert(STORAGE_SLOT == bytes32(uint256(keccak256("userproxy.limitorder.storage")) - 1));
        bytes32 slot = STORAGE_SLOT;

        // Dip into assembly to change the slot pointed to by the local
        // variable `stor`.
        // See https://solidity.readthedocs.io/en/v0.6.8/assembly.html?highlight=slot#access-to-external-variables-functions-and-libraries
        assembly {
            stor.slot := slot
        }
    }
}