pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/MultiSigWallet.impl.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/MultiSigWallet.spec.internalized.sol";

/**
 * @notice invariant __verifier_eq(MultiSigWallet_APIS.is_owner, MultiSigWallet.is_owner)
 * @notice invariant __verifier_eq(MultiSigWallet_APIS.owners, MultiSigWallet.owners)
 * @notice invariant __verifier_eq(MultiSigWallet_APIS.withdrawalConfirmations, MultiSigWallet.confirmations)
 * @notice invariant MultiSigWallet_APIS.withdrawalCount == MultiSigWallet.transactionCount
 * @notice invariant MultiSigWallet_APIS.required == MultiSigWallet.required
 */
contract SimulationCheck is MultiSigWallet_APIS, MultiSigWallet {

    constructor(address[] memory _owners, uint256 _required) public
        MultiSigWallet_APIS(_owners, _required)
        MultiSigWallet(_owners, _required)
    { }

    /**
     * @notice modifies MultiSigWallet_APIS.is_owner[owner]
     * @notice modifies MultiSigWallet_APIS.owners
     * @notice modifies MultiSigWallet.is_owner[owner]
     * @notice modifies MultiSigWallet.owners
     * @notice precondition MultiSigWallet.is_owner[owner] == false
     * @notice precondition owner != address(0)
     * @notice precondition MultiSigWallet.owners.length + 1 <= MAX_OWNER_COUNT
     * @notice precondition msg.sender == address(this)
     */
    function check$addOwner(address owner) public {
        MultiSigWallet_APIS.addOwner(owner);
        MultiSigWallet.addOwner(owner);
    }

    /**
     * @notice modifies MultiSigWallet_APIS.required
     * @notice modifies MultiSigWallet.required
     * @notice precondition _required != 0
     * @notice precondition _required <= MultiSigWallet.owners.length
     * @notice precondition msg.sender == address(this)
     */
    function check$changeRequirement(uint256 _required) public {
        MultiSigWallet_APIS.changeRequirement(_required);
        MultiSigWallet.changeRequirement(_required);
    }

    /**
     * @notice modifies MultiSigWallet_APIS.is_owner[owner]
     * @notice modifies MultiSigWallet_APIS.owners
     * @notice modifies MultiSigWallet_APIS.required
     * @notice modifies MultiSigWallet.is_owner[owner]
     * @notice modifies MultiSigWallet.owners
     * @notice modifies MultiSigWallet.required
     * @notice precondition MultiSigWallet.is_owner[owner] == true
     * @notice precondition MultiSigWallet.owners.length - 1  != 0
     * @notice precondition msg.sender == address(this)
     */
    function check$removeOwner(address owner) public {
        MultiSigWallet_APIS.removeOwner(owner);
        MultiSigWallet.removeOwner(owner);
    }

    /**
     * @notice modifies MultiSigWallet_APIS.is_owner[owner]
     * @notice modifies MultiSigWallet_APIS.is_owner[newOwner]
     * @notice modifies MultiSigWallet_APIS.owners
     * @notice modifies MultiSigWallet.is_owner[owner]
     * @notice modifies MultiSigWallet.is_owner[newOwner]
     * @notice modifies MultiSigWallet.owners
     * @notice precondition MultiSigWallet.is_owner[owner] == true
     * @notice precondition MultiSigWallet.is_owner[newOwner] == false
     * @notice precondition msg.sender == address(this)
     */
    function check$replaceOwner(address owner, address newOwner) public {
        MultiSigWallet_APIS.replaceOwner(owner, newOwner);
        MultiSigWallet.replaceOwner(owner, newOwner);
    }

    /**
     * @notice modifies MultiSigWallet_APIS.withdrawalConfirmations[MultiSigWallet_APIS.withdrawalCount-1][msg.sender]
     * @notice modifies MultiSigWallet_APIS.withdrawals[MultiSigWallet_APIS.withdrawalCount-1]
     * @notice modifies MultiSigWallet_APIS.withdrawalCount
     * @notice modifies MultiSigWallet.confirmations[MultiSigWallet.transactionCount-1][msg.sender]
     * @notice modifies MultiSigWallet.transactions[MultiSigWallet.transactionCount-1]
     * @notice modifies MultiSigWallet.transactionCount
     * @notice precondition MultiSigWallet.is_owner[msg.sender]
     * @notice precondition MultiSigWallet.transactions[MultiSigWallet.transactionCount].destination == address(0)
     * @notice precondition MultiSigWallet.confirmations[MultiSigWallet.transactionCount][msg.sender] == false
     * @notice precondition _destination != address(0)
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$submitTransaction(address payable _destination, uint256 _val) public returns (uint256 impl_ret_0, uint256 spec_ret_0) {
        impl_ret_0 = MultiSigWallet_APIS.submitTransaction(_destination, _val);
        spec_ret_0 = MultiSigWallet.submitTransaction(_destination, _val);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies MultiSigWallet_APIS.withdrawals[transactionId]
     * @notice modifies MultiSigWallet.transactions[transactionId].executed
     * @notice precondition MultiSigWallet.transactions[transactionId].executed == false
     * @notice precondition MultiSigWallet.transactions[transactionId].destination != address(0)
     */
    function check$executeTransaction(uint256 transactionId) public {
        MultiSigWallet_APIS.executeTransaction(transactionId);
        MultiSigWallet.executeTransaction(transactionId);
    }

    /**
     * @notice modifies MultiSigWallet_APIS.withdrawalConfirmations[transactionId][msg.sender]
     * @notice modifies MultiSigWallet.confirmations[transactionId][msg.sender]
     * @notice precondition MultiSigWallet.is_owner[msg.sender]
     * @notice precondition MultiSigWallet.confirmations[transactionId][msg.sender] == true
     * @notice precondition MultiSigWallet.transactions[transactionId].executed == false
     */
    function check$revokeTransaction(uint256 transactionId) public {
        MultiSigWallet_APIS.revokeTransaction(transactionId);
        MultiSigWallet.revokeTransaction(transactionId);
    }

    /**
     * @notice modifies MultiSigWallet_APIS.withdrawalConfirmations[transactionId][msg.sender]
     * @notice modifies MultiSigWallet_APIS.withdrawals[transactionId]
     * @notice modifies MultiSigWallet.confirmations[transactionId][msg.sender]
     * @notice modifies MultiSigWallet.transactions[transactionId].executed
     * @notice precondition MultiSigWallet.is_owner[msg.sender]
     * @notice precondition MultiSigWallet.confirmations[transactionId][msg.sender] == false
     * @notice precondition MultiSigWallet.transactions[transactionId].destination != address(0)
     * @notice precondition MultiSigWallet.transactions[transactionId].executed == false
     */
    function check$confirmTransaction(uint256 transactionId) public {
        MultiSigWallet_APIS.confirmTransaction(transactionId);
        MultiSigWallet.confirmTransaction(transactionId);
    }

    /**
     * @notice precondition MultiSigWallet.transactions[transactionId].executed == false
     * @notice precondition MultiSigWallet.transactions[transactionId].destination != address(0)
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$isConfirmed(uint256 transactionId) public view returns (bool impl_ret_0, bool spec_ret_0) {
        impl_ret_0 = MultiSigWallet_APIS.isConfirmed(transactionId);
        spec_ret_0 = MultiSigWallet.isConfirmed(transactionId);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice postcondition __verifier_eq(impl_ret_0, spec_ret_0)
     */
    function check$getOwners() public view returns (address[] memory impl_ret_0, address[] memory spec_ret_0) {
        impl_ret_0 = MultiSigWallet_APIS.getOwners();
        spec_ret_0 = MultiSigWallet.getOwners();
        return (impl_ret_0, spec_ret_0);
    }
}