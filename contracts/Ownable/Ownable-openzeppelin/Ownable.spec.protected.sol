pragma solidity >=0.5.0;

// Link to contract source code:
// https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol


contract Ownable {
    address internal  _owner;

    /**       @notice modifies _owner
   */
    constructor () public {
        _owner = msg.sender;
    }


    /**
      * @notice postcondition owner == _owner
     */
    function getOwner() public view returns (address owner) {
        return _owner;
    }

    /**
      * @notice postcondition status == (msg.sender == _owner)
     */
    function isOwner() public view returns (bool status) {
        return msg.sender == _owner;
    }

    /**
        @notice precondition _owner == msg.sender
        @notice postcondition _owner == address(0)
        @notice modifies _owner
    */
    function renounceOwnership() public {
        _owner = address(0);
    }

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
    function transferOwnership(address newOwner) public onlyOwner { 
        require(isOwner());
        require(newOwner != address(0));
        _owner = newOwner;
    }
}