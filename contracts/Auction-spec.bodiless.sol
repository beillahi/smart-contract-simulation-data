pragma solidity ^0.5.0;

contract SimpleAuction_spec {
   uint public shadow$spec$Balance; 
   modifier shadow$spec$Balance$Modifier {
            shadow$spec$Balance = address(this).balance - msg.value;
            _;
            shadow$spec$Balance = address(this).balance;
        } 
   modifier shadow$spec$Balance$Modifier1 {
            shadow$spec$Balance = address(this).balance;
            _;
            shadow$spec$Balance = address(this).balance;
        }
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

    bool public $shadow$send$status;

    // Events that will be fired on changes.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);




  /** @notice postcondition _beneficiary == beneficiary
  */
  function   spec_Beneficiary( ) public view returns (address _beneficiary)
  ;


    /** @notice postcondition val == pendingReturns[msg.sender]
    */
    function  spec_PendingReturns( ) public view returns (uint val)
    ;


    /** @notice postcondition bidder == highestBidder
    */
    function  spec_HighestBidder( ) public view returns (address bidder)
    ;


    /** @notice postcondition bid == highestBid
    */
    function  spec_HighestBid( ) public view returns (uint bid)
   ;

    /** @notice postcondition status == ended
    */
    function  spec_AuctionStatus( ) public view returns (bool status)
    ;

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
    constructor(
        uint _biddingTime,
        address payable _beneficiary
    ) public {
        beneficiary = _beneficiary;
        _auctionEnd = now + _biddingTime;
    }

    /// Bid on the auction with the value sent
    /// together with this transaction.
    /// The value will only be refunded if the
    /// auction is not won.
    /** @notice precondition msg.value > highestBid
        @notice precondition (highestBidder == address(0) && highestBid == 0) || highestBidder != address(0)
     	@notice postcondition shadow$spec$Balance == __verifier_old_uint(shadow$spec$Balance) + msg.value
        @notice postcondition pendingReturns[__verifier_old_address(highestBidder)] == __verifier_old_uint(pendingReturns[__verifier_old_address(highestBidder)]) + __verifier_old_uint(highestBid)
	    @notice postcondition highestBidder == msg.sender
        @notice postcondition highestBid == msg.value
        @notice modifies pendingReturns[__verifier_old_address(highestBidder)]
        @notice modifies address(this).balance
        @notice modifies shadow$spec$Balance

        @notice modifies highestBid
        @notice modifies highestBidder
    */
    function  spec_bid( ) public payable ;

    /// Withdraw a bid that was overbid.
    // notice postcondition !status || address(this).balance == __verifier_old_uint(address(this).balance) - __verifier_old_uint(pendingReturns[msg.sender])
    /** @notice precondition  pendingReturns[msg.sender] > 0
        @notice precondition  address(this) != msg.sender
	    @notice precondition  shadow$spec$Balance >= pendingReturns[msg.sender]
        @notice postcondition status || shadow$spec$Balance == __verifier_old_uint(shadow$spec$Balance)
	    @notice postcondition status || pendingReturns[msg.sender] == __verifier_old_uint(pendingReturns[msg.sender])
        @notice postcondition !status || pendingReturns[msg.sender] == 0
        @notice postcondition !status || shadow$spec$Balance == __verifier_old_uint(shadow$spec$Balance) - __verifier_old_uint(pendingReturns[msg.sender])
        @notice modifies pendingReturns[msg.sender]
        @notice modifies address(this).balance
        @notice modifies shadow$spec$Balance

        @notice modifies msg.sender.balance
        @notice modifies $shadow$send$status
        @notice postcondition !$shadow$send$status || status
        @notice postcondition $shadow$send$status || !status
    */
    function  spec_withdraw( ) public returns (bool status) ;

    /// End the auction and send the highest bid
    // notice postcondition address(this).balance == __verifier_old_uint(address(this).balance) - highestBid
    /// to the beneficiary.
    /** @notice precondition !ended
	    @notice precondition  shadow$spec$Balance >= highestBid
        @notice precondition  address(this) != beneficiary
        @notice postcondition shadow$spec$Balance == __verifier_old_uint(shadow$spec$Balance) - highestBid
	    @notice postcondition ended
        @notice modifies ended
        @notice modifies address(this).balance
        @notice modifies shadow$spec$Balance

        @notice modifies beneficiary.balance
    */
    function  spec_auctionEnd( ) public ;
}
