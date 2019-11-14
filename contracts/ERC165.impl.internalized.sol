pragma solidity >=0.5.0;

// Link to contract source code:
// https://github.com/jbaylina/ERC820/blob/master/contracts/TestERC165.sol
// https://eips.ethereum.org/EIPS/eip-165


/**
 * @notice simulation  __verifier_eq(ERC165MappingImplementation.supportedInterfaces, ERC165_Spec._supportedInterfaces)
 */
contract ERC165MappingImplementation {

    bytes4 internal constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    mapping(bytes4 => bool) internal supportedInterfaces;


    /**
        @notice modifies  supportedInterfaces[_INTERFACE_ID_ERC165]
    */
    constructor() internal {
        supportedInterfaces[_INTERFACE_ID_ERC165] = true;
    }


    function supportsInterface(bytes4 interfaceID) internal view returns (bool) {
        return supportedInterfaces[interfaceID];
    }

}