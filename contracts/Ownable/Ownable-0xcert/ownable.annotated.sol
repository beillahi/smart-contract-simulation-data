pragma solidity ^0.5.0;


// Link to contract source code:
// https://github.com/0xcert/ethereum-erc721/blob/master/src/contracts/ownership/ownable.sol

/**
 * @dev The contract has an owner address, and provides basic authorization control whitch
 * simplifies the implementation of user permissions. This contract is based on the source code at:
 * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
 */
/// @notice simulation __verifier_eq(Ownable_impl$owner, Ownable$_owner)
contract Ownable_impl {
  
  /**
   * @dev Error constants.
   */
  string public constant NOT_OWNER = "018001";
  string public constant ZERO_ADDRESS = "018002";

  /**
   * @dev Current owner address.
   */
  address public owner;

  /**
   * @dev An event which is triggered when the owner is changed.
   * @param previousOwner The address of the previous owner.
   * @param newOwner The address of the new owner.
   */
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
   * @dev The constructor sets the original `owner` of the contract to the sender account.
   */

 /**       @notice modifies owner
  */
  constructor()
    public
  {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner()
  {
    //require(msg.sender == owner, NOT_OWNER);
    require(msg.sender == owner, "018001");
    _;
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */

    /**       @notice modifies owner
  */
  function transferOwnership(
    address _newOwner
  )
    public
    onlyOwner
  {
    //require(_newOwner != address(0), ZERO_ADDRESS);
    require(_newOwner != address(0), "018002");
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }




  function getOwner() public view returns (address) {
        return owner;
    }


}