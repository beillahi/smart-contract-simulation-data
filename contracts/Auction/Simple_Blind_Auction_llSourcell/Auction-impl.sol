pragma solidity ^0.5.0;

// Source link: https://github.com/stormeth/simpleauction/blob/master/contracts/SimpleAuction.sol
// Sourc link: https://github.com/llSourcell/simple_auction

/**

  @notice simulation  SimpleAuction_impl$beneficiary == SimpleAuction_spec$beneficiary
  @notice simulation __verifier_eq(SimpleAuction_impl$pendingReturns, SimpleAuction_spec$pendingReturns)
  @notice simulation  SimpleAuction_impl$highestBidder == SimpleAuction_spec$highestBidder
  @notice simulation  SimpleAuction_impl$highestBid == SimpleAuction_spec$highestBid
  @notice simulation  SimpleAuction_impl$ended == SimpleAuction_spec$ended
  @notice simulation  SimpleAuction_spec$_auctionEnd == SimpleAuction_impl$auctionStart + SimpleAuction_impl$biddingTime
 */
contract SimpleAuction_impl {
  // Parameters of the auction. Times are either
  // absolute unix timestamps (seconds since 1970-01-01)
  // or time periods in seconds.
  address payable public beneficiary;
  uint public auctionStart;
  uint public biddingTime;

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




  function  Beneficiary() public view returns (address)
  {
      return  beneficiary;
  }

  function PendingReturns() public view returns (uint)
  {
        return pendingReturns[msg.sender];
  }

  function HighestBidder() public view returns (address)
  {
    return highestBidder;
  }


  function HighestBid() public view returns (uint)
  {
    return highestBid;
  }


  function AuctionStatus() public view returns (bool)
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
  
  /**
      @notice modifies beneficiary
      @notice modifies auctionStart
      @notice modifies biddingTime
  */
  constructor(
      uint _biddingTime,
      address payable _beneficiary
  ) public {
    beneficiary = _beneficiary;
    auctionStart = now;
    biddingTime = _biddingTime;
  }

  /// Bid on the auction with the value sent
  /// together with this transaction.
  /// The value will only be refunded if the
  /// auction is not won.
  /**
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
    if (now > auctionStart + biddingTime) {
      // Revert the call if the bidding
      // period is over.
      revert();
    }
    if (msg.value <= highestBid) {
      // If the bid is not higher, send the
      // money back.
      revert();
    }
    if (highestBidder != address(0)) {
      // Sending back the money by simply using
      // highestBidder.send(highestBid) is a security risk
      // because it can be prevented by the caller by e.g.
      // raising the call stack to 1023. It is always safer
      // to let the recipient withdraw their money themselves.
      pendingReturns[highestBidder] += highestBid;
    }
    highestBidder = msg.sender;
    highestBid = msg.value;
    emit HighestBidIncreased(msg.sender, msg.value);
  }

  /// Withdraw a bid that was overbid.
  /**
      @notice modifies pendingReturns[msg.sender]
      @notice modifies address(this).balance
      @notice modifies msg.sender.balance
      @notice modifies shadowSendStatus
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
  /// to the beneficiary.
  /**
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
    // effects (ether payout) to be perfromed multiple times.
    // If functions called internally include interaction with external
    // contracts, they also have to be considered interaction with
    // external contracts.

    // 1. Conditions
    if (now < auctionStart + biddingTime)
      revert(); // auction did not yet end
    if (ended)
      revert(); // this function has already been called

    // 2. Effects
    ended = true;
    emit AuctionEnded(highestBidder, highestBid);

    // 3. Interaction
    if (!beneficiary.send(highestBid))
      revert();
  }
}