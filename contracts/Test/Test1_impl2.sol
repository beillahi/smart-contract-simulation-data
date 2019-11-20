pragma solidity ^0.5.0;

/**

 */
contract Test1_impl {
    int a2;
	int b2;

   	constructor () public {
        b2 = 7;
    }

	/**

	 */
	function mainMethod() public {
		a2 = a2 - b2/7 + 1;
	}

	function getA() public view returns(int) {
		return a2;
	}

	function setB(int b) public {
		b2 = -7 * b + 7;
	}
}