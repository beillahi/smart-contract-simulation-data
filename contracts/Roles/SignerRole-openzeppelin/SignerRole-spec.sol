pragma solidity ^0.5.0;

import "./original/Roles.sol";

contract SignerRole_spec {
    using Roles for Roles.Role;

    event SignerAdded(address indexed account);
    event SignerRemoved(address indexed account);

    Roles.Role _signers;

    constructor () internal {
        _addSigner(msg.sender);
    }

    modifier onlySigner() {
        require(_signers.has(msg.sender), "SignerRole: caller does not have the Signer role");
        _;
    }

    /** @notice fieldaccessor _signers
        @notice postcondition status == _signers.bearer[account]
        @notice precondition account != address(0)
    */
    function isSigner(address account) public view returns (bool status) {
        return _signers.has(account);
    }

    /** @notice postcondition (_signers.bearer[msg.sender] && _signers.bearer[account]) || (!_signers.bearer[msg.sender] && _signers.bearer[account] == __verifier_old_bool(_signers.bearer[account]))
        @notice modifies _signers.bearer[account]
    */
    function addSigner(address account) public onlySigner {
        _addSigner(account);
    }

    /** @notice postcondition !_signers.bearer[msg.sender]
        @notice modifies _signers.bearer[msg.sender]
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