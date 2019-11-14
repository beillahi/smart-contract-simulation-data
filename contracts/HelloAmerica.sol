pragma solidity ^0.5.0;

contract HelloAmerica {

	int counter;

	function increment() public {
		counter ++;
	}

	function get() public view returns(int) {
		return counter;
	}
}
