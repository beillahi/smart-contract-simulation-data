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

    address internal _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() shadow$spec$Balance$Modifier1 public {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     * @notice postcondition owner == _owner
     */
    function  spec_getOwner( ) public view returns (address owner) ;

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() internal view returns (bool) {
        return msg.sender == _owner;
    }


    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.

        @notice precondition _owner == msg.sender
        @notice postcondition _owner == address(0)
        @notice modifies _owner
     */
    function  spec_renounceOwnership( ) public  ;

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.

        @notice precondition newOwner != address(0)
        @notice precondition _owner == msg.sender
        @notice postcondition _owner == newOwner
        @notice modifies _owner
     */
    function  spec_transferOwnership( address newOwner) public ;

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).

        @notice precondition newOwner != address(0)
        @notice precondition _owner == msg.sender
        @notice postcondition _owner == newOwner
        @notice modifies _owner
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}