// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() external view { 
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
    
    function testOwnerIsDeployer() external view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersion() external view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
        console.log("version: ", version);
    }
}