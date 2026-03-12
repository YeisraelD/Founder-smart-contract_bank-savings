// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter counter;
    address user;

    function setUp() public {
        counter = new Counter();
        user = address(0x1);
        vm.deal(user, 1 ether); // give user some ETH
    }
    

    function testDeposit() public {
        vm.prank(user);
        counter.deposit{value: 0.5 ether}();

        assertEq(counter.balances(user), 0.5 ether);
        assertEq(counter.totalBalance(), 0.5 ether);
    }
    function testOwnerWithdraw() public {
    vm.prank(user);
    counter.deposit{value: 1 ether}();

    // Owner withdraws 0.5 ETH
    counter.withdraw(0.5 ether);

    // Only check totalBalance
    assertEq(counter.totalBalance(), 0.5 ether);
}

}