// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Auction.sol"; //  Auction 拍卖合约

contract AuctionFactory {
    address public owner;
    address public admin;
    uint256 public auctionId;
    address[] public auctions;

    // event AuctionCreated(address indexed auctionContract, address indexed creator, uint256 auctionId);
    event AuctionCreated(address indexed auctionContract);
    constructor() {
        auctionId = 1;
        owner = msg.sender;
    }

    // @notice 创建一个新的拍卖合约实例
    // @param nftContract NFT 合约地址
    // @param tokenId NFT Token ID
    // @param duration 拍卖时长（秒）
    // @param minBid 最低出价
    // function createAuction(
    //     address auctionAddress,
    //     address _nftContract,
    //     address _seller,
    //     uint256 _tokenId,
    //     uint256 _duration,
    //     uint256 _minBid
    // ) external returns(address){
        //chainlink提供的sepolia预言机合约地址
        // address _priceFeed= 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        //新的拍卖合约，代理升级合约需要hardhat部署好作为入参传进来，不可以new
        // Auction newAuction = new Auction(); 
        // newAuction.initialize(admin,_nftContract,_seller,_tokenId,_duration,_minBid);
        
        //授权NFT给新合约，合约本身没有NFT的情况下，无法执行该授权的；记录此代码告诫
        // IERC721(_nftContract).approve(address(newAuction),_tokenId);
        
        //记录拍卖
        // auctions.push(address(newAuction));
        // 触发事件
        // emit AuctionCreated(address(newAuction), msg.sender, auctionId);

        // return address(newAuction);

    // }

    function createAuction(address auctionAddress) external {
        auctions.push(auctionAddress);
        emit AuctionCreated(auctionAddress);
    }

//    function getAuctionCount() external view returns (uint256) {
//         return auctions.length;
//     }

    // function getAuction(uint256 index) external view returns (address) {
    //     require(index < auctions.length, "Index out of bounds");
    //     return auctions[index];
    // }
}