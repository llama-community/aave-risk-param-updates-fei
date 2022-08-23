// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

interface IProposalGenericExecutor {
    function execute() external;
}

interface ILendingPoolAddressesProvider {
    function getLendingPoolConfigurator() external returns (address);

    function getPriceOracle() external view returns (address);
}

interface ILendingPoolConfigurator {
    function initReserve(
        address aTokenImpl,
        address stableDebtTokenImpl,
        address variableDebtTokenImpl,
        uint8 underlyingAssetDecimals,
        address interestRateStrategyAddress
    ) external;

    function configureReserveAsCollateral(
        address asset,
        uint256 ltv,
        uint256 liquidationThreshold,
        uint256 liquidationBonus
    ) external;

    function disableBorrowingOnReserve(
        address asset
    ) external;

    function setReserveFactor(address asset, uint256 reserveFactor) external;
}

contract FeiRiskParamsUpdate is IProposalGenericExecutor {
    ILendingPoolAddressesProvider
        public constant LENDING_POOL_ADDRESSES_PROVIDER =
        ILendingPoolAddressesProvider(
            0xB53C1a33016B2DC2fF3653530bfF1848a515c8c5
        );

    address public constant FEI = 0x956F47F50A910163D8BF957Cf5846D573E7f87CA;

    uint256 public constant LTV = 0;
    uint256 public constant LIQUIDATION_THRESHOLD = 0;
    /// not sure if this is the right value, from my understanding it can either be 0 or 10000 (still 0% bonus)
    uint256 public constant LIQUIDATION_BONUS = 0;

    function execute() external override {

        ILendingPoolConfigurator lendingPoolConfigurator = ILendingPoolConfigurator(
                LENDING_POOL_ADDRESSES_PROVIDER.getLendingPoolConfigurator()
            );
        
        lendingPoolConfigurator.disableBorrowingOnReserve(FEI);
        
        lendingPoolConfigurator.configureReserveAsCollateral(
            FEI,
            LTV,
            LIQUIDATION_THRESHOLD,
            LIQUIDATION_BONUS
        );
    }
}
