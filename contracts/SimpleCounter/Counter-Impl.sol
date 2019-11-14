pragma solidity ^0.5.0;

contract CounterImpl {
	int counter;


    /**
	 * @notice modifies counter
	*/
	function inc() public {
		counter = counter + 1;
	}


	function get() public view returns(int value) {
		return counter;
	}

}
