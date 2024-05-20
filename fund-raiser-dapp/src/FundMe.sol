// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";


contract FundMe {
    using PriceConverter for uint256;
    
    uint256 public minimumUsd = 5e18;

    address[] public funders;

    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= minimumUsd, "didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() external onlyOwner {
        require(msg.sender == owner, "must be owner");
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // resetting the array
        funders = new address[](0);
        // withdraw the funds
        payable(msg.sender).transfer(address(this).balance);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "sender must be owner");
        _;
    }
}