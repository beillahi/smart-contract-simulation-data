pragma solidity ^0.5.0;

import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Fck.internalized.sol";
import "/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/Dice.spec.internalized.sol";

/**
 * @notice invariant __verifier_eq(FckDice.bets, Dice.bets)
 */
contract SimulationCheck is FckDice, Dice {

    /**
     * @notice modifies Dice.bets[betId]
     * @notice precondition Dice.bets[betId].player == address(0)
     * @notice precondition msg.value != 0
     * @notice precondition betMask == 6
     * @notice precondition address(this).balance >= __verifier_sum_uint(Dice.bets[betId].amount * 6 - house_edge)
     * @notice precondition address(this).balance + msg.value >= address(this).balance
     */
    function check$placeBet(uint256 betId, uint256 modulo, uint256 betMask) external payable {
        FckDice.placeBet(betId, modulo, betMask);
        Dice.placeBet(betId, modulo, betMask);
    }

    /**
     * @notice modifies Dice.bets[betId].amount  
     * @notice precondition Dice.bets[betId].player != address(0)
     * @notice precondition Dice.bets[betId].amount != 0
     */
    function check$settleBet(uint256 betId, uint256 modulo) external {
        FckDice.settleBet(betId, modulo);
        Dice.settleBet(betId, modulo);
    }
}