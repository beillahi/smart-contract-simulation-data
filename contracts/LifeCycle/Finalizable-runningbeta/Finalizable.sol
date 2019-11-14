pragma solidity ^0.5.0;


// Link to source contract
// https://github.com/runningbeta/tolar/blob/fcc46608b4ffd2cf1980fd8f9c6794afa8f7cb0e/contracts/lifecycle/Finalizable.sol


/**
 * @title Finalizable contract
 * @dev Lifecycle extension where an owner can do extra work after finishing.
 * @notice simulation  Finalizable$isFinalized == Finalizable_spec$finalized && Finalizable$owner == Finalizable_spec$owner
 */
contract Finalizable {

  address public owner;

  constructor() public {
      owner = msg.sender;
  }
  modifier onlyOwner() {
      require(msg.sender == owner);
      _;
  }

  /// @dev Throws if called before the contract is finalized.
  modifier onlyFinalized() {
    require(isFinalized, "Contract not finalized.");
    _;
  }

  /// @dev Throws if called after the contract is finalized.
  modifier onlyNotFinalized() {
    require(!isFinalized, "Contract already finalized.");
    _;
  }

  bool public isFinalized = false;

  event Finalized();

  /**
   * @dev Called by owner to do some extra finalization
   * work. Calls the contract's finalization function.
   * @notice modifies isFinalized
   */
  function finalize() public onlyOwner onlyNotFinalized {
    finalization();
    emit Finalized();

    isFinalized = true;
  }

  /**
   * @dev Can be overridden to add finalization logic. The overriding function
   * should call super.finalization() to ensure the chain of finalization is
   * executed entirely.
   */
  function finalization() internal {
    // override
  }

  function getFinalize() public view returns (bool status) {
        return isFinalized;
  }

}