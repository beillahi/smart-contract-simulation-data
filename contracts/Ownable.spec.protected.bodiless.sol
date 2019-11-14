pragma solidity >=0.5.0;

// Link to contract source code:
// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol


contract Ownable {
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
    address internal  _owner;

    /**       @notice modifies _owner
   */
    constructor () shadow$spec$Balance$Modifier1 public {
        _owner = msg.sender;
    }


    /**
      * @notice postcondition owner == _owner
     */
    function  spec_getOwner( ) public view returns (address owner) ;

    /**
      * @notice postcondition status == (msg.sender == _owner)
     */
    function  spec_isOwner( ) public view returns (bool status) ;

    /**
        @notice precondition _owner == msg.sender
        @notice postcondition _owner == address(0)
        @notice modifies _owner
    */
    function  spec_renounceOwnership( ) public ;

    string public constant NOT_OWNER = "018001";

    modifier onlyOwner()
    {
        require(msg.sender == _owner, NOT_OWNER);
        _;
    }


    /** @notice precondition newOwner != address(0)
        @notice precondition _owner == msg.sender
        @notice postcondition _owner == newOwner
        @notice modifies _owner
    */
    function  spec_transferOwnership( address newOwner) public  ;
}