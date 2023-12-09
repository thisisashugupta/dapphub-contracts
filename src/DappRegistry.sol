// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Contract.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DappRegistry is Ownable {
    // Event for new dApp registration
    event DappRegistered(address indexed dappOwner, address dappContract);

    // Struct to hold dApp information
    struct Dapp {
        string repoUrl;
        string[] tags;
        address dappContract;
    }

    // Mapping from owner address to their dApp
    mapping(address => Dapp) public dapps;

    // ERC721 token for representing dApp tags as soulbound NFTs
    // Assuming you have an ERC721 contract that represents soulbound tokens
    IERC721 public soulboundNFT;

    constructor(address _soulboundNFT) {
        soulboundNFT = IERC721(_soulboundNFT);
    }

    // Function to register a new dApp and create a new smart contract
    function registerDapp(string memory _repoUrl, string[] memory _tags, bytes memory _signature) external {
        // TODO: Verify the signature (off-chain through MetaMask)

        // Create a new dApp contract
        address dappContract = address(new DappContract(msg.sender));

        // Store dApp details
        Dapp memory newDapp = Dapp({
            repoUrl: _repoUrl,
            tags: _tags,
            dappContract: dappContract
        });

        dapps[msg.sender] = newDapp;

        // Issue soulbound NFTs for the tags
        for (uint i = 0; i < _tags.length; i++) {
            // Assuming the soulboundNFT contract has a mint function
            // that mints the token and binds it to the dApp contract
            soulboundNFT.mint(dappContract, _tags[i]);
        }

        emit DappRegistered(msg.sender, dappContract);
    }
}

// Separate contract for each dApp
contract DappContract is Ownable {
    address public creator;

    constructor(address _creator) {
        creator = _creator;
        transferOwnership(_creator);
    }

    // Additional functionality specific to the dApp can be added here
}

// Interface for the soulbound NFT (ERC721)
interface IERC721 {
    function mint(address to, string memory tag) external;
}

