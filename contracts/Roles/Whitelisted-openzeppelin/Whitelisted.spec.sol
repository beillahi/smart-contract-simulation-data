pragma solidity >=0.5.0;

// Link to contract source code:
// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/access/roles/WhitelistedRole.sol
// removed links to Whitelistedadmins and ownable contracts

contract WhitelistedRole  {

    mapping (address => bool) internal _whitelisteds;

    address internal owner;

    /** @notice postcondition owner == msg.sender
        @notice modifies owner
    */
    constructor() public {
        owner = msg.sender;
    }

    /**
        @notice postcondition _whitelisted == _whitelisteds[account]
    */
    function isWhitelisted(address account) public view returns (bool _whitelisted) {
        return _whitelisteds[account];
    }

    /** @notice precondition account != address(0)
        @notice precondition msg.sender == owner
        @notice precondition _whitelisteds[account] == false
        @notice postcondition _whitelisteds[account] == true
        @notice modifies _whitelisteds[account]
    */
    function addWhitelisted(address account) public  {
         require(msg.sender == owner);
        _whitelisteds[account] = true;
    }

    /** @notice precondition account != address(0)
        @notice precondition msg.sender == owner
        @notice precondition _whitelisteds[account] == true
        @notice postcondition _whitelisteds[account] == false
        @notice modifies _whitelisteds[account]
    */
    function removeWhitelisted(address account) public  {
        require(msg.sender == owner);
        _whitelisteds[account] = false;
    }

    /** @notice precondition _whitelisteds[msg.sender] == true
        @notice postcondition _whitelisteds[msg.sender] == false
        @notice modifies _whitelisteds[msg.sender]
    */
    function renounceWhitelisted() public {
        _whitelisteds[msg.sender] = false;
    }

}