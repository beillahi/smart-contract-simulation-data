pragma solidity >=0.5.0;

// Link to contract source code:
// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/access/roles/WhitelistedRole.sol
// removed links to Whitelistedadmins and ownable contracts

contract WhitelistedRole  {
   uint public shadow$spec$Balance; 
   modifier shadow$spec$Balance$Modifier {
            shadow$spec$Balance = address(this).balance - msg.value;
            _;
            shadow$spec$Balance = address(this).balance;
        } 
   modifier shadow$spec$Balance$Modifier1 {
            shadow$spec$Balance = address(this).balance;
            _;
            shadow$spec$Balance = address(this).balance;
        }

    mapping (address => bool) internal _whitelisteds;

    address internal owner;

    /** @notice postcondition owner == msg.sender
        @notice modifies owner
    */
    constructor() shadow$spec$Balance$Modifier1 public {
        owner = msg.sender;
    }

    /**
        @notice postcondition _whitelisted == _whitelisteds[account]
    */
    function  spec_isWhitelisted( address account) public view returns (bool _whitelisted) ;

    /** @notice precondition account != address(0)
        @notice precondition msg.sender == owner
        @notice precondition _whitelisteds[account] == false
        @notice postcondition _whitelisteds[account] == true
        @notice modifies _whitelisteds[account]
    */
    function  spec_addWhitelisted( address account) public  ;

    /** @notice precondition account != address(0)
        @notice precondition msg.sender == owner
        @notice precondition _whitelisteds[account] == true
        @notice postcondition _whitelisteds[account] == false
        @notice modifies _whitelisteds[account]
    */
    function  spec_removeWhitelisted( address account) public  ;

    /** @notice precondition _whitelisteds[msg.sender] == true
        @notice postcondition _whitelisteds[msg.sender] == false
        @notice modifies _whitelisteds[msg.sender]
    */
    function  spec_renounceWhitelisted( ) public ;

}