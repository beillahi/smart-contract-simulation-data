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

    event WhitelistAdded(address indexed addr);
    event WhitelistRemoved(address indexed addr);

    modifier onlyOwner() {
        if (msg.sender != owner) {
          revert();
        }
        _;
      }


    /** @notice modifies owner
    */
    constructor() public {
        owner = msg.sender;
    }

    /** @notice modifies length
        @notice modifies whitelist[account]
    */
    function addWhitelisted(address account) public onlyOwner {
        require(account != address(0));
        whitelist[account] = true;
        length++;
        emit WhitelistAdded(account);
    }

    /** @notice modifies length
        @notice modifies whitelist[account]
    */
    function removeWhitelisted(address account) public onlyOwner {
        require(account != address(0));
        whitelist[account] = false;
        length++;
        emit WhitelistRemoved(account);
    }


    function isWhitelisted(address account) public view returns (bool) {
        require(account != address(0));
        if (length == 0) {
            return false;
        }
        return whitelist[account];
    }
}