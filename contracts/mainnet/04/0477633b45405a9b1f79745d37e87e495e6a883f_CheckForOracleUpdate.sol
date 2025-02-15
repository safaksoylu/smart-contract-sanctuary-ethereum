/**
 *Submitted for verification at Etherscan.io on 2022-11-09
*/

pragma solidity 0.8.12;

interface ICauldron {
    function COLLATERIZATION_RATE() external view returns (uint256);
    function exchangeRate() external view returns (uint256);
    function oracle() external view returns (IOracle);
    function oracleData() external view returns (bytes memory);
    function updateExchangeRate() external returns (bool updated, uint256 rate);
}

interface IOracle {
    /// @notice Check the last exchange rate without any state changes.
    /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
    /// For example:
    /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
    /// @return success if no valid (recent) rate is available, return false else true.
    /// @return rate The rate of the requested asset / pair / pool.
    function peek(bytes calldata data) external view returns (bool success, uint256 rate);
}

contract CheckForOracleUpdate {
    
    uint256 private constant EXCHANGERATE_PRECISION = 1e18;
    uint256 private constant COLLATERIZATION_RATE_PRECISION = 1e5;

    function checker(ICauldron cauldron)
        external
        view
        returns (bool canExec, bytes memory execPayload)
    {
        uint256 collateralizationDelta = COLLATERIZATION_RATE_PRECISION - cauldron.COLLATERIZATION_RATE();

        ( ,uint256 currentRate) = cauldron.oracle().peek(cauldron.oracleData());

        uint256 staleRate = cauldron.exchangeRate();

        canExec = false;

        if (staleRate + staleRate * collateralizationDelta / COLLATERIZATION_RATE_PRECISION < currentRate) {
            canExec = true;
        }

        execPayload = abi.encodeCall(ICauldron.updateExchangeRate, ());
    }
}