pragma solidity ^0.5.0;


contract voting {
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

/* mapping field below is equivalent to an associative array or hash.
 The key of the mapping is candidate name stored as type bytes32 and value is
an unsigned integer to store the vote count
*/
    mapping (bytes32 => uint8)  public votesReceived;

/* Solidity doesn't let you pass in an array of strings in the constructor (yet).
We will use an array of bytes32 instead to store the list of candidates
*/
    bytes32[] public candidateList;

/* This is the constructor which will be called once when you
deploy the contract to the blockchain. When we deploy the contract,
we will pass an array of candidates who will be contesting in the election
*/
    /** TODO notice postcondition __verifier_eq(candidateList, candidateNames)
        @notice modifies candidateList
    */
    constructor(bytes32[] memory candidateNames) public{
        candidateList = candidateNames;
    }

    /** @notice postcondition totalVotes == votesReceived[candidate]
    */
    function  spec_totalVotesFor( bytes32 candidate) public view returns (uint8 totalVotes);

    /** @notice postcondition votesReceived[candidate] == __verifier_old_uint(votesReceived[candidate]) + 1
        @notice modifies votesReceived[candidate]
    */
    function  spec_voteForCandidate( bytes32 candidate) public ;


    function validCandidate(bytes32 candidate) internal view returns (bool){
        for (uint i = 0; i < candidateList.length; i++) {
            if (candidateList[i] == candidate) {
                return true;
            }
        }
        return false;
    }

 
    

}