// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "../lib/forge-std/src/Script.sol";
import {CrowdFund} from "../src/CrowdFund.sol";

contract DeployCrowdFund is Script {
    function run() external {
        vm.startBroadcast();

        CrowdFund crowdFund = new CrowdFund();

        vm.stopBroadcast();
    }
}
