pragma solidity ^0.5.0;

contract SimpleAuction_spec {
    // Parameters of the auction. Times are either
    // absolute unix timestamps (seconds since 1970-01-01)
    // or time periods in seconds.
    address payable public beneficiary;
    uint public _auctionEnd;

    // Current state of the auction.
    address public highestBidder;
    uint public highestBid;

    // Allowed withdrawals of previous bids
    mapping(address => uint) pendingReturns;

    // Set to true at the end, disallows any change
    bool ended;

    bool public shadowSendStatus;

    // Events that will be fired on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);




  /** @notice postcondition _beneficiary == beneficiary
  */
  function  Beneficiary() public view returns (address _beneficiary)
  {
      return  beneficiary;
  }


    /** @notice postcondition val == pendingReturns[msg.sender]
    */
    function PendingReturns() public view returns (uint val)
    {
        return pendingReturns[msg.sender];
    }


    /** @notice postcondition bidder == highestBidder
    */
    function HighestBidder() public view returns (address bidder)
    {
        return highestBidder;
    }


    /** @notice postcondition bid == highestBid
    */
    function HighestBid() public view returns (uint bid)
   {
        return highestBid;
    }

    /** @notice postcondition status == ended
    */
    function AuctionStatus() public view returns (bool status)
    {
        return ended;
    }

    // The following is a so-called natspec comment,
    // recognizable by the three slashes.
    // It will be shown when the user is asked to
    // confirm a transaction.

    /// Create a simple auction with `_biddingTime`
    /// seconds bidding time on behalf of the
    /// beneficiary address `_beneficiary`.

    /** @notice precondition _biddingTime > 0
        @notice precondition _beneficiary != address(0)
     	@notice postcondition _auctionEnd == now + _biddingTime
        @notice postcondition beneficiary == _beneficiary
        @notice modifies beneficiary
        @notice modifies _auctionEnd
    */
    constructor(uint _biddingTime, address payable _beneficiary) public {
        beneficiary = _beneficiary;
        _auctionEnd = now + _biddingTime;
    }

    /// Bid on the auction with the value sent
    /// together with this transaction.
    /// The value will only be refunded if the
    /// auction is not won.
    /** @notice precondition msg.value > highestBid
        @notice precondition (highestBidder == address(0) && highestBid == 0) || highestBidder != address(0)
     	@notice postcondition address(this).balance == __verifier_old_uint(address(this).balance) + msg.value
        @notice postcondition pendingReturns[__verifier_old_address(highestBidder)] == __verifier_old_uint(pendingReturns[__verifier_old_address(highestBidder)]) + __verifier_old_uint(highestBid)
	    @notice postcondition highestBidder == msg.sender
        @notice postcondition highestBid == msg.value
        @notice modifies pendingReturns[__verifier_old_address(highestBidder)]
        @notice modifies address(this).balance
        @notice modifies highestBid
        @notice modifies highestBidder
    */
    function bid() public payable {
        // No arguments are necessary, all
        // information is already part of
        // the transaction. The keyword payable
        // is required for the function to
        // be able to receive Ether.

        // Revert the call if the bidding
        // period is over.
        //require(
        //    now <= _auctionEnd,
        //    "Auction already ended."
        //);
        require(now <= _auctionEnd);

        // If the bid is not higher, send the
        // money back.
        //require(
        //    msg.value > highestBid,
        //    "There already is a higher bid."
        //);

        require(msg.value > highestBid);

        if (highestBid != 0) {
            // Sending back the money by simply using
            // highestBidder.send(highestBid) is a security risk
            // because it could execute an untrusted contract.
            // It is always safer to let the recipients
            // withdraw their money themselves.
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        emit HighestBidIncreased(msg.sender, msg.value);
    }

    /// Withdraw a bid that was overbid.
    // notice postcondition !status || address(this).balance == __verifier_old_uint(address(this).balance) - __verifier_old_uint(pendingReturns[msg.sender])
    /** @notice precondition  pendingReturns[msg.sender] > 0
        @notice precondition  address(this) != msg.sender
	    @notice precondition  address(this).balance >= pendingReturns[msg.sender]
        @notice postcondition status || address(this).balance == __verifier_old_uint(address(this).balance)
	    @notice postcondition status || pendingReturns[msg.sender] == __verifier_old_uint(pendingReturns[msg.sender])
        @notice postcondition !status || pendingReturns[msg.sender] == 0
        @notice postcondition !status || address(this).balance == __verifier_old_uint(address(this).balance) - __verifier_old_uint(pendingReturns[msg.sender])
        @notice modifies pendingReturns[msg.sender]
        @notice modifies address(this).balance
        @notice modifies msg.sender.balance
        @notice modifies shadowSendStatus
        @notice postcondition !shadowSendStatus || status
        @notice postcondition shadowSendStatus || !status
    */
    function withdraw() public returns (bool status) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // It is important to set this to zero because the recipient
            // can call this function again as part of the receiving call
            // before `send` returns.
            pendingReturns[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                // No need to call throw here, just reset the amount owing
                pendingReturns[msg.sender] = amount;
                shadowSendStatus = false;
                return false;
            }
        }
        shadowSendStatus = true;
        return true;
    }

    /// End the auction and send the highest bid
    // notice postcondition address(this).balance == __verifier_old_uint(address(this).balance) - highestBid
    /// to the beneficiary.
    /** @notice precondition !ended
	    @notice precondition  address(this).balance >= highestBid
        @notice precondition  address(this) != beneficiary
        @notice postcondition address(this).balance == __verifier_old_uint(address(this).balance) - highestBid
	    @notice postcondition ended
        @notice modifies ended
        @notice modifies address(this).balance
        @notice modifies beneficiary.balance
    */
    function auctionEnd() public {
        // It is a good guideline to structure functions that interact
        // with other contracts (i.e. they call functions or send Ether)
        // into three phases:
        // 1. checking conditions
        // 2. performing actions (potentially changing conditions)
        // 3. interacting with other contracts
        // If these phases are mixed up, the other contract could call
        // back into the current contract and modify the state or cause
        // effects (ether payout) to be performed multiple times.
        // If functions called internally include interaction with external
        // contracts, they also have to be considered interaction with
        // external contracts.

        // 1. Conditions
        require(now >= _auctionEnd);
        //require(now >= _auctionEnd, "Auction not yet ended.");
        require(!ended);
        //require(!ended, "auctionEnd has already been called.");

        // 2. Effects
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Interaction
        beneficiary.transfer(highestBid);
    }
}
