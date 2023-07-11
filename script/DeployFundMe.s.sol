// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // anything before broadcast not gonna send as a real transaction
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        // anything after broadcast is gonna send as a real transaction

        return fundMe;
    }

    function printStorageData(address contractAddress) public view {
        for (uint256 i = 0; i < 10; i++) {
            bytes32 value = vm.load(contractAddress, bytes32(i));
            console.log("Vale at location", i, ":");
            console.logBytes32(value);
        }
    }

    function printFirstArrayElement(address contractAddress) public view {
        bytes32 arrayStorageSlotLength = bytes32(uint256(2));
        bytes32 firstElementStorageSlot = keccak256(
            abi.encode(arrayStorageSlotLength)
        );
        bytes32 value = vm.load(contractAddress, firstElementStorageSlot);
        console.log("First element in array:");
        console.logBytes32(value);
    }
}
