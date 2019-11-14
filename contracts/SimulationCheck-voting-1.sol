pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Voting.impl.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Voting.spec.bodiless.sol";

/**
 * @notice invariant __verifier_eq(Voting.votesReceived, voting.votesReceived)
 * @notice invariant __verifier_eq(Voting.candidateList, voting.candidateList)
 */

contract SimulationCheck is Voting, voting {

    constructor(bytes32[] memory candidateNames) public
        Voting(candidateNames)
        voting(candidateNames)
    { }

    /**
     * @notice postcondition impl_ret_0 == spec_ret_0
     */
    function check$spec_totalVotesFor(bytes32 candidate) public view returns (uint8 impl_ret_0, uint8 spec_ret_0) {
        impl_ret_0 = Voting.totalVotesFor(candidate);
        spec_ret_0 = voting.spec_totalVotesFor(candidate);
        return (impl_ret_0, spec_ret_0);
    }

    /**
     * @notice modifies Voting.votesReceived[candidate]
     * @notice modifies voting.votesReceived[candidate]
     */
    function check$spec_voteForCandidate(bytes32 candidate) public {
        Voting.voteForCandidate(candidate);
        voting.spec_voteForCandidate(candidate);
    }
}
