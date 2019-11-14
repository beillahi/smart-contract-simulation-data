pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/ERC20.impl.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/ERC20.spec.bodiless.sol";

/**
 * @notice invariant __verifier_eq(Token._balances, ERC20_spec.balances)
 * @notice invariant __verifier_eq(Token._allowed, ERC20_spec.allowances)
 */

contract SimulationCheck is Token, ERC20_spec {

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_balance(address account) public view returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = Token.balance(account);
        spec_ret_0 = ERC20_spec.spec_balance(account);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_allowance(address owner, address beneficiary) public view returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = Token.allowance(owner, beneficiary);
        spec_ret_0 = ERC20_spec.spec_allowance(owner, beneficiary);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies Token._balances[msg.sender]
     * @notice modifies Token._balances[to]
     * @notice modifies ERC20_spec.balances[msg.sender]
     * @notice modifies ERC20_spec.balances[to]
     * @notice precondition to != address(0)
     * @notice precondition to != msg.sender
     * @notice precondition ERC20_spec.balances[to] + val >= ERC20_spec.balances[to]
     * @notice precondition ERC20_spec.balances[msg.sender] - val >= 0
     */
    function check$spec_transfer(address to, uint256 val) public {
        Token.transfer(to, val);
        ERC20_spec.spec_transfer(to, val);
    }

    /**
     * @notice modifies Token._allowed[msg.sender]
     * @notice modifies ERC20_spec.allowances[msg.sender][to]
     * @notice precondition to != address(0)
     */
    function check$spec_approve(address to, uint256 val) public {
        Token.approve(to, val);
        ERC20_spec.spec_approve(to, val);
    }

    /**
     * @notice modifies Token._balances[to]
     * @notice modifies Token._balances[from]
     * @notice modifies Token._allowed[from]
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
        Token.transferFrom(from, to, val);
        ERC20_spec.spec_transferFrom(from, to, val);
    }

    /**
     * @notice modifies Token._allowed[msg.sender]
     * @notice modifies ERC20_spec.allowances[msg.sender][spender] 
     * @notice precondition spender != address(0)
     * @notice precondition ERC20_spec.allowances[msg.sender][spender] + val >= ERC20_spec.allowances[msg.sender][spender]
     */
    function check$spec_increaseAllowance(address spender, uint256 val) public {
        Token.increaseAllowance(spender, val);
        ERC20_spec.spec_increaseAllowance(spender, val);
    }

    /**
     * @notice modifies Token._allowed[msg.sender]
     * @notice modifies ERC20_spec.allowances[msg.sender][spender] 
     * @notice precondition spender != address(0)
     * @notice precondition ERC20_spec.allowances[msg.sender][spender] - val >= 0
     */
    function check$spec_decreaseAllowance(address spender, uint256 val) public {
        Token.decreaseAllowance(spender, val);
        ERC20_spec.spec_decreaseAllowance(spender, val);
    }

    /**
     * @notice modifies Token._balances[to]
     * @notice modifies Token._totalSupply
     * @notice modifies ERC20_spec.balances[to] 
     * @notice precondition to != address(0)
     * @notice precondition ERC20_spec.minters[msg.sender]
     * @notice precondition ERC20_spec.balances[to] + val >= ERC20_spec.balances[to]
     */
    function check$spec_mint(address to, uint256 val) public {
        Token.mint(to, val);
        ERC20_spec.spec_mint(to, val);
    }

    /**
     * @notice modifies Token._balances[from]
     * @notice modifies Token._totalSupply
     * @notice modifies ERC20_spec.balances[from] 
     * @notice precondition from != address(0)
     * @notice precondition ERC20_spec.burners[msg.sender]
     * @notice precondition ERC20_spec.balances[from] - val >= 0
     */
    function check$spec_burn(address from, uint256 val) public {
        Token.burn(from, val);
        ERC20_spec.spec_burn(from, val);
    }
}
