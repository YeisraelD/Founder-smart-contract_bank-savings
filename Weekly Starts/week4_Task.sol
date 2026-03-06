// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ATM {
//variables
    address public owner;
    bool public paused;

    mapping(address => uint256) private balances;
//modefiers
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }
//constructors

    constructor() {
        owner = msg.sender;
        paused = false;
    }


//user functions

    // Deposit ETH into ATM
    function deposit() public payable whenNotPaused {
        require(msg.value > 0, "Deposit must be greater than 0");
        balances[msg.sender] += msg.value;
    }

    // Withdraw ETH from ATM
    function withdraw(uint256 amount) public whenNotPaused {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

    // Check your balance
    function checkBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
//owner functions

    function pause() public onlyOwner {
        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }
}
