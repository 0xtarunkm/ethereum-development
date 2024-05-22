// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        fundMe = new FundMe();
    }

    function testMinimumDollarIsFive() external view { 
        assertEq(fundMe.minimumUsd(), 5e18);
    }
    function testOwnerIsDeployer() external view {
        console.log("owner: ", fundMe.owner());
        console.log("this: ", address(this));
        assertEq(fundMe.owner(), address(this));
    }

    function testPriceFeedVersion() external view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
        console.log("version: ", version);
    }
}