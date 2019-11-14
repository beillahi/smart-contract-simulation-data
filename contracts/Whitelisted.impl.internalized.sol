pragma solidity >=0.5.0;

// Link to contract source code:
// https://github.com/hanzoai/solidity/blob/master/contracts/Whitelist.sol
// removed link to ownable contract

/**
  @notice simulation __verifier_eq(Whitelist.whitelist, WhitelistedRole._whitelisteds)
  @notice simulation Whitelist.owner == WhitelistedRole.owner
 */
contract Whitelist  {

    mapping (address => bool) internal whitelist;
    uint internal length;

    address internal owner;


    /** @notice modifies owner
    */
    constructor() internal {
        owner = msg.sender;
    }

    /** @notice modifies length
        @notice modifies whitelist[account]
    */
    function addWhitelisted(address account) internal {
        require(msg.sender == owner);
        whitelist[account] = true;
        length++;
    }

    /** @notice modifies length
        @notice modifies whitelist[account]
    */
    function removeWhitelisted(address account) internal {
        require(msg.sender == owner);
        whitelist[account] = false;
        length++;
    }


    function isWhitelisted(address account) internal view returns (bool) {
        if (length == 0) {
            return false;
        }
        return whitelist[account];
    }
}