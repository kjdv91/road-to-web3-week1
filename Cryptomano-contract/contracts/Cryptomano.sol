// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


// Contract Address Mumbai Polygon  ==> 0x22b6B1220AB052E302983e6EcfE389EcA2c78e14

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Cryptomano is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {


    using Counters for Counters.Counter;


    Counters.Counter private _tokenIdCounter;

    uint256 public constant TOTAL_SUPPLY = 100;
    uint256 public mintFee = 0.001 ether;

    uint256 public constant MAX_CARDS_PER_WALLET = 2;
    // uint256 public maxCards;

    
    constructor() ERC721("Cryptomano", "CRT") {}

  
    
    function safeMint(address to, string memory uri, uint256 _amount) public  onlyOwner payable{
        
        require(_tokenIdCounter.current() <= TOTAL_SUPPLY, "I'm sorry we reached the cap");
        require(
            mintFee * _amount <= msg.value,
            "Incorrect ETH value sent"
        );    
        //max 3 mint per transaction wallet
        require(
            balanceOf(msg.sender) + _amount <= MAX_CARDS_PER_WALLET,  
            "Max cards already minted to this wallet"
        );
        uint256 tokenId = _tokenIdCounter.current();
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


    
     function withdraw ()public onlyOwner{
        require(address(this).balance >0 , "Balance is 0");
        payable(owner()).transfer(address(this).balance);
        }



}