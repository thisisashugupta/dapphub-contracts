// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console2} from "forge-std/Test.sol";
import {DappRegistry} from "../src/DappRegistry.sol";

contract DappRegistryTest is Test {
    DappRegistry dappRegistry;
    address dummyNFTAddress = address(0x1);

    function setUp() public {
        dappRegistry = new DappRegistry(dummyNFTAddress);
    }

    function testFuzzProjectDetails(string memory _repoUrl, string[] memory _tags) public {
        // Fuzz test the registerDapp function with different repoUrls and tags
        bytes memory signature = new bytes(65); // Dummy signature, would be replaced with a real one in a proper test environment
        vm.assume(_repoUrl.length > 10 && _repoUrl.length < 100); // Assume repo URL has a reasonable length
        for (uint i = 0; i < _tags.length; i++) {
            vm.assume(bytes(_tags[i]).length > 0 && bytes(_tags[i]).length < 50); // Assume tags have reasonable lengths
        }
        dappRegistry.registerDapp(_repoUrl, _tags, signature);
        // Add assertions here to check the state after registration
    }

    function testFuzzSignatureVerification(bytes memory _signature) public {
        // Fuzz test the signature verification logic
        string memory repoUrl = "https://github.com/example";
        string[] memory tags = new string[](1);
        tags[0] = "DeFi";
        dappRegistry.registerDapp(repoUrl, tags, _signature);
        // Add assertions here to check if the registration was successful or reverted as expected
    }

    function testFuzzAccessControl(address _caller) public {
        // Fuzz test access control by trying to register a dApp from different addresses
        vm.startPrank(_caller);
        string memory repoUrl = "https://github.com/example";
        string[] memory tags = new string[](1);
        tags[0] = "DeFi";
        bytes memory signature = new bytes(65); // Dummy signature
        dappRegistry.registerDapp(repoUrl, tags, signature);
        // Add assertions here to check if the caller was able to register
        vm.stopPrank();
    }

    // Additional test functions would be written following the above structure,
    // including fuzzing the creation of the dAppContract, event emissions, and so on.

    // ... rest of the fuzzing tests ...
}
