pragma solidity >=0.5.0;


contract ERC20 {
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

    mapping(address=>uint) internal balances ;
    mapping (address => mapping (address => uint)) internal allowances ;

    mapping(address=>bool) internal  minters ;  // specific for Mintable-ERC20
    mapping(address=>bool) internal  burners ;  // specific for Burnable-ERC20


    /** @notice precondition msg.sender != address(0)
        @notice postcondition balances[msg.sender] == supply
        @notice modifies minters[msg.sender]
        @notice modifies balances[msg.sender] */
    constructor(uint supply) shadow$spec$Balance$Modifier1 public {
        require(balances[msg.sender] + supply >= balances[msg.sender]);
        minters[msg.sender] = true;
        mint(msg.sender, supply);
    }

    /** @notice postcondition _balance == balances[account]
    */
   function  spec_balance( address account) public view returns (uint _balance) ;

    /** @notice postcondition _allowance == allowances[owner][beneficiary]
    */
   function  spec_allowance( address owner, address beneficiary) public view returns (uint _allowance) ;


    /** @notice precondition to != address(0)
	    @notice precondition to != msg.sender
        @notice precondition  balances[to] + val >= balances[to]
	    @notice precondition  balances[msg.sender] - val >= 0
        @notice postcondition balances[to] == __verifier_old_uint(balances[to]) + val
	    @notice postcondition balances[msg.sender] == __verifier_old_uint(balances[msg.sender]) - val
        @notice modifies balances[msg.sender]
        @notice modifies balances[to]*/

    function  spec_transfer( address to, uint val) public ;


    /** @notice precondition to != address(0)
        @notice postcondition allowances[msg.sender][to] == val
        @notice modifies allowances[msg.sender][to] */

    function  spec_approve( address to, uint val) public ;



   /**  @notice precondition to != address(0)
	    @notice precondition to != from
        @notice precondition allowances[from][msg.sender] - val >= 0
	    @notice precondition  balances[to] + val >= balances[to]
	    @notice precondition  balances[from] - val >= 0
        @notice postcondition balances[to] == __verifier_old_uint(balances[to]) + val
	    @notice postcondition balances[from] == __verifier_old_uint(balances[from]) - val
        @notice postcondition allowances[from][msg.sender] == __verifier_old_uint(allowances[from][msg.sender]) - val
        @notice modifies balances[to]
        @notice modifies balances[from]
        @notice modifies allowances[from][msg.sender] */

    function  spec_transferFrom( address from, address to, uint val) public ;



   /**  @notice precondition spender != address(0)
        @notice precondition allowances[msg.sender][spender] + val >= allowances[msg.sender][spender]
        @notice postcondition allowances[msg.sender][spender] == __verifier_old_uint(allowances[msg.sender][spender]) + val
        @notice modifies allowances[msg.sender][spender] */

    function  spec_increaseAllowance( address spender, uint val) public ;



   /**  @notice precondition spender != address(0)
        @notice precondition allowances[msg.sender][spender] - val >= 0
        @notice postcondition allowances[msg.sender][spender] == __verifier_old_uint(allowances[msg.sender][spender]) - val
        @notice modifies allowances[msg.sender][spender] */

    function  spec_decreaseAllowance( address spender, uint val) public ;



   /**  @notice precondition to != address(0)
	    @notice precondition minters[msg.sender]
        @notice precondition balances[to] + val >= balances[to]
        @notice postcondition balances[to] == __verifier_old_uint(balances[to]) + val
        @notice modifies balances[to] */

    function mint(address to, uint val) internal {
	    balances[to] = balances[to] + val;
    }



   /**  @notice precondition from != address(0)
	    @notice precondition burners[msg.sender]
        @notice precondition balances[from] - val >= 0
        @notice postcondition balances[from] == __verifier_old_uint(balances[from]) - val
        @notice modifies balances[from] */

    function burn(address from, uint val) internal {
	    balances[from] = balances[from] - val;
    }

}