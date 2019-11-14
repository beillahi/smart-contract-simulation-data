/**
 *Submitted for verification at Etherscan.io on 2018-10-23
*/

pragma solidity ^0.5.0;

/// @notice simulation __verifier_eq(Voting_impl$votesReceived, voting$votesReceived) && __verifier_eq(Voting_impl$candidateList, voting$candidateList)
contract Voting_impl {
  address creator; // The address of the account that created this ballot.

  mapping (bytes32 => uint8) public votesReceived;
  mapping (address => bytes32) public votes;

  bytes32[] public candidateList;
  uint16 public totalVotes;
  bool public votingFinished;

  /**
    @notice modifies candidateList
    @notice modifies creator
 */
  constructor(bytes32[] memory candidateNames) public {
    creator = msg.sender;
    candidateList = candidateNames;
  }

  function totalVotesFor(bytes32 candidate) public view returns (uint8) {
    require(validCandidate(candidate));
    //require(votingFinished);  // Don't reveal votes until voting is finished
    return votesReceived[candidate];
  }

  function numCandidates() public view returns(uint count) {
    return candidateList.length;
  }

  function getMyVote() public view returns(bytes32 candidate) {
    return votes[msg.sender];
  }

    /**
        @notice modifies votesReceived[candidate]
        @notice modifies votes[msg.sender]
        @notice modifies totalVotes
    */
  function voteForCandidate(bytes32 candidate) public {
    require(!votingFinished);
    require(validCandidate(candidate));
    votes[msg.sender] = candidate;
    votesReceived[candidate] += 1;
    totalVotes += 1;
  }

  function validCandidate(bytes32 candidate) public view  returns (bool) {
    for(uint i = 0; i < candidateList.length; i++) {
      if (candidateList[i] == candidate) {
        return true;
      }
    }
    return false;
  }
  
  function endVote() public returns (bool) {
    require(msg.sender == creator);  // Only contract creator can end the vote.
    votingFinished = true;
  }
  
}