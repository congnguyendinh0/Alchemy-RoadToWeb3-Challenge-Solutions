// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.6.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";

contract OpenGradientV3 is ERC721, ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;
    uint256 MAX_SUPPLY = 100000;
    uint256 MAX_PARTICIPATION = 5;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("OpenGradientV3", "OGRDNTS3") {}
    //mapping
    mapping(address => uint256) limit;

    function safeMint(address to, string memory uri) public  {
        uint256 tokenId = _tokenIdCounter.current();
        // usee mapping to limit
        require(limit[msg.sender] < MAX_PARTICIPATION, "Limit reached");
        require(_tokenIdCounter.current() <= MAX_SUPPLY, "I'm sorry we reached the cap");
        // require(balanceOf(msg.sender) < MAX_PARTICIPATION,'Each address only own less than 4'); -> bad if  the user has sold he can buy again
        limit[msg.sender] = limit[msg.sender]+1;
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
