// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// OpenZeppelin 合约
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
// import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Auction is Initializable, UUPSUpgradeable{
    // constructor()initializer {}
    address seller;   // NFT 持有者 / 卖家
    address nftContract;      // NFT 合约地址
    uint256 tokenId;          // NFT Token ID
    uint256 startTime;        // 开始时间（可为 0，表示立即开始）
    uint256 endTime;          // 拍卖结束时间
    uint256 minBid;           // 最低起拍价（wei）
    address highestBidder;    // 当前最高出价者
    uint256 public highestBid;       // 当前最高出价金额  
    // address priceFeed;      //价格预言机地址
    address admin;  //管理员。升级合约
    

    // 初始化函数（替代 constructor，因为是 Upgradeable 合约）
    function initialize(
        address _admin,
        address _nftContract,
        address _seller,
        uint256 _tokenId,
        uint256 _duration,
        uint256 _minBid
    ) public initializer {
        __UUPSUpgradeable_init();
        //参数校验
        require(_seller != address(0), "Invalid NFT owner address");
        require(_nftContract != address(0), "Invalid NFT contract address");
        require(_minBid > 0, "Bid increment must be greater than 0");
        require(_duration > 0, "Duration must be greater than 0");
    //     // require(_priceFeed != address(0), "Invalid price oracle address");
        admin = _admin;
        seller = _seller;
        nftContract=_nftContract;
        tokenId = _tokenId;
        startTime = block.timestamp;
        minBid = _minBid;
        highestBidder = address(0);
        highestBid = 0;
        endTime = block.timestamp + _duration;
    }


    // 事件
    event BidPlaced(address indexed bidder, uint256 amount);
    event AuctionEnded(address indexed winner, uint256 amount);    

     function placeBid() external payable {
        require(block.timestamp < endTime, "Auction ended");
        // ETH 出价
        require(msg.value > minBid, "Bid too low");
        require(msg.value > highestBid, "Bid must be higher than current");
        // 退还ETH给前一个最高出价者
        if (highestBidder != address(0)) {
                payable(highestBidder).transfer(highestBid);
            }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit BidPlaced(msg.sender, msg.value);
    }

    /// @notice 结束拍卖，只有卖家有权结束，结束之前该拍卖合约必须拥有被拍卖的NFT或者其授权。授权由前端进行，test时由JS代码完成
    function endAuction() external {
        // Auction storage auction = auctions[auctionId];
        require(msg.sender == seller, "Not authorize end the aution");
        require(block.timestamp >= endTime, "Auction not ended");
        
        // 重置 NFT 所有权（拍卖成功，NFT转移给出价最高者,ETH转给卖家；拍卖失败，NFT退回给卖家）
        if (highestBidder != address(0)) {
                IERC721(nftContract).safeTransferFrom(seller, highestBidder,tokenId);
                payable(seller).transfer(highestBid);
            }
       
        emit AuctionEnded(highestBidder, highestBid);
    }


    // 获取当前最高出价
    function getCurrentHighestBid() public view returns(uint256){
       return highestBid;
    //    return uint256 usd = convertEthToUsd(highestBid)
    }

    // //ETH转为美元
    // function convertEthToUsd(uint256 ethAmount) internal view returns(uint256){
    //      AggregatorV3Interface dataFeed = AggregatorV3Interface(priceFeed);
    //   (
    //         uint80 roundID,
    //         int256 price,
    //         uint startedAt,
    //         uint timeStamp,
    //         uint80 answeredInRound 
    //     ) = dataFeed.latestRoundData();
    //     uint256 ethPrice = uint256(price);
    //     return ethAmount * ethPrice / (10 ** 8);
    // }

    //升级合约
      function _authorizeUpgrade(address) internal view override {
        require(msg.sender == admin,"only admin can upgrade the contract");
    }

     receive() external payable {
        // 可以在这里记录日志、更新状态等
        // 比如：emit Received(msg.sender, msg.value);
    }

    // 接收带有 calldata 的 ETH（比如调用了一个不存在的函数，但有 ETH）
    fallback() external payable {
        // 处理误调用 + 带 ETH 的情况
    }

}