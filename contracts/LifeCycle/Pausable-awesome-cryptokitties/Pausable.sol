pragma solidity ^0.5.0;


/**
 * @title Pausable
 * @dev Base contract which allows children to implement an emergency stop mechanism.
 * @notice simulation Pausable_impl$paused == Pausable_spec$paused 
 * @notice simulation Pausable_impl$owner == Pausable_spec$_owner 
 */

contract Pausable_impl  { //is Ownable_impl {
  event Pause();
  event Unpause();

  bool public paused = false;


  address public owner;

  /**
        @notice modifies owner
  */
  constructor() public {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    if (msg.sender != owner) {
      revert();
    }
    _;
  }

  function getStatus() public view returns (bool status) {
    return paused;
  }


  /**
   * @dev modifier to allow actions only when the contract IS paused
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev modifier to allow actions only when the contract IS NOT paused
   */
  modifier whenPaused {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  /**
        @notice modifies paused
  */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    emit Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  /**
        @notice modifies paused
  */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    emit Unpause();
  }
}