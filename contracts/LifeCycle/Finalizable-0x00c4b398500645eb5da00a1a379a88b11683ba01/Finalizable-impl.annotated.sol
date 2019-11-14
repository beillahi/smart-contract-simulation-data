// ----------------------------------------------------------------------------
// Finalizable - Basic implementation of the finalization pattern
// Enuma Blockchain Platform
//
// Copyright (c) 2017 Enuma Technologies.
// https://www.enuma.io/
// ----------------------------------------------------------------------------

pragma solidity ^0.5.0;


/// @notice simulation true
contract Finalizable {

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


   function finalize() public onlyOwner returns (bool) {
      require(!finalized);

      finalized = true;

      emit Finalized();

      return true;
   }
}