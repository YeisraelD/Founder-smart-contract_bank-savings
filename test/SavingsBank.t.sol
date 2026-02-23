// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SavingsBank.sol";

contract SavingsBankTest is Test {
    SavingsBank bank;
    address user1 = address(0x1);
    address user2 = address(0x2);

    function setUp() public {
        bank = new SavingsBank();
    }

    function testDeposit() public {
        vm.deal(user1, 10 ether);
        vm.prank(user1);
        bank.deposit{value: 1 ether}();
        assertEq(bank.getBalance(user1), 1 ether);
        assertEq(bank.getTotalBalance(), 1 ether);
    }

    function testWithdraw() public {
        vm.deal(user1, 10 ether);
        vm.prank(user1);
        bank.deposit{value: 2 ether}();

        vm.prank(user1);
        bank.withdraw(1 ether);
        assertEq(bank.getBalance(user1), 1 ether);
        assertEq(bank.getTotalBalance(), 1 ether);
    }

    function testCannotWithdrawMoreThanBalance() public {
        vm.deal(user1, 10 ether);
        vm.prank(user1);
        bank.deposit{value: 1 ether}();

        vm.prank(user1);
        vm.expectRevert("Insufficient balance");
        bank.withdraw(2 ether);
    }

    function testMultipleUsers() public {
        vm.deal(user1, 5 ether);
        vm.deal(user2, 5 ether);

        vm.prank(user1);
        bank.deposit{value: 2 ether}();

        vm.prank(user2);
        bank.deposit{value: 3 ether}();

        assertEq(bank.getBalance(user1), 2 ether);
        assertEq(bank.getBalance(user2), 3 ether);
        assertEq(bank.getTotalBalance(), 5 ether);
    }
}