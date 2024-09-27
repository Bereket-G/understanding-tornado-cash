// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol"; // Import OpenZeppelin's MerkleProof library

contract TornadoWithMerkleTree {
    bytes32 public merkleRoot; // Merkle root of the commitments
    bytes32[] public commitments; // Array to store commitments
    uint256 public constant depositAmount = 1 ether;

    // Deposit function with a commitment
    function deposit(bytes32 _commitmentHash) public payable {
        require(msg.value == depositAmount, "Incorrect deposit amount");

        commitments.push(_commitmentHash); // Add commitment to array
        merkleRoot = calculateMerkleRoot(); // Update the Merkle root
    }

    // Withdraw function with Merkle proof
    function withdraw(
        address payable _recipient,
        bytes32 _commitmentHash,
        bytes32[] memory _merkleProof
    ) public {
        require(MerkleProof.verify(_merkleProof, merkleRoot, _commitmentHash), "Invalid Merkle proof");

        // Send the funds to the recipient
        (bool success, ) = _recipient.call{value: depositAmount}("");
        require(success, "Failed to send funds");
    }

    // Internal function to calculate the Merkle root from the commitments array
    function calculateMerkleRoot() internal view returns (bytes32) {
        uint256 numLeaves = commitments.length;

        if (numLeaves == 0) {
            return bytes32(0); // If no leaves, root is zero
        }

        // Start with the leaf nodes as the initial hashes
        bytes32[] memory hashes = commitments;

        // Compute the tree up to the root
        while (hashes.length > 1) {
            uint256 newLength = (hashes.length + 1) / 2;
            bytes32[] memory newHashes = new bytes32[](newLength);

            for (uint256 i = 0; i < hashes.length; i += 2) {
                if (i + 1 < hashes.length) {
                    newHashes[i / 2] = keccak256(abi.encodePacked(hashes[i], hashes[i + 1]));
                } else {
                    newHashes[i / 2] = hashes[i]; // Handle odd number of leaves
                }
            }

            hashes = newHashes;
        }

        return hashes[0]; // Return the root
    }
}
