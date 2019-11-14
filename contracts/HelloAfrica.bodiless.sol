pragma solidity ^0.5.0;

/** @notice invariant true */
contract HelloAfrica {
   uint public shadow$spec$Balance; 
   modifier shadow$spec$Balance$Modifier {
            shadow$spec$Balance = address(this).balance - msg.value;
            _;
            shadow$spec$Balance = address(this).balance;
        } 
   modifier shadow$spec$Balance$Modifier1 {
            shadow$spec$Balance = address(this).balance;
            _;
            shadow$spec$Balance = address(this).balance;
        }

	int counter;
	// mapping (address => int) counter3;

	/**
	 * @notice modifies counter
	 * @notice postcondition counter == __verifier_old_int(counter) + i
	*/
	function  spec_inc( int i) public ;

	/**
	 * @notice modifies counter
	 * @notice postcondition counter == __verifier_old_int(counter) - 1
	*/
	function  spec_dec( ) public ;

    /**
	 * @notice postcondition value == counter
	 */
	function  spec_get( ) public view returns(int value) ;
}
