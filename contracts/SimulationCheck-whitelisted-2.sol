pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Whitelisted.impl.simulate.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Whitelisted.spec.bodiless.sol";

/**
 * @notice invariant __verifier_eq(Whitelist.whitelist, WhitelistedRole._whitelisteds)
 * @notice invariant Whitelist.owner == WhitelistedRole.owner
 */

contract SimulationCheck is Whitelist, WhitelistedRole {

    constructor() public
        Whitelist()
        WhitelistedRole()
    { }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_isWhitelisted(address account) public view returns (bool impl_ret_0, bool spec_ret_0) {
        impl_ret_0 = Whitelist.isWhitelisted(account);
        spec_ret_0 = WhitelistedRole.spec_isWhitelisted(account);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies Whitelist.length
     * @notice modifies Whitelist.whitelist[account]
     * @notice modifies WhitelistedRole._whitelisteds[account]
     * @notice precondition account != address(0)
     * @notice precondition msg.sender == WhitelistedRole.owner
     * @notice precondition WhitelistedRole._whitelisteds[account] == false
     */
    function check$spec_addWhitelisted(address account) public {
        Whitelist.addWhitelisted(account);
        WhitelistedRole.spec_addWhitelisted(account);
    }

    /**
     * @notice modifies Whitelist.length
     * @notice modifies Whitelist.whitelist[account]
     * @notice modifies WhitelistedRole._whitelisteds[account]
     * @notice precondition account != address(0)
     * @notice precondition msg.sender == WhitelistedRole.owner
     * @notice precondition WhitelistedRole._whitelisteds[account] == true
     */
    function check$spec_removeWhitelisted(address account) public {
        Whitelist.removeWhitelisted(account);
        WhitelistedRole.spec_removeWhitelisted(account);
    }
}
