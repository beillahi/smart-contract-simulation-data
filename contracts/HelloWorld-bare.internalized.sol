pragma solidity ^0.5.0;

/**
 * @notice simulation HelloWorld.total == HelloAfrica.counter
 */
contract HelloWorld {
	int total;

	int counter;

	/**
	 * @notice modifies total
	 * @notice modifies counter
	 */
	function inc(int i) internal {
		counter += i;
		total += i;
	}

	/**
	 * @notice modifies total
	 * @notice modifies counter
	 */
	function dec() internal {
		counter --;
		total --;
	}

	function get() internal view returns(int value) {
		return counter;
	}
}
