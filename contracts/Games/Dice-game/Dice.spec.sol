pragma solidity >=0.5.0;

// spec for simple dice game

contract Dice {
    
	uint constant house_edge = 1;

      	struct DiceBet {
        	address payable player;
			uint amount;
			uint dice;
		  }

  	mapping(uint=>DiceBet) internal bets ;


    /** @notice precondition bets[betId].player == address(0)
		@notice precondition msg.value != 0
		@notice precondition betMask == 6
		@notice precondition address(this).balance >= __verifier_sum_uint(bets[betId].amount * 6 - house_edge)
        @notice precondition  address(this).balance + msg.value >= address(this).balance
        @notice postcondition address(this).balance == __verifier_old_uint(address(this).balance) +  msg.value
		@notice postcondition bets[betId].dice == modulo
		@notice postcondition bets[betId].player == msg.sender
		@notice modifies bets[betId]
	*/

  	function placeBet(uint betId, uint modulo, uint betMask) external payable {
		require(betMask == 6, "Bet mask for dice game should be 6.");
		bets[betId].player = msg.sender;
        bets[betId].amount = msg.value;
		bets[betId].dice = modulo;
  	}

    /** @notice precondition bets[betId].player != address(0)
		@notice precondition bets[betId].amount != 0
		@notice postcondition bets[betId].amount == 0
		@notice modifies bets[betId].amount  */

	function settleBet(uint betId, uint modulo) external {

		if(bets[betId].dice == modulo)
		{
			bets[betId].player.transfer(6 * (bets[betId].amount - house_edge));
			bets[betId].amount = 0;
  		}
		else
		{
			bets[betId].player.transfer(1 wei);
			bets[betId].amount = 0;
		}

	}
     
}

