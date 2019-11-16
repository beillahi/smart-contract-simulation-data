pragma solidity ^0.5.0;

import './original/SafeMath.sol';

// Link to contract source code:
// https://github.com/Stacktical/stacktical-tokensale-contracts/blob/master/contracts/Crowdsale/Escrow.sol


/**
 * @notice simulation __verifier_eq(Escrow_Stacktical.deposits, Escrow_spec.deposits) && (Escrow_Stacktical.owner == Escrow_spec._primary)
 */
contract Escrow_Stacktical {

    using SafeMath_spec for uint256;

    event Deposited(address indexed payee, uint256 weiAmount);
    event Withdrawn(address indexed payee, uint256 weiAmount);

    mapping(address => uint) internal deposits;

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
      * @notice modifies deposits[payee]
      * @notice modifies address(this).balance
      */
    function deposit(address payee) public payable onlyOwner {
        uint256 amount = msg.value;
        deposits[payee] = deposits[payee].add(amount);

        emit Deposited(payee, amount);
    }

    /**
      * @dev Withdraw accumulated balance for a payee.
      * @param payee The address whose funds will be withdrawn and transferred to.
      * @return Amount withdrawn
      * @notice modifies deposits[payee]
      * @notice modifies address(this).balance
      * @notice modifies payee.balance
      */
    function withdraw(address payable payee) public  {
        uint256 payment = deposits[payee];

        require(address(this).balance >= payment);

        deposits[payee] = 0;

        payee.transfer(payment);

        emit Withdrawn(payee, payment);
    }

    /**
      * @dev Withdraws the wallet's funds.
      * @param _wallet address the funds will be transferred to.
      * @notice modifies address(this).balance
      * @notice modifies _wallet.balance
    */
    function beneficiaryWithdraw(address payable _wallet) public onlyOwner {
        uint256 _amount = address(this).balance;
        
        _wallet.transfer(_amount);

        emit Withdrawn(_wallet, _amount);
    }

    /**
      * @dev Returns the deposited amount of the given address.
      * @param _payee address of the payee of which to return the deposted amount.
      * @return Deposited amount by the address given as argument.
    */
    function depositsOf(address _payee) public view returns(uint) {
        return deposits[_payee];
    }
}