pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Escrow.impl.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Escrow.spec.no-owner.bodiless.sol";

/**
 * @notice invariant __verifier_eq(Escrow_Stacktical.deposits, Escrow_spec.deposits)
 */

contract SimulationCheck is Escrow_Stacktical, Escrow_spec {

    /**
     * @notice modifies Escrow_Stacktical.deposits[payee]
     * @notice modifies address(this).balance
     * @notice modifies Escrow_spec.deposits[payee]
     * @notice modifies address(this).balance
     * @notice modifies shadow$spec$Balance
     * @notice precondition payee != address(0)
     * @notice precondition msg.value > 0
     * @notice precondition address(this) != msg.sender
     * @notice precondition payee != address(this)
     * @notice precondition Escrow_spec.deposits[payee] + msg.value >= Escrow_spec.deposits[payee]
     * @notice precondition shadow$spec$Balance + msg.value >= shadow$spec$Balance
     */
    function check$spec_deposit(address payee) public payable {
        Escrow_Stacktical.deposit(payee);
        Escrow_spec.spec_deposit(payee);
    }

    /**
     * @notice modifies Escrow_Stacktical.deposits[payee]
     * @notice modifies address(this).balance
     * @notice modifies payee.balance
     * @notice modifies Escrow_spec.deposits[payee]
     * @notice modifies address(this).balance
     * @notice modifies shadow$spec$Balance
     * @notice modifies payee.balance
     * @notice precondition payee != address(0)
     * @notice precondition Escrow_spec.deposits[payee] > 0
     * @notice precondition payee != address(this)
     */
    function check$spec_withdraw(address payable payee) public {
        Escrow_Stacktical.withdraw(payee);
        Escrow_spec.spec_withdraw(payee);
    }

    /**
     * @notice precondition payee != address(0)
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_depositsOf(address payee) public view returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = Escrow_Stacktical.depositsOf(payee);
        spec_ret_0 = Escrow_spec.spec_depositsOf(payee);
        return (impl_ret_0, spec_ret_0);
    }
}
