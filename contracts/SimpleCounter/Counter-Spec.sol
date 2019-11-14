pragma solidity ^0.5.0;

contract CounterSpec {
	int counter;


    /**
	 * @notice modifies counter
	 * @notice postcondition counter == __verifier_old_int(counter) + 1
	*/
	function inc() public {
		require(counter > 42);
		counter = counter + 1;
	}

	function get() public view returns(int value) {
		return counter;
	}



}
