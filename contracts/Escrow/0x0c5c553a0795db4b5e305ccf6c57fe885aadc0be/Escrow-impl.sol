/**
 *Submitted for verification at Etherscan.io on 2019-05-17
*/

pragma solidity ^0.5.0;

import './original/SafeMath.sol';

/**
 * @title Escrow
 * @dev Base escrow contract, holds funds destinated to a payee until they
 * withdraw them. The contract that uses the escrow as its payment method
 * should be its owner, and provide public methods redirecting to the escrow's
 * deposit and withdraw.
 * @notice simulation __verifier_eq(Escrow$deposits, Escrow_spec$deposits) &&  Escrow$owner == Escrow_spec$_primary
 */
contract Escrow {
  using SafeMath_spec for uint256;

  event Deposited(address indexed payee, uint256 weiAmount);
  event Withdrawn(address indexed payee, uint256 weiAmount);

  mapping(address => uint256) private deposits;

  function depositsOf(address _payee) public view returns (uint) {
    return deposits[_payee];
  }

    address public owner;

  /**
    *	@notice modifies owner
  */
  constructor() public {
      owner = msg.sender;
  }
  modifier onlyOwner() {
      require(msg.sender == owner);
      _;
  }

  /**
  * @dev Stores the sent amount as credit to be withdrawn.
  * @param payee The destination address of the funds.
  *	@notice modifies deposits[payee]
  *	@notice modifies address(this).balance
  */
  function deposit(address payee) public payable onlyOwner  {
    uint256 amount = msg.value;
    deposits[payee] = deposits[payee].add(amount);

    emit Deposited(payee, amount);
  }

  /**
  * @dev Withdraw accumulated balance for a payee.
  * @param payee The address whose funds will be withdrawn and transferred to.
  *	@notice modifies deposits[payee]
	*	@notice modifies address(this).balance
	*	@notice modifies payee.balance
  */
  function withdraw(address payable payee) public onlyOwner {
    uint256 payment = deposits[payee];
    require(address(this).balance >= payment);

    deposits[payee] = 0;

    payee.transfer(payment);

    emit Withdrawn(payee, payment);
  }
}