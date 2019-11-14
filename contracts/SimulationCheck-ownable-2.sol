pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/ownable.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Ownable.spec.bodiless.sol";

/**
 * @notice invariant __verifier_eq(Ownable_impl.owner, Ownable._owner)
 */

contract SimulationCheck is Ownable_impl, Ownable {

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_getOwner() public view returns (address impl_ret_0, address spec_ret_0) {
        impl_ret_0 = Ownable_impl.getOwner();
        spec_ret_0 = Ownable.spec_getOwner();
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies Ownable_impl.owner
     * @notice modifies Ownable._owner
     * @notice precondition newOwner != address(0)
     * @notice precondition Ownable._owner == msg.sender
     */
    function check$spec_transferOwnership(address newOwner) public {
        Ownable_impl.transferOwnership(newOwner);
        Ownable.spec_transferOwnership(newOwner);
    }
}
