pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/ERC20.impl.constructor.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/ERC20.spec.constructor.bodiless.sol";

/**
 * @notice invariant __verifier_eq(Token._balances, ERC20.balances)
 * @notice invariant __verifier_eq(Token._allowed, ERC20.allowances)
 */

contract SimulationCheck is Token, ERC20 {

    constructor(uint256 supply) public
        Token(supply)
        ERC20(supply)
    { }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_balance(address account) public view returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = Token.balance(account);
        spec_ret_0 = ERC20.spec_balance(account);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_allowance(address owner, address beneficiary) public view returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = Token.allowance(owner, beneficiary);
        spec_ret_0 = ERC20.spec_allowance(owner, beneficiary);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies Token._balances[msg.sender]
     * @notice modifies Token._balances[to]
     * @notice modifies ERC20.balances[msg.sender]
     * @notice modifies ERC20.balances[to]
     * @notice precondition to != address(0)
     * @notice precondition to != msg.sender
     * @notice precondition ERC20.balances[to] + val >= ERC20.balances[to]
     * @notice precondition ERC20.balances[msg.sender] - val >= 0
     */
    function check$spec_transfer(address to, uint256 val) public {
        Token.transfer(to, val);
        ERC20.spec_transfer(to, val);
    }

    /**
     * @notice modifies Token._allowed[msg.sender]
     * @notice modifies ERC20.allowances[msg.sender][to] 
     * @notice precondition to != address(0)
     */
    function check$spec_approve(address to, uint256 val) public {
        Token.approve(to, val);
        ERC20.spec_approve(to, val);
    }

    /**
     * @notice modifies Token._balances[to]
     * @notice modifies Token._balances[from]
     * @notice modifies Token._allowed[from]
     * @notice modifies ERC20.balances[to]
     * @notice modifies ERC20.balances[from]
     * @notice modifies ERC20.allowances[from][msg.sender] 
     * @notice precondition to != address(0)
     * @notice precondition to != from
     * @notice precondition ERC20.allowances[from][msg.sender] - val >= 0
     * @notice precondition ERC20.balances[to] + val >= ERC20.balances[to]
     * @notice precondition ERC20.balances[from] - val >= 0
     */
    function check$spec_transferFrom(address from, address to, uint256 val) public {
        Token.transferFrom(from, to, val);
        ERC20.spec_transferFrom(from, to, val);
    }

    /**
     * @notice modifies Token._allowed[msg.sender]
     * @notice modifies ERC20.allowances[msg.sender][spender] 
     * @notice precondition spender != address(0)
     * @notice precondition ERC20.allowances[msg.sender][spender] + val >= ERC20.allowances[msg.sender][spender]
     */
    function check$spec_increaseAllowance(address spender, uint256 val) public {
        Token.increaseAllowance(spender, val);
        ERC20.spec_increaseAllowance(spender, val);
    }

    /**
     * @notice modifies Token._allowed[msg.sender]
     * @notice modifies ERC20.allowances[msg.sender][spender] 
     * @notice precondition spender != address(0)
     * @notice precondition ERC20.allowances[msg.sender][spender] - val >= 0
     */
    function check$spec_decreaseAllowance(address spender, uint256 val) public {
        Token.decreaseAllowance(spender, val);
        ERC20.spec_decreaseAllowance(spender, val);
    }
}
