// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 引入 OpenZeppelin 的 ERC721 和 Ownable 合约
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721 {
    uint256 private _nextTokenId; // 用于追踪下一个可用的 Token ID

    // 构造函数：设置 NFT 的名称和符号
    constructor() ERC721("MyNFT", "MNFT") {
        _nextTokenId = 1; // 从 Token ID 1 开始
    }

    /**
     * @dev 铸造 NFT 给指定的地址，并设置其 tokenURI（元数据链接）
     * @param to 接收该 NFT 的地址
     * @param testTokenURI 该 NFT 的元数据链接，通常是 IPFS 或 HTTP 地址https://bafybeibb35iscdgzzgfxqv4ly2f6koiade2k7ptre6yvnf7iwirrgfocci.ipfs.dweb.link?filename=test.json
     */
    function mintNFT(address to, string memory testTokenURI) public {
        uint256 tokenId = _nextTokenId;
        _nextTokenId++;

        // 调用 _safeMint 安全铸造，并设置 tokenURI
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, testTokenURI);
    }

    /**
     * 内部函数：为指定 Token ID 设置元数据 URI
     * OpenZeppelin 的 ERC721 合约默认不直接暴露 setTokenURI，因此我们通过重写 _baseURI 或直接扩展实现
     * 这里我们采用一种常见的扩展方式：在合约中手动设置 tokenURI（非标准，但适用于定制化需求）
     */
    function _setTokenURI(uint256 tokenId, string memory testTokenURI) internal {
        // OpenZeppelin 的 ERC721 URI 存储是通过重写 tokenURI() 函数实现的
        // 所以我们需要自己存储 tokenId => tokenURI 的映射
        _tokenURIs[tokenId] = testTokenURI;
    }

    // 存储每个 Token ID 对应的 URI
    mapping(uint256 => string) private _tokenURIs;

    /**
     * @dev 重写 tokenURI 函数，返回该 tokenId 的元数据链接
     */
    function tokenURI(uint256 tokenId)public view override returns (string memory){
        return _tokenURIs[tokenId];
    }

    /**
     * （可选）查询下一个可用的 Token ID
     */
    function getNextTokenId() public view returns (uint256) {
        return _nextTokenId;
    }
}