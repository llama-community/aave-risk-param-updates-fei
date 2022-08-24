// SPDX-License-Identifier: MIT

/*
   _      ΞΞΞΞ      _
  /_;-.__ / _\  _.-;_\
     `-._`'`_/'`.-'
         `\   /`
          |  /
         /-.(
         \_._\
          \ \`;
           > |/
          / //
          |//
          \(\
           ``
     defijesus.eth
*/

pragma solidity 0.8.11;

interface IProposalGenericExecutor {
    function execute() external;
}

interface ILendingPoolConfigurator {
    function freezeReserve(
        address asset
    ) external;

    function setReserveFactor(
        address asset,
        uint256 reserveFactor
    ) external;
}

contract FeiRiskParamsUpdate is IProposalGenericExecutor {
    address public constant FEI = 0x956F47F50A910163D8BF957Cf5846D573E7f87CA;
    address public constant LENDING_POOL_CONFIGURATOR = 0x311Bb771e4F8952E6Da169b425E7e92d6Ac45756;

    function execute() external override {
        ILendingPoolConfigurator(LENDING_POOL_CONFIGURATOR).freezeReserve(FEI);
        ILendingPoolConfigurator(LENDING_POOL_CONFIGURATOR).setReserveFactor(FEI, 10_000);
    }
}
