pragma solidity ^0.5.0;


contract SupportsInterfaceWithLookup {
  bytes4 public constant InterfaceId_ERC165 = 0x01ffc9a7;

  mapping(bytes4 => bool) internal supportedInterfaces;

  /**
    * @notice modifies  supportedInterfaces[InterfaceId_ERC165]
     */
  constructor()
    public
  {
    _registerInterface(InterfaceId_ERC165);
  }

  function supportsInterface(bytes4 _interfaceId)
    external
    view
    returns (bool)
  {
    return supportedInterfaces[_interfaceId];
  }

   /**
    * @notice modifies  supportedInterfaces[interfaceId]
     */
  function _registerInterface(bytes4 interfaceId)
    internal
  {
    require(interfaceId != 0xffffffff);
    supportedInterfaces[interfaceId] = true;
  }
}