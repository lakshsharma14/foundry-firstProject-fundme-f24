// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetworkConfig public ActiveNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INTIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 1115511) {
            ActiveNetworkConfig = getSepoliaEthConig();
        } else {
            ActiveNetworkConfig = Get_OR_Create_AnvilEthConfig();
        }
    }

    struct NetworkConfig {
        address priceFeed; //ETH/USD PRICE FEED ADDRESS
    }

    function getSepoliaEthConig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory SepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return SepoliaConfig;
    }

    function Get_OR_Create_AnvilEthConfig()
        public
        returns (NetworkConfig memory)
    {
        if (ActiveNetworkConfig.priceFeed != address(0)) {
            return ActiveNetworkConfig;
        }

        //price feed address
        //deploy the mocks
        //return the mocks address

        vm.startBroadcast();
        MockV3Aggregator MockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INTIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(MockPriceFeed)
        });
        return anvilConfig;
    }
}
