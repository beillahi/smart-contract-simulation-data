pragma solidity ^0.5.0;

/**
 * @notice simulation  __verifier_eq(ERC165._supportedInterfaces, ERC165_Spec._supportedInterfaces)
 */
contract ERC165  {
    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    mapping(bytes4 => bool) private _supportedInterfaces;

    /**
        @notice modifies  _supportedInterfaces[_INTERFACE_ID_ERC165]
    */
    constructor () internal {
        _registerInterface(_INTERFACE_ID_ERC165);
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return _supportedInterfaces[interfaceId];
    }

    /**
        @notice modifies  _supportedInterfaces[interfaceId]
    */
    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff);
        _supportedInterfaces[interfaceId] = true;
    }
}