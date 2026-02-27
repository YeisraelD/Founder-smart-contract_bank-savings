// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SavingsBank {
    mapping(address => uint256) private balances;
    uint256 private totalBalance;

    // Events
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);

    // Deposit ETH
    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than 0");
        balances[msg.sender] += msg.value;
        totalBalance += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Withdraw ETH
    function withdraw(uint256 amount) external {
    require(amount <= balances[msg.sender], "Insufficient balance");

    balances[msg.sender] -= amount;
    totalBalance -= amount;

    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Withdraw failed");

    emit Withdrawal(msg.sender, amount);
}

    // Check user balance
    function getBalance(address user) external view returns (uint256) {
        return balances[user];
    }

    // Total ETH in contract
    function getTotalBalance() external view returns (uint256) {
        return totalBalance;
    }
    
}