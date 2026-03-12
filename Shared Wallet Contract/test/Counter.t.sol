// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter counter;
    address owner;
    address user1;
    address user2;

    function setUp() public {
        owner = address(this); // test contract is owner
        user1 = address(0x1);
        user2 = address(0x2);

        counter = new Counter();
    }
     function testDepositIncreasesBalance() public {
    vm.deal(user1, 2 ether); // Give user1 2 ETH

    // First deposit
    vm.prank(user1);
    counter.deposit{value: 1 ether}();
    assertEq(counter.balances(user1), 1 ether);
    assertEq(counter.totalBalance(), 1 ether);

    // Second deposit
    vm.prank(user1);
    counter.deposit{value: 0.5 ether}();
    assertEq(counter.balances(user1), 1.5 ether);
    assertEq(counter.totalBalance(), 1.5 ether);
}


 
    function testMultipleUsersDeposit() public {
        vm.deal(user1, 1 ether);
        vm.deal(user2, 2 ether);

        vm.prank(user1);
        counter.deposit{value: 1 ether}();

        vm.prank(user2);
        counter.deposit{value: 2 ether}();

        assertEq(counter.balances(user1), 1 ether);
        assertEq(counter.balances(user2), 2 ether);
        assertEq(counter.totalBalance(), 3 ether);
    }

    function testOwnerCanWithdraw() public {
    // Deposit first
    vm.deal(user1, 1 ether);
    vm.prank(user1);
    counter.deposit{value: 1 ether}();

    // Give the owner some Ether so transfer works
    vm.deal(owner, 0);

    uint256 ownerBalanceBefore = owner.balance;

    // Owner withdraws 0.5 ether
    counter.withdraw(0.5 ether);

    // Check total balance decreases
    assertEq(counter.totalBalance(), 0.5 ether);

    // Owner should have received the funds
    assertEq(owner.balance, ownerBalanceBefore + 0.5 ether);
}
    function testNonOwnerCannotWithdraw() public {
        // Deposit first
        vm.deal(user1, 1 ether);
        vm.prank(user1);
        counter.deposit{value: 1 ether}();

        // Non-owner tries to withdraw
        vm.prank(user1);
        vm.expectRevert("Only owner can withdraw");
        counter.withdraw(1 ether);
    }

    function testCannotWithdrawMoreThanBalance() public {
        // Deposit first
        vm.deal(user1, 1 ether);
        vm.prank(user1);
        counter.deposit{value: 1 ether}();

        // Owner tries to withdraw too much
        vm.expectRevert("Not enough balance in wallet");
        counter.withdraw(2 ether);
    }

    function testDepositRecordedInArray() public {
        vm.deal(user1, 1 ether);
        vm.prank(user1);
        counter.deposit{value: 1 ether}();

        // There should be 1 deposit
        (, uint256 amount, ) = counter.deposits(0);
        assertEq(amount, 1 ether);
    }
}