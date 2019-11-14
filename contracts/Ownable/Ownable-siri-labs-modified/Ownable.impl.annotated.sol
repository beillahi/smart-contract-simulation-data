pragma solidity >=0.5.0;

// Link to contract source code:
// https://github.com/sirin-labs/crowdsale-smart-contract/blob/master/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 
  @notice simulation Ownable_sirin_labs.owner == Ownable._owner
*/
/// @notice simulation __verifier_eq(Ownable_sirin_labs$owner, Ownable$_owner)
contract Ownable_sirin_labs {
 
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);



  /**       @notice modifies owner
  */
  constructor() public {
    owner = msg.sender;
  }


      
  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
  
     @notice modifies owner
  */
  function transferOwnership(address newOwner) public {
    require(newOwner != address(0));
    emit OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }


  function getOwner() public view returns (address) {
        return owner;
    }

}