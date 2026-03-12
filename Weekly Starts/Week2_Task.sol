// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {

    /* =============================================================
                            STEP 1
       Create an Auction struct.
       It must store:
       - seller (address)
       - highestBidder (address)
       - highestBid (uint256)
       - endTime (uint256)
       - ended (bool)

       
    ============================================================= */

    // TODO: Define struct here
    struct Auction {
        address seller;
        address highestBidder;
        uint256 highestBid;
        uint256 endTime;
        bool ended;
    }


    /* =============================================================
                            STEP 2
       Create state variables:
       - auctionCount
       - mapping from auctionId to Auction
       - mapping to store refundable bids
    ============================================================= */

    // TODO: Declare auctionCount
    uint256 public auctionCount;
    
    // TODO: Declare auctions mapping
    mapping(uint256 => Auction) public auctions; // auctionId to Auction struct
    
    // TODO: Declare pendingReturns mapping
    mapping(address => uint256) public pendingReturns; // pending mean funds that can be withdrawn by users who have been outbid
//outbid mean that a user has been outbid by another user, so they can withdraw their previous bid amount from the contract using the pendingReturns mapping.

    /* =============================================================
                            STEP 3
       Create createAuction() function.
       It should:
       - Accept duration
       - Increment auctionCount
       - Create new Auction
       - Set seller to msg.sender
       - Set highestBid to 0
       - Set endTime = block.timestamp + duration
    ============================================================= */

    // TODO: Implement createAuction()
    function createAuction(uint256 duration) external {
        auctionCount++;
        auctions[auctionCount] = Auction({
            seller: msg.sender,
            highestBidder: address(0),
            highestBid: 0,
            endTime: block.timestamp + duration,
            ended: false
        });
    }


    /* =============================================================
                            STEP 4
       Create bid() function.
       It should:
       - Be payable
       - Require auction not ended
       - Require msg.value > highestBid
       - Refund previous highest bidder
       - Update highestBidder and highestBid
    ============================================================= */
    // TODO: Implement bid()
    function bid(uint256 auctionId) external payable {
        Auction storage auction = auctions[auctionId];
        require(block.timestamp < auction.endTime, "Auction already ended");
        require(msg.value > auction.highestBid, "There already is a higher bid");

        if (auction.highestBid != 0) {
            // Refund the previous highest bidder
            pendingReturns[auction.highestBidder] += auction.highestBid;
        }

        // Update highestBidder and highestBid
        auction.highestBidder = msg.sender;
        auction.highestBid = msg.value;
    }
    /* =============================================================
                            STEP 5
       Create withdraw() function.
       Users can withdraw their outbid funds.
    ============================================================= */

    // TODO: Implement withdraw()
    function withdraw () external {
        uint256 amount = pendingReturns[msg.sender];
        require(amount > 0, "No funds to withdraw");

        // Set pendingReturns to 0 before transfer to prevent re-entrancy attacks
        pendingReturns[msg.sender] = 0;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");
    }

    /* =============================================================
                            STEP 6
       Create endAuction() function.
       It should:
       - Require auction ended
       - Require not already ended
       - Mark ended = true
       - Transfer highest bid to seller
    ============================================================= */

    // TODO: Implement endAuction()
    function endAuction(uint256 auctionId) external {
        Auction storage auction = auctions[auctionId];
        require(block.timestamp >= auction.endTime, "Auction not yet ended");
        require(!auction.ended, "Auction already ended");

        // Mark the auction as ended
        auction.ended = true;

        // Transfer the highest bid to the seller
        (bool success, ) = auction.seller.call{value: auction.highestBid}("");
        require(success, "Transfer to seller failed");
    }

}



