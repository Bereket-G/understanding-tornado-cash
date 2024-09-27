// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract SimpleTornado {
    mapping(bytes32 => bool) public commitments; // Stores commitment hashes
    uint256 public constant depositAmount = 1 ether;

    // User deposits funds by sending a commitment hash
    function deposit(bytes32 _commitmentHash) public payable {
        require(msg.value == depositAmount, "Incorrect deposit amount");
        require(!commitments[_commitmentHash], "Commitment already exists");

        commitments[_commitmentHash] = true; // Store the commitment
    }

    // User can withdraw by showing the secret associated with their commitment
    function withdraw(address payable _recipient, bytes32 _commitmentHash) public {
        require(commitments[_commitmentHash], "Invalid commitment");
        
        // Remove commitment so it can't be used again
        commitments[_commitmentHash] = false;

        // Send the deposited funds to the recipient
        (bool success, ) = _recipient.call{value: depositAmount}("");
        require(success, "Failed to send funds");
    }
}
