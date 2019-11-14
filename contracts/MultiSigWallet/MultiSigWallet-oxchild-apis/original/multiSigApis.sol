pragma solidity >=0.5.0;

// https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
import './ERC20.sol';

import './Owners.sol';


contract MultisigApis is Owners {

    //@dev These events occur when the withdrawal agenda is registered / confirmed / revoked / executed. 
    event WithdrawalSubmission(uint indexed withdrawalId, address destination, uint256 attoApis);
    event WithdrawalConfirmation(address indexed owner, uint indexed withdrawalId);
    event WithdrawalRevocation(address indexed owner, uint indexed withdrawalId);
    event WithdrawalExecution(uint indexed withdrawalId);
    
    
    //@dev Owners can not register more than 50
    uint constant public MAX_OWNER_COUNT = 50;
    
    
    mapping(uint => Withdrawal) public withdrawals;
    
    mapping(uint => mapping (address => bool)) public withdrawalConfirmations;
    
    uint public withdrawalCount;
    
    ERC20 tokenContract;
    
    
    struct Withdrawal {
        address destination;
        uint attoApis;
        bool executed;
    }
    
    
    
    modifier validWithdrawalAmount(uint256 attoApis) {
        require(tokenContract.balanceOf(this) >= attoApis);
        _;
    }
    
    modifier withdrawalExists(uint _withdrawalId) {
        require(withdrawals[_withdrawalId].destination != 0);
        _;
    }
    
    modifier confirmedWithdrawal(uint _withdrawalId, address _owner) {
        require(withdrawalConfirmations[_withdrawalId][_owner]);
        _;
    }
    
    modifier notConfirmedWithdrawal(uint _withdrawalId, address _owner) {
        require(!withdrawalConfirmations[_withdrawalId][_owner]);
        _;
    }
    
    modifier notExecutedWithdrawal(uint _withdrawalId) {
        require(!withdrawals[_withdrawalId].executed);
        _;
    }
    
    
    
    
    /**
     * @dev Prevent ETH deposits.
     */
    function() public payable {
        revert();
    }
    
    
    /**
     * @dev Contract constructor sets initial owners and required number of confirmations.
     * @param _owners List of initial owners.
     * @param _required Number of required confirmations.
     * @param _tokenAddress ERC20 Token contract address
     */
    function MultisigApis(address[] _owners, uint _required, address _tokenAddress) 
        public 
        validRequirement(_owners.length, _required) 
    {
        require(owners.length == 0 && required == 0);
        require(_tokenAddress != 0x0);
        
        for (uint i = 0; i < _owners.length; i++) {
            require(!isOwner[_owners[i]] && _owners[i] != 0);
            isOwner[_owners[i]] = true;
        }
        
        owners = _owners;
        required = _required;
        tokenContract = ERC20(_tokenAddress);
    }
    
    
    function balanceOfThisWallet() public constant returns (uint256 aApis) {
        return tokenContract.balanceOf(this);
    }
    
    
    
    
    /**
     * @dev Allows an owner to submit and confirm a withdrawal
     */
    function registerWithdrawal(address _destination, uint256 _attoApis) 
        public 
        notNull(_destination) 
        ownerExists(msg.sender) 
        validWithdrawalAmount(_attoApis)
        returns (uint withdrawalId) 
    {
        withdrawalId = withdrawalCount;
        withdrawals[withdrawalId] = Withdrawal({
            destination : _destination,
            attoApis : _attoApis,
            executed : false
        });
        
        withdrawalCount += 1;
        emit WithdrawalSubmission(withdrawalId, _destination, _attoApis);
        
        confirmWithdrawal(withdrawalId);
    }
    
    /**
     * @dev Allows an owner to confirm a withdrawal
     * @param _withdrawalId Withdrawal ID
     */
    function confirmWithdrawal(uint _withdrawalId) 
        public
        ownerExists(msg.sender) 
        withdrawalExists(_withdrawalId)
        notConfirmedWithdrawal(_withdrawalId, msg.sender)
    {
        withdrawalConfirmations[_withdrawalId][msg.sender] = true;
        emit WithdrawalConfirmation(msg.sender, _withdrawalId);
        
        executeWithdrawal(_withdrawalId);
    }
    
    
    /**
     * @dev Allows an owner to revoke a confirmation for a transaction
     * @param _withdrawalId Withdrawal ID
     */
    function revokeConfirmation(uint _withdrawalId)
        public
        ownerExists(msg.sender)
        confirmedWithdrawal(_withdrawalId, msg.sender)
        notExecutedWithdrawal(_withdrawalId)
    {
        withdrawalConfirmations[_withdrawalId][msg.sender] = false;
        emit WithdrawalRevocation(msg.sender, _withdrawalId);
    }
    
    
    /**
     * @dev Allows an owner to execute a confirmed withdrawal
     * @param _withdrawalId withdrawal ID
     */
    function executeWithdrawal(uint _withdrawalId)
        internal
        ownerExists(msg.sender)
        confirmedWithdrawal(_withdrawalId, msg.sender)
        notExecutedWithdrawal(_withdrawalId)
    {
        if(isWithdrawalConfirmed(_withdrawalId)) {
            Withdrawal storage withdrawal = withdrawals[_withdrawalId];
            assert(tokenContract.transfer(withdrawal.destination, withdrawal.attoApis));
            withdrawal.executed = true;
            
            emit WithdrawalExecution(_withdrawalId);
        }
    }
    
    /** 
     * @dev Returns the confirmation status of a withdrawal.
     * @param _withdrawalId Withdrawal ID.
     * @return Confirmation status.
     */
    function isWithdrawalConfirmed(uint _withdrawalId)
        internal
        constant
        returns (bool)
    {
        uint count = 0;
        for (uint i = 0; i < owners.length; i++) {
            if (withdrawalConfirmations[_withdrawalId][owners[i]])
                count += 1;
            if (count == required)
                return true;
        }
    }
}