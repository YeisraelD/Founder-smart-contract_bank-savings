// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {

    /* =============================================================
                            STEP 1
       Create a Deposit struct.
       It must store:
       - user (address)
       - amount (uint256)
       - time (uint256)
    ============================================================= */

    // TODO: Define struct
        struct Deposit {
            address user;
            uint256 amount;
            uint256 time;
        }

    /* =============================================================
                            STEP 2
       Create state variables:
       - owner
       - totalBalance
       - mapping to track user balances
       - array to store deposits
    ============================================================= */

    // TODO: Declare owner
        address public owner;
    
    // TODO: Declare totalBalance
        uint256 public totalBalance;
    
    // TODO: Declare balances mapping
        mapping(address => uint256) public balances; // user address to their balance
    
    // TODO: Declare deposits array
        Deposit[] public deposits; // array to store all deposits

    /* =============================================================
                            STEP 3
       Create constructor
       It should set owner = msg.sender
    ============================================================= */

    // TODO: Implement constructor
    constructor() {
        owner = msg.sender;
    }


    /* =============================================================
                            STEP 4
       Create deposit() function
       It should:
       - Be payable
       - Increase user balance
       - Increase totalBalance
       - Save deposit in array
    ============================================================= */

    // TODO: Implement deposit()
    function deposit() external payable {
        // Increase user balance
        balances[msg.sender] += msg.value;
        
        // Increase totalBalance
        totalBalance += msg.value;
        
        // Save deposit in array
        deposits.push(Deposit({
            user: msg.sender,
            amount: msg.value,
            time: block.timestamp
        }));
    }

    /* =============================================================
                            STEP 5
       Create withdraw() function
       It should:
       - Allow only owner
       - Accept amount
       - Require enough balance
       - Transfer ETH to owner
    ============================================================= */

    // TODO: Implement withdraw()
    function withdraw(uint256 amount) external {
        // Allow only owner
        require(msg.sender == owner, "Only owner can withdraw");
        
        // Require enough balance
        require(amount <= totalBalance, "Not enough balance in wallet");
        
        // Transfer ETH to owner
        payable(owner).transfer(amount);
        
        // Decrease totalBalance
        totalBalance -= amount;
    }

}


