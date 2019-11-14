// Copyright New Alchemy Limited, 2017. All rights reserved.
pragma solidity ^0.5.0;

// Link to source code 
// https://github.com/aionnetwork/aion_erc/blob/master/token/contracts/Finalizable.sol

// @notice simulation  Finalizable$isFinalized == Finalizable_spec$finalized && Finalizable$owner == Finalizable_spec$owner
/// @notice simulation __verifier_eq(Finalizable$finalized, Finalizable_spec$finalized) && __verifier_eq(Finalizable$owner, Finalizable_spec$owner)
contract Finalizable {
    bool public finalized;

    address public owner;

    constructor()  public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
       @notice modifies finalized
    */
    function finalize() public onlyOwner {
        finalized = true;
    }

    modifier notFinalized() {
        require(!finalized);
        _;
    }
    
    function getFinalize() public view returns (bool status) {
        return finalized;
    }
}