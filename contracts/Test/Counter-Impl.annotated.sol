pragma solidity ^0.5.0;


/// @notice simulation true
contract CounterImpl {
	int counter;


    /**
	 * @notice modifies counter
	*/
	function inc() public returns (int _counter) {
		counter = counter + 1;
        return counter;
	}


	function get() public view returns(int value) {
		return counter;
	}

}
