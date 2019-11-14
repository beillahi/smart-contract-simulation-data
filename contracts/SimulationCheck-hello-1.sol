pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/HelloWorld.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/HelloAfrica.bodiless.sol";

/**
 * @notice invariant HelloWorld.total == HelloAfrica.counter
 * @notice invariant HelloWorld.counter == HelloAfrica.counter
 */

contract SimulationCheck is HelloWorld, HelloAfrica {

    /**
     * @notice modifies HelloWorld.total
     * @notice modifies HelloWorld.counter
     * @notice modifies HelloAfrica.counter
     */
    function check$spec_inc(int256 i) public {
        HelloWorld.inc(i);
        HelloAfrica.spec_inc(i);
    }

    /**
     * @notice modifies HelloWorld.total
     * @notice modifies HelloWorld.counter
     * @notice modifies HelloAfrica.counter
     */
    function check$spec_dec() public {
        HelloWorld.dec();
        HelloAfrica.spec_dec();
    }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_get() public view returns (int256 impl_ret_0, int256 spec_ret_0) {
        impl_ret_0 = HelloWorld.get();
        spec_ret_0 = HelloAfrica.spec_get();
        return (impl_ret_0, spec_ret_0);
    }
}
