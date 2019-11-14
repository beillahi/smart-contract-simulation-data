pragma solidity ^0.5.0;


contract Escrow_spec {
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

    mapping(address=>uint) internal deposits ;
 

    /** @notice precondition payee != address(0)
	    @notice precondition msg.value > 0
	    @notice precondition  address(this) != msg.sender
		@notice precondition payee != address(this)
	    @notice precondition  deposits[payee] + msg.value >= deposits[payee]
	    @notice precondition  shadow$spec$Balance + msg.value >= shadow$spec$Balance
     	@notice postcondition deposits[payee] == __verifier_old_uint(deposits[payee]) + msg.value
		@notice postcondition shadow$spec$Balance == __verifier_old_uint(shadow$spec$Balance) + msg.value
		@notice modifies deposits[payee]
		@notice modifies address(this).balance
        @notice modifies shadow$spec$Balance

	*/
    function  spec_deposit( address payee) public payable ;


    /** @notice precondition payee != address(0)
        @notice precondition  deposits[payee] > 0
		@notice precondition  payee != address(this)
        @notice postcondition deposits[payee] == 0
		@notice postcondition shadow$spec$Balance >= __verifier_old_uint(shadow$spec$Balance) - __verifier_old_uint(deposits[payee])
		@notice modifies deposits[payee]
		@notice modifies address(this).balance
        @notice modifies shadow$spec$Balance

		@notice modifies payee.balance
	*/

    function  spec_withdraw( address payable payee) public ;

	/** @notice precondition payee != address(0)
		@notice postcondition amount == deposits[payee]
	*/
	function  spec_depositsOf( address payee) public view returns(uint amount) ;

}