pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/ERC165.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/ERC165.spec.bodiless.sol";

/**
 * @notice invariant __verifier_eq(ERC165._supportedInterfaces, ERC165_Spec._supportedInterfaces)
 */

contract SimulationCheck is ERC165, ERC165_Spec {

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_supportsInterface(bytes4 interfaceId) public view returns (bool impl_ret_0, bool spec_ret_0) {
        impl_ret_0 = ERC165.supportsInterface(interfaceId);
        spec_ret_0 = ERC165_Spec.spec_supportsInterface(interfaceId);
        return (impl_ret_0, spec_ret_0);
    }
}
