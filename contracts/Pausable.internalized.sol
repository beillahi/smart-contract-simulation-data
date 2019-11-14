pragma solidity ^0.5.0;


import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/original/Ownable.sol";


// Link to contract source code 
// https://github.com/Bit-Nation/PAT-TSE-Old/blob/master/contracts/installed_contracts/zeppelin/contracts/lifecycle/Pausable.sol


/*
 * Pausable
 * Abstract contract that allows children to implement a
 * pause mechanism.
 */
/**
  * @notice simulation Pausable_impl$paused == Pausable_spec$paused
  * @notice simulation Pausable_impl$owner == Pausable_spec$_owner 
*/
contract Pausable_impl { //} Ownable_impl {
  event Pause();
  event Unpause();

  bool internal paused = false;

  address internal owner;

  constructor() internal {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    if (msg.sender != owner) {
      revert();
    }
    _;
  }


  function getStatus() internal view returns (bool status) {
    return paused;
  }

  modifier whenNotPaused() {
    if (paused) revert();
    _;
  }

  modifier whenPaused {
    if (!paused) revert();
    _;
  }

  // called by the owner to pause, triggers stopped state
  /**
        @notice modifies paused
  */
  function pause() onlyOwner whenNotPaused internal {
    paused = true;
    emit Pause();
  }

  // called by the owner to unpause, returns to normal state
  /**
        @notice modifies paused
  */
  function unpause() onlyOwner whenPaused internal {
    paused = false;
    emit Unpause();
  }
}