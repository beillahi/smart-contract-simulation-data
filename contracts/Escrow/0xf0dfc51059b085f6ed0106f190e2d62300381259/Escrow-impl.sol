/**
 *Submitted for verification at Etherscan.io on 2019-02-15
*/

pragma solidity ^0.5.0;

import './original/SafeMath.sol';

/**
 * @title Escrow
 * @dev Base escrow contract, holds funds designated for a payee until they
 * withdraw them.
 * @dev Intended usage: This contract (and derived escrow contracts) should be a
 * standalone contract, that only interacts with the contract that instantiated
 * it. That way, it is guaranteed that all Ether will be handled according to
 * the Escrow rules, and there is no need to check for payable functions or
 * transfers in the inheritance tree. The contract that uses the escrow as its
 * payment method should be its primary, and provide public methods redirecting
 * to the escrow's deposit and withdraw.
 * @notice simulation __verifier_eq(Escrow$_deposits, Escrow_spec$deposits) &&  Escrow$_primary == Escrow_spec$_primary
 */
contract Escrow {
    using SafeMath_spec for uint256;

    event Deposited(address indexed payee, uint256 weiAmount);
    event Withdrawn(address indexed payee, uint256 weiAmount);

    mapping(address => uint256) private _deposits;

    function depositsOf(address payee) public view returns (uint256) {
        return _deposits[payee];
    }


    address private _primary;

	/**
     * @dev Reverts if called from any account other than the primary.
     */
    modifier onlyPrimary() {
        require(msg.sender == _primary);
        _;
    }

  /**
    *	@notice modifies _primary
  */
   constructor() public {
        _primary = msg.sender;
    }


    /**
    * @dev Stores the sent amount as credit to be withdrawn.
    * @param payee The destination address of the funds.
	*	@notice modifies _deposits[payee]
	*	@notice modifies address(this).balance
    */
    function deposit(address payee) public payable onlyPrimary {
        uint256 amount = msg.value;
        _deposits[payee] = _deposits[payee].add(amount);

        emit Deposited(payee, amount);
    }

    /**
    * @dev Withdraw accumulated balance for a payee.
    * @param payee The address whose funds will be withdrawn and transferred to.
   	*	@notice modifies _deposits[payee]
	*	@notice modifies address(this).balance
	*	@notice modifies payee.balance
	*/
    function withdraw(address payable payee) public onlyPrimary {
        uint256 payment = _deposits[payee];

        _deposits[payee] = 0;

        payee.transfer(payment);

        emit Withdrawn(payee, payment);
    }
}