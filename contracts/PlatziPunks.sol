// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./Base64.sol";
import "./PlatziPunksDNA.sol";

contract PlatziPunks is ERC721, ERC721Enumerable, PlatziPunksDNA {

    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _idCounter;
    uint256 public maxSupply;
    address payable public owner;
    mapping(uint256 => uint256) public tokenDNA;

    constructor(uint256 _maxSupply) ERC721("PlatziPunk", "PLPKS") {
        maxSupply = _maxSupply;
        owner = payable(msg.sender);
    }

    function mint() public {
        require(_idCounter.current() < maxSupply, "No PlatziPunks left");
    //    require(msg.value >= 50000000000000000,"you neet 0.05 ETH to mint the PlatziPunks");
        tokenDNA[_idCounter.current()] = deterministicPseudoRandomDNA(_idCounter.current(), msg.sender);
        _safeMint(msg.sender, _idCounter.current());
    //    owner.transfer(msg.value);
        _idCounter.increment();
    }

    function _baseURI() internal pure override returns(string memory) {
        return "https://avataaars.io/";
    }

    function _paramsURI(uint256 _dna) internal view returns(string memory) {
        string memory params;
        {
            params = string(abi.encodePacked(
                "accessoriesType=",
                getAccessoriesType(_dna),
                "&clotheColor=",
                getClotheColor(_dna),
                "&clotheType",
                getClotheType(_dna),
                "&eyeType",
                getEyeType(_dna),
                "&eyebrowType",
                getEyebrowType(_dna),
                "&facialHairColor",
                getFacialHairColor(_dna),
                "&facialHairType",
                getFacialHairType(_dna),
                "&hairColor",
                getHairColor(_dna),
                "&hatColor",
                getHatColor(_dna),
                "&graphicType",
                getGraphicType(_dna),
                "&mouthType",
                getMouthType(_dna),
                "&skinColor",
                getSkinColor(_dna)
                
            ));
        }
        return string(abi.encodePacked(params, "&topType", getTopType(_dna)));
    }

    function imageByDNA(uint256 _dna) public view returns(string memory) {
        return string(abi.encodePacked(_baseURI(), "?", _paramsURI(_dna)));
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721 Metadata: URI query for nonexistent token");
        string memory jsonURI = Base64.encode(
            abi.encodePacked(
                '{"name": "Platzi Punks #',
                tokenId.toString(),
                '", "description": "Platzi Punks are randomized Avataaars stored on chain to teach DApp development on Platzi", "image": "',
                imageByDNA(tokenDNA[tokenId]),
                '"}'
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", jsonURI));
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