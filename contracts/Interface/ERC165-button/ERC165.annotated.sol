pragma solidity ^0.5.0;

//import "./original/IERC165.sol";



/**
 * @title ERC165
 * @author Matt Condon (@shrugs)
 * @dev Implements ERC165 using a lookup table.
 */
 /**
 * @notice simulation __verifier_eq(ERC165._supportedInterfaces, ERC165_Spec._supportedInterfaces)
 */
/// @notice simulation __verifier_eq(ERC165$_supportedInterfaces, ERC165_Spec$_supportedInterfaces)
contract ERC165  {

  bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
  /**
   * 0x01ffc9a7 ===
   *   bytes4(keccak256('supportsInterface(bytes4)'))
   */

  /**
   * @dev a mapping of interface id to whether or not it's supported
   */
  mapping(bytes4 => bool) public _supportedInterfaces;

  /**
   * @dev A contract implementing SupportsInterfaceWithLookup
   * implement ERC165 itself
   */

  /**
        @notice modifies  _supportedInterfaces[_InterfaceId_ERC165]
  */
  constructor()
    public
  {
    _registerInterface(_InterfaceId_ERC165);
  }

  /**
   * @dev implement supportsInterface(bytes4) using a lookup table
   */
  function supportsInterface(bytes4 interfaceId)
    external
    view
    returns (bool)
  {
    return _supportedInterfaces[interfaceId];
  }

  /**
   * @dev private method for registering an interface
   */
  /**
        @notice modifies  _supportedInterfaces[interfaceId]
  */
  function _registerInterface(bytes4 interfaceId)
    internal
  {
    require(interfaceId != 0xffffffff);
    _supportedInterfaces[interfaceId] = true;
  }
}