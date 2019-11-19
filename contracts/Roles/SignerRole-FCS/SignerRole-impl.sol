pragma solidity ^0.5.0;

import "./original/Roles.sol";

// Link to source contract
// https://github.com/fcscolorstone/FCS/blob/master/fcs_token/access/roles/SignerRole.sol

contract SignerRole_impl {
    using Roles for Roles.Role;

    event SignerAdded(address indexed account);
    event SignerRemoved(address indexed account);

    Roles.Role _signers;

   constructor () internal {
        _addSigner(msg.sender);
    }

    modifier onlySigner() {
        require(isSigner(msg.sender));
        _;
    }

    /// @notice fieldaccessor _signers
    function isSigner(address account) public view returns (bool) {
        return _signers.has(account);
    }

    /** @notice modifies _signers.bearer[account]
    */
    function addSigner(address account) public onlySigner {
        _addSigner(account);
    }

     /** @notice modifies _signers.bearer[msg.sender]
    */
    function renounceSigner() public {
        _removeSigner(msg.sender);
    }

    /** @notice modifies _signers.bearer[account]
    */
    function _addSigner(address account) internal {
        _signers.add(account);
        emit SignerAdded(account);
    }

    /** @notice modifies _signers.bearer[account]
    */
    function _removeSigner(address account) internal {
        _signers.remove(account);
        emit SignerRemoved(account);
    }
}