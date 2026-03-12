// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter counter;

    function setUp() public {
        counter = new Counter();
    }

    function testInitialValue() public {
        assertEq(counter.number(), 0);
    }

    function testSetNumber() public {
        counter.setNumber(10);
        assertEq(counter.number(), 10);
    }

    function testIncrement() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }
}