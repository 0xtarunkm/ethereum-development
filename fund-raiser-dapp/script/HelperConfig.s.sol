// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

contract HelperConfig {
    NetworkConfig public activeNetwork;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetwork = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetwork = getMainnetEthConfig();
        } else {
            activeNetwork = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
        
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
    }
}