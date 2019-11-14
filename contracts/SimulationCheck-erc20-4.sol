pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/AMNToken.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/ERC20.spec.bodiless.sol";

/**
 * @notice invariant (__verifier_eq(AMNToken.balances, ERC20_spec.balances) || (AMNToken.balances[AMNToken.owner] == ERC20_spec.balances[AMNToken.owner] + AMNToken.INITIAL_SUPPLY))
 * @notice invariant __verifier_eq(AMNToken.allowances, ERC20_spec.allowances)
 */

contract SimulationCheck is AMNToken, ERC20_spec {

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_balance(address account) public view returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = AMNToken.balance(account);
        spec_ret_0 = ERC20_spec.spec_balance(account);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_allowance(address owner, address beneficiary) public view returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = AMNToken.allowance(owner, beneficiary);
        spec_ret_0 = ERC20_spec.spec_allowance(owner, beneficiary);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies AMNToken.balances[msg.sender]
     * @notice modifies AMNToken.balances[to]
     * @notice modifies ERC20_spec.balances[msg.sender]
     * @notice modifies ERC20_spec.balances[to]
     * @notice precondition to != address(0)
     * @notice precondition to != msg.sender
     * @notice precondition ERC20_spec.balances[to] + val >= ERC20_spec.balances[to]
     * @notice precondition ERC20_spec.balances[msg.sender] - val >= 0
     */
    function check$spec_transfer(address to, uint256 val) public {
        AMNToken.transfer(to, val);
        ERC20_spec.spec_transfer(to, val);
    }

    /**
     * @notice modifies AMNToken.allowances[msg.sender][to]
     * @notice modifies ERC20_spec.allowances[msg.sender][to]
     * @notice precondition to != address(0)
     */
    function check$spec_approve(address to, uint256 val) public {
        AMNToken.approve(to, val);
        ERC20_spec.spec_approve(to, val);
    }

    /**
     * @notice modifies AMNToken.balances[from]
     * @notice modifies AMNToken.balances[to]
     * @notice modifies AMNToken.allowances[from][msg.sender]
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
        AMNToken.transferFrom(from, to, val);
        ERC20_spec.spec_transferFrom(from, to, val);
    }

    /**
     * @notice modifies AMNToken.allowances[msg.sender][spender]
     * @notice modifies ERC20_spec.allowances[msg.sender][spender] 
     * @notice precondition spender != address(0)
     * @notice precondition ERC20_spec.allowances[msg.sender][spender] + val >= ERC20_spec.allowances[msg.sender][spender]
     */
    function check$spec_increaseAllowance(address spender, uint256 val) public {
        AMNToken.increaseAllowance(spender, val);
        ERC20_spec.spec_increaseAllowance(spender, val);
    }

    /**
     * @notice modifies AMNToken.allowances[msg.sender][spender]
     * @notice modifies ERC20_spec.allowances[msg.sender][spender] 
     * @notice precondition spender != address(0)
     * @notice precondition ERC20_spec.allowances[msg.sender][spender] - val >= 0
     */
    function check$spec_decreaseAllowance(address spender, uint256 val) public {
        AMNToken.decreaseAllowance(spender, val);
        ERC20_spec.spec_decreaseAllowance(spender, val);
    }
}
