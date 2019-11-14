// ----------------------------------------------------------------------------
// Finalizable - Basic implementation of the finalization pattern
// Enuma Blockchain Platform
//
// Copyright (c) 2017 Enuma Technologies.
// https://www.enuma.io/
// ----------------------------------------------------------------------------

pragma solidity ^0.5.0;


contract Finalizable_spec {

   bool public finalized;

   event Finalized();

     address public owner;

  constructor() public {
    owner = msg.sender;
    finalized = false;
  }

  modifier onlyOwner() {
    if (msg.sender != owner) {
      revert();
    }
    _;
  }
    /**
        @notice precondition !finalized
        @notice postcondition finalized
        @notice modifies finalized
    */
   function finalize() public onlyOwner {
      require(!finalized);

      finalized = true;

      emit Finalized();
   }

    /**
        * @notice postcondition status == finalized
    */
    function getFinalize() public view returns (bool status) {
        return finalized;
    }
}