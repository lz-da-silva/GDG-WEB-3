// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SavingsBank.sol";

contract DeploySavingsBank is Script {
    function run() external {
        vm.startBroadcast();

        SavingsBank bank = new SavingsBank();

        vm.stopBroadcast();

        console.log("SavingsBank deployed at:", address(bank));
    }
}
