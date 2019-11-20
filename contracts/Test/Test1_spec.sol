pragma solidity ^0.5.0;

/**

 */
contract Test1_spec {
    int a1;
	int b1;


	/**

	 */
	function mainMethod() public {
		a1 = a1 + b1;
	}

	function getA() public view returns(int) {
		return a1;
	}

	function setB(int b) public {
		b1 = b;
	}
}