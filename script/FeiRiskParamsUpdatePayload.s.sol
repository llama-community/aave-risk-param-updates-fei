// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.11;

import "forge-std/Script.sol";
import "src/FeiRiskParamsUpdate.sol";


contract FeiRiskParamsUpdateDeployScript is Script {

    function run() external {
        vm.startBroadcast();

        FeiRiskParamsUpdate fei = new FeiRiskParamsUpdate();

        vm.stopBroadcast();
    }
}