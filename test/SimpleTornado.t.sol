// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SimpleTornado} from "../src/1-SimpleTornado/SimpleTornado.sol";

contract SimpleTornadoTest is Test {
    SimpleTornado public simpleTornado;


    function setUp() public {
        simpleTornado = new SimpleTornado();
    }

    function test() public {
        bytes32 commitment = bytes32(uint256(1));
        simpleTornado.deposit{value: 1 ether}(commitment);
        assertEq(address(simpleTornado).balance, 1 ether);

        simpleTornado.withdraw(payable(vm.addr(1)), commitment);
        assertEq(vm.addr(1).balance, 1 ether);
    }
}
