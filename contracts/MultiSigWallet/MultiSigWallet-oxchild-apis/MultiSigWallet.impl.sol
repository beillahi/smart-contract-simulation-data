pragma solidity >=0.5.0;


// Usually this contract should be working with ERC20 tokens
// and inherit from ERC20. To simplify I changed to work with ether
// instead and to not inherit from ERC20

// link to contract source code
// https://raw.githubusercontent.com/Oxchild/MultiSigWallet-APIS/master/contract/multiSigApis.sol
// TODO add notice simulation __verifier_eq(MultiSigWallet_APIS.withdrawals, MultiSigWallet.transactions)

 /**
 * @notice simulation  __verifier_eq(MultiSigWallet_APIS.is_owner, MultiSigWallet.is_owner)
 * @notice simulation __verifier_eq(MultiSigWallet_APIS.owners, MultiSigWallet.owners)
 * @notice simulation __verifier_eq(MultiSigWallet_APIS.withdrawalConfirmations, MultiSigWallet.confirmations)
 * @notice simulation  MultiSigWallet_APIS.withdrawalCount == MultiSigWallet.transactionCount
 * @notice simulation  MultiSigWallet_APIS.required        == MultiSigWallet.required
 
 */
contract MultiSigWallet_APIS {

    //@dev Owners can not register more than 50
    uint constant internal MAX_OWNER_COUNT = 50;
    
    mapping (address => bool) internal is_owner ;
    address[] public owners;


    mapping(uint => Withdrawal) internal withdrawals;
    
    mapping(uint => mapping (address => bool)) internal withdrawalConfirmations;
    
    uint internal withdrawalCount;

    uint internal required;

    struct Withdrawal {
        address payable destination;
        uint attoApis;
        bool executed;
    }



    constructor(address[] memory _owners, uint _required)
        public
    {
        for (uint i = 0 ; i < _owners.length ; i++) {
            if (_owners[i] == address(0))
                revert("An owner cannot be null");
            is_owner[_owners[i]] = true;
        }
        owners = _owners;
        required = _required;
    }


    /** @notice precondition is_owner[owner] == false
        @notice precondition owner != address(0)
        @notice precondition owners.length + 1 <= MAX_OWNER_COUNT
        @notice precondition msg.sender == address(this)
        @notice postcondition is_owner[owner] == true
        @notice postcondition owners[owners.length - 1] == owner
        @notice modifies is_owner[owner]
        @notice modifies owners
    */
    function addOwner(address owner) public
    {
        is_owner[owner] = true;
        owners.push(owner);
    }

    /** @notice modifies required
    */
    function changeRequirement(uint _required) public
    {
        required = _required;
    }

    /** 
        @notice modifies is_owner[owner]
        @notice modifies owners
        @notice modifies required
    */
    function removeOwner(address owner)
        public
    {
        is_owner[owner] = false;
        for (uint i = 0 ; i < owners.length - 1 ; i++)
            if (owners[i] == owner) {
                owners[i] = owners[owners.length - 1];
                break;
            }
        owners.length -= 1;
        if (required > owners.length)
            changeRequirement(owners.length);
    }

    /**
        @notice modifies is_owner[owner]
        @notice modifies is_owner[newOwner]
        @notice modifies owners
    */
    function replaceOwner(address owner, address newOwner)
        public
    {
        for (uint i = 0 ; i < owners.length ; i++)
            if (owners[i] == owner) {
                owners[i] = newOwner;
                break;
            }
        is_owner[owner] = false;
        is_owner[newOwner] = true;
    }


    /**
        @notice modifies withdrawalConfirmations[withdrawalCount-1][msg.sender]
        @notice modifies withdrawals[withdrawalCount-1]
        @notice modifies withdrawalCount
    */
    function submitTransaction(address payable _destination, uint _val) public returns (uint withdrawalId)
    {
        withdrawalId = withdrawalCount;
        withdrawals[withdrawalId].destination = _destination;
        withdrawals[withdrawalId].attoApis = _val;
        withdrawals[withdrawalId].executed = false;

        withdrawalConfirmations[withdrawalId][msg.sender] = true;

        withdrawalCount ++;
    }

  
    /** 
        @notice modifies withdrawalConfirmations[transactionId][msg.sender]
        @notice modifies withdrawals[transactionId]
    */
    function confirmTransaction(uint transactionId) public
    {
        withdrawalConfirmations[transactionId][msg.sender] = true;
        executeTransaction(transactionId);
    }

    /** 
        @notice modifies withdrawalConfirmations[transactionId][msg.sender]
    */
    function revokeTransaction(uint transactionId) public
    {
        withdrawalConfirmations[transactionId][msg.sender] = false;
    }


    /** 
        @notice modifies withdrawals[transactionId]
    */
    function executeTransaction(uint transactionId) public
    {
        if (isConfirmed(transactionId)) {
            withdrawals[transactionId].executed = true;

            withdrawals[transactionId].destination.transfer(withdrawals[transactionId].attoApis);
        }

    }

    function isConfirmed(uint transactionId)
        internal
        view
        returns (bool)
    {
        uint count = 0;
        for (uint i = 0; i < owners.length; i++) {
            if (withdrawalConfirmations[transactionId][owners[i]])
                count += 1;
            if (count == required)
                return true;
        }
    }


    function getOwners()
        public
        view
        returns (address[] memory)
    {
        return owners;
    }


}