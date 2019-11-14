pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/StandardToken.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/ERC20.spec.bodiless.sol";

/**
 * @notice invariant __verifier_eq(StandardToken.balances, ERC20_spec.balances)
 * @notice invariant __verifier_eq(StandardToken.allowed, ERC20_spec.allowances)
 */

contract SimulationCheck is StandardToken, ERC20_spec {

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_balance(address account) public view returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = StandardToken.balance(account);
        spec_ret_0 = ERC20_spec.spec_balance(account);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_allowance(address owner, address beneficiary) public view returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = StandardToken.allowance(owner, beneficiary);
        spec_ret_0 = ERC20_spec.spec_allowance(owner, beneficiary);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies StandardToken.balances[msg.sender]
     * @notice modifies StandardToken.balances[to]
     * @notice modifies ERC20_spec.balances[msg.sender]
     * @notice modifies ERC20_spec.balances[to]
     * @notice precondition to != address(0)
     * @notice precondition to != msg.sender
     * @notice precondition ERC20_spec.balances[to] + val >= ERC20_spec.balances[to]
     * @notice precondition ERC20_spec.balances[msg.sender] - val >= 0
     */
    function check$spec_transfer(address to, uint256 val) public {
        StandardToken.transfer(to, val);
        ERC20_spec.spec_transfer(to, val);
    }

    /**
     * @notice modifies StandardToken.allowed[msg.sender]
     * @notice modifies ERC20_spec.allowances[msg.sender][to]
     * @notice precondition to != address(0)
     */
    function check$spec_approve(address to, uint256 val) public {
        StandardToken.approve(to, val);
        ERC20_spec.spec_approve(to, val);
    }

    /**
     * @notice modifies StandardToken.balances[from]
     * @notice modifies StandardToken.balances[to]
     * @notice modifies StandardToken.allowed[from][msg.sender]
     * @notice modifies ERC20_spec.balances[to]
     * @notice modifies ERC20_spec.balances[from]
     * @notice modifies ERC20_spec.allowances[from][msg.sender] 
     * @notice precondition to != address(0)
     * @notice precondition to != from
     * @notice precondition ERC20_spec.allowances[from][msg.sender] - val >= 0
     * @notice precondition ERC20_spec.balances[to] + val >= ERC20_spec.balances[to]
     * @notice precondition ERC20_spec.balances[from] - val >= 0
     */
    function check$spec_transferFrom(address from, address to, uint256 val) public {
        StandardToken.transferFrom(from, to, val);
        ERC20_spec.spec_transferFrom(from, to, val);
    }
}
