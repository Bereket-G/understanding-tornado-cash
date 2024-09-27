// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TornadoWithMerkleTree} from "../src/2-TornadoWithMerkleTree/TornadoWithMerkleTree.sol";

contract TornadoWithMerkleTreeTest is Test {
    TornadoWithMerkleTree public tornadoWithMerkleTree;

    function setUp() public {
        tornadoWithMerkleTree = new TornadoWithMerkleTree();
    }

    function testDepositAndWithdraw() public {
        bytes32 commitment1 = bytes32(uint256(1));

        bytes32 commitment2 = bytes32(uint256(2));
        
        tornadoWithMerkleTree.deposit{value: 1 ether}(commitment1);

        console.log("Merkle root after deposit 1");
        console.logBytes32(tornadoWithMerkleTree.merkleRoot());

        tornadoWithMerkleTree.deposit{value: 1 ether}(commitment2);
        
        // Add logging after the deposit
        console.log("Merkle root after deposit 2");
        console.logBytes32(tornadoWithMerkleTree.merkleRoot());
        
        assertEq(address(tornadoWithMerkleTree).balance, 2 ether);

        bytes32 commitmentsOf1 = tornadoWithMerkleTree.commitments(0);
        bytes32 commitmentsOf2 = tornadoWithMerkleTree.commitments(1);
        // Generate Merkle proof
        bytes32[] memory proof1 = new bytes32[](1);
        proof1[0]= commitmentsOf2;

        bytes32[] memory proof2 = new bytes32[](1);
        proof2[0]= commitmentsOf1;

        // // Withdraw
        tornadoWithMerkleTree.withdraw(payable(vm.addr(2)), commitment1, proof1);

        tornadoWithMerkleTree.withdraw(payable(vm.addr(2)), commitment2, proof2);

        assertEq(vm.addr(2).balance, 2 ether);
    }
}