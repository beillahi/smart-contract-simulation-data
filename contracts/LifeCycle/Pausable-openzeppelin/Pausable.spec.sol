pragma solidity ^0.5.0;


//import "./original/Ownable.spec.sol";

// Link to contract source code
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/b395b06b65ce35cac155c13d01ab3fc9d42c5cfb/contracts/lifecycle/Pausable.sol

/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 */
contract Pausable_spec {//is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;

  address public _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor () internal {
      _owner = msg.sender;
      emit OwnershipTransferred(address(0), _owner);
  }

  /**
   * @dev Throws if called by any account other than the owner.
  */
  modifier onlyOwner() {
      require(msg.sender == _owner, "Ownable: caller is not the owner");
      _;
  }


  /**
        @notice postcondition status == paused
  */
  function getStatus() public view returns (bool status) {
    return paused;
  }
  

  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state

        @notice precondition !paused
        @notice postcondition paused
        @notice modifies paused
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state

        @notice precondition paused
        @notice postcondition !paused
        @notice modifies paused
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}