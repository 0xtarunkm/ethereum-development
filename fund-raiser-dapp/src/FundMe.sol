// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {PriceConverter} from "./PriceConverter.sol";
import { AggregatorV3Interface } from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;

    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() external onlyOwner {
        require(msg.sender == i_owner, "must be owner");
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // resetting the array
        funders = new address[](0);
        // withdraw the funds
        payable(msg.sender).transfer(address(this).balance);
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "sender must be owner");
        _;
    }
}