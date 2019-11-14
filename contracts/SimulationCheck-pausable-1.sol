pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Pausable.impl.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Pausable.spec.bodiless.sol";

/**
 * @notice invariant Pausable_impl.paused == Pausable_spec.paused
 * @notice invariant Pausable_impl.owner == Pausable_spec._owner
 */

contract SimulationCheck is Pausable_impl, Pausable_spec {

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_getStatus() public view returns (bool impl_ret_0, bool spec_ret_0) {
        impl_ret_0 = Pausable_impl.getStatus();
        spec_ret_0 = Pausable_spec.spec_getStatus();
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies Pausable_impl.paused
     * @notice modifies Pausable_spec.paused
     * @notice precondition !Pausable_spec.paused
     */
    function check$spec_pause() public {
        Pausable_impl.pause();
        Pausable_spec.spec_pause();
    }

    /**
     * @notice modifies Pausable_impl.paused
     * @notice modifies Pausable_spec.paused
     * @notice precondition Pausable_spec.paused
     */
    function check$spec_unpause() public {
        Pausable_impl.unpause();
        Pausable_spec.spec_unpause();
    }
}
