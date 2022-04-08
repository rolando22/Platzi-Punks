// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Base64.sol";

contract PlatziPunks is ERC721, ERC721Enumerable {

    using Counters for Counters.Counter;
    Counters.Counter private _idCounter;
    uint256 public maxSupply;
    address payable public owner;

    constructor(uint256 _maxSupply) ERC721("PlatziPunk", "PLPKS") {
        maxSupply = _maxSupply;
        owner = payable(msg.sender);
    }

    function mint() public payable {
        require(_idCounter.current() < maxSupply, "No PlatziPunks left");
        require(msg.value >= 50000000000000000,"you neet 0.05 ETH to mint the PlatziPunks");
        _safeMint(msg.sender, _idCounter.current());
        owner.transfer(msg.value);
        _idCounter.increment();
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721 Metadata: URI query for nonexistent token");
        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{"name": "Platzi Punks #',
                tokenId,
                '", "description": "Platzi Punks are randomized Avataaars stored on chain to teach DApp development on Platzi", "imagen": "',
                "//TODO: Calculate imagen URL",
                '"}'
            )
        );
        return string(abi.encode("data:application/json;base64,", jsonURI));
    }

    //Override require

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
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