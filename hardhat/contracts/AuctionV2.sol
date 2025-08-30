// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "./Auction.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract AuctionV2 is Auction{
    // bool isInitializedV2 = false;
    // function initializeV2(uint256 price) external {
    //     require(!isInitializedV2, "Already initialized");
    //     isInitializedV2 = true;
    //     highestBid = price;
    // }
    function V2Print() public view returns (uint256){
        uint256 highestBid = getCurrentHighestBid();
        // string memory str = string.concat("auctionv2 get highestBid:",Strings.toString(highestBid));
        return highestBid;
    }
}