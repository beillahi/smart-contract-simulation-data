pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Auction-impl.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Auction-spec.bodiless.sol";

/**
 * @notice invariant SimpleAuction_impl.beneficiary == SimpleAuction_spec.beneficiary
 * @notice invariant __verifier_eq(SimpleAuction_impl.pendingReturns, SimpleAuction_spec.pendingReturns)
 * @notice invariant SimpleAuction_impl.highestBidder == SimpleAuction_spec.highestBidder
 * @notice invariant SimpleAuction_impl.highestBid == SimpleAuction_spec.highestBid
 * @notice invariant SimpleAuction_impl.ended == SimpleAuction_spec.ended
 * @notice invariant SimpleAuction_spec._auctionEnd == SimpleAuction_impl.auctionStart + SimpleAuction_impl.biddingTime
 */

contract SimulationCheck is SimpleAuction_impl, SimpleAuction_spec {

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_Beneficiary() public view returns (address impl_ret_0, address spec_ret_0) {
        impl_ret_0 = SimpleAuction_impl.Beneficiary();
        spec_ret_0 = SimpleAuction_spec.spec_Beneficiary();
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_PendingReturns() public view returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = SimpleAuction_impl.PendingReturns();
        spec_ret_0 = SimpleAuction_spec.spec_PendingReturns();
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_HighestBidder() public view returns (address impl_ret_0, address spec_ret_0) {
        impl_ret_0 = SimpleAuction_impl.HighestBidder();
        spec_ret_0 = SimpleAuction_spec.spec_HighestBidder();
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_HighestBid() public view returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = SimpleAuction_impl.HighestBid();
        spec_ret_0 = SimpleAuction_spec.spec_HighestBid();
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_AuctionStatus() public view returns (bool impl_ret_0, bool spec_ret_0) {
        impl_ret_0 = SimpleAuction_impl.AuctionStatus();
        spec_ret_0 = SimpleAuction_spec.spec_AuctionStatus();
        return (impl_ret_0, spec_ret_0);
    }

    constructor(uint256 _biddingTime, address payable _beneficiary) public
        SimpleAuction_impl(_biddingTime, _beneficiary)
        SimpleAuction_spec(_biddingTime, _beneficiary)
    { }

    /**
     * @notice modifies SimpleAuction_impl.pendingReturns[__verifier_old_address(SimpleAuction_impl.highestBidder)]
     * @notice modifies address(this).balance
     * @notice modifies SimpleAuction_impl.highestBid
     * @notice modifies SimpleAuction_impl.highestBidder
     * @notice modifies SimpleAuction_spec.pendingReturns[__verifier_old_address(SimpleAuction_spec.highestBidder)]
     * @notice modifies address(this).balance
     * @notice modifies shadow$spec$Balance
     * @notice modifies SimpleAuction_spec.highestBid
     * @notice modifies SimpleAuction_spec.highestBidder
     * @notice precondition msg.value > SimpleAuction_spec.highestBid
     * @notice precondition (SimpleAuction_spec.highestBidder == address(0) && SimpleAuction_spec.highestBid == 0) || SimpleAuction_spec.highestBidder != address(0)
     */
    function check$spec_bid() public payable {
        SimpleAuction_impl.bid();
        SimpleAuction_spec.spec_bid();
    }

    /**
     * @notice modifies SimpleAuction_impl.pendingReturns[msg.sender]
     * @notice modifies address(this).balance
     * @notice modifies msg.sender.balance
     * @notice modifies $shadow$send$status
     * @notice modifies SimpleAuction_spec.pendingReturns[msg.sender]
     * @notice modifies address(this).balance
     * @notice modifies shadow$spec$Balance
     * @notice modifies msg.sender.balance
     * @notice modifies $shadow$send$status
     * @notice precondition SimpleAuction_spec.pendingReturns[msg.sender] > 0
     * @notice precondition address(this) != msg.sender
     * @notice precondition shadow$spec$Balance >= SimpleAuction_spec.pendingReturns[msg.sender]
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_withdraw() public returns (bool impl_ret_0, bool spec_ret_0) {
        impl_ret_0 = SimpleAuction_impl.withdraw();
        spec_ret_0 = SimpleAuction_spec.spec_withdraw();
        require (impl_ret_0 == spec_ret_0);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies SimpleAuction_impl.ended
     * @notice modifies address(this).balance
     * @notice modifies SimpleAuction_impl.beneficiary.balance
     * @notice modifies SimpleAuction_spec.ended
     * @notice modifies address(this).balance
     * @notice modifies shadow$spec$Balance
     * @notice modifies SimpleAuction_spec.beneficiary.balance
     * @notice precondition !SimpleAuction_spec.ended
     * @notice precondition shadow$spec$Balance >= SimpleAuction_spec.highestBid
     * @notice precondition address(this) != SimpleAuction_spec.beneficiary
     */
    function check$spec_auctionEnd() public {
        SimpleAuction_impl.auctionEnd();
        SimpleAuction_spec.spec_auctionEnd();
    }
}
