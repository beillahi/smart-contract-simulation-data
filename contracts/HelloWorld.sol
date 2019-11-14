pragma solidity ^0.5.0;

/**
 * @notice simulation HelloWorld.total == HelloAfrica.counter
 * @notice simulation HelloWorld.counter == HelloAfrica.counter
 */
contract HelloWorld {
	int total;

	int counter;

	/**
	 * @notice modifies total
	 * @notice modifies counter
	 */
	function inc(int i) public {
		counter += i;
		total += i;
	}

	/**
	 * @notice modifies total
	 * @notice modifies counter
	 */
	function dec() public {
		counter --;
		total --;
	}

	function get() public view returns(int value) {
		return counter;
	}
}
