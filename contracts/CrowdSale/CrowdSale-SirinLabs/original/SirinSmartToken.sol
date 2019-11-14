pragma solidity ^0.5.0;


import './bancor/LimitedTransferBancorSmartToken.sol';


/**
  A Token which is 'Bancor' compatible and can mint new tokens and pause token-transfer functionality
*/
contract SirinSmartToken is LimitedTransferBancorSmartToken {

    // =================================================================================================================
    //                                         Members
    // =================================================================================================================

    string public name = "SIRIN";

    string public symbol = "SRN";

    uint8 public decimals = 18;

    // =================================================================================================================
    //                                         Constructor
    // =================================================================================================================

    constructor() public {
        //Apart of 'Bancor' computability - triggered when a smart token is deployed
        emit NewSmartToken(address(this));
    }
}
