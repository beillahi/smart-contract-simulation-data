pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/ERC721.impl.check.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/ERC721.spec.bodiless.sol";

/**
 * @notice invariant __verifier_eq(ERC721_Impl._tokenOwner, ERC721_Spec._tokenOwner)
 * @notice invariant __verifier_eq(ERC721_Impl._tokenApprovals, ERC721_Spec._tokenApprovals)
 * @notice invariant __verifier_eq(ERC721_Impl._ownedTokensCount, ERC721_Spec._ownedTokensCount)
 * @notice invariant __verifier_eq(ERC721_Impl._operatorApprovals, ERC721_Spec._operatorApprovals)
 */

contract SimulationCheck is ERC721_Impl, ERC721_Spec {

    /**
     * @notice precondition owner != address(0)
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_balanceOf(address owner) public view returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = ERC721_Impl.balanceOf(owner);
        spec_ret_0 = ERC721_Spec.spec_balanceOf(owner);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_ownerOf(uint256 tokenId) public view returns (address impl_ret_0, address spec_ret_0) {
        impl_ret_0 = ERC721_Impl.ownerOf(tokenId);
        spec_ret_0 = ERC721_Spec.spec_ownerOf(tokenId);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies ERC721_Impl._tokenApprovals[tokenId]
     * @notice modifies ERC721_Spec._tokenApprovals[tokenId]
     * @notice precondition to != address(0)
     * @notice precondition msg.sender == ERC721_Spec._tokenOwner[tokenId]
     */
    function check$spec_approve(address to, uint256 tokenId) public {
        ERC721_Impl.approve(to, tokenId);
        ERC721_Spec.spec_approve(to, tokenId);
    }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_getApproved(uint256 tokenId) public view returns (address impl_ret_0, address spec_ret_0) {
        impl_ret_0 = ERC721_Impl.getApproved(tokenId);
        spec_ret_0 = ERC721_Spec.spec_getApproved(tokenId);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies ERC721_Impl._operatorApprovals[msg.sender][to]
     * @notice modifies ERC721_Spec._operatorApprovals[msg.sender][to]
     * @notice precondition to != address(0)
     */
    function check$spec_setApprovalForAll(address to, bool approved) public {
        ERC721_Impl.setApprovalForAll(to, approved);
        ERC721_Spec.spec_setApprovalForAll(to, approved);
    }

    /**
     * @notice precondition owner != address(0)
     * @notice precondition operator != address(0)
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_isApprovedForAll(address owner, address operator) public view returns (bool impl_ret_0, bool spec_ret_0) {
        impl_ret_0 = ERC721_Impl.isApprovedForAll(owner, operator);
        spec_ret_0 = ERC721_Spec.spec_isApprovedForAll(owner, operator);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies ERC721_Impl._tokenApprovals[tokenId]
     * @notice modifies ERC721_Impl._ownedTokensCount[from]
     * @notice modifies ERC721_Impl._ownedTokensCount[to]
     * @notice modifies ERC721_Impl._tokenOwner[tokenId]
     * @notice modifies ERC721_Spec._ownedTokensCount[from]
     * @notice modifies ERC721_Spec._ownedTokensCount[to]
     * @notice modifies ERC721_Spec._tokenOwner[tokenId]
     * @notice modifies ERC721_Spec._tokenApprovals[tokenId]
     * @notice precondition from == ERC721_Spec._tokenOwner[tokenId]
     * @notice precondition to != address(0)
     * @notice precondition ERC721_Spec._ownedTokensCount[from] >= 1
     */
    function check$spec_transferFrom(address from, address to, uint256 tokenId) public {
        ERC721_Impl.transferFrom(from, to, tokenId);
        ERC721_Spec.spec_transferFrom(from, to, tokenId);
    }
}
