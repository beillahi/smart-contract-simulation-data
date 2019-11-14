pragma solidity ^0.5.0;

/** @notice invariant true */
contract HelloAfrica {

	int counter;
	// mapping (address => int) counter3;

	/**
	 * @notice modifies counter
	 * @notice postcondition counter == __verifier_old_int(counter) + i
	*/
	function inc(int i) public {
		counter += i;
	}

	/**
	 * @notice modifies counter
	 * @notice postcondition counter == __verifier_old_int(counter) - 1
	*/
	function dec() public {
		counter --;
	}

    /**
	 * @notice postcondition value == counter
	 */
	function get() public view returns(int value) {
		return counter;
	}
}
