pragma solidity ^0.5.0;



 /**
 * @notice simulation (__verifier_eq(AMNToken.balances, ERC20_spec.balances) || (AMNToken.balances[AMNToken.owner] == ERC20_spec.balances[AMNToken.owner] + AMNToken.INITIAL_SUPPLY))
 * @notice simulation __verifier_eq(AMNToken.allowances, ERC20_spec.allowances)
 */
contract AMNToken {

  string  public constant name = "Amon";
  string  public constant symbol = "AMN";
  uint256 public constant INITIAL_SUPPLY = 1666666667000000000000000000;
  address public owner;

    mapping(address=>uint) public balances;
    mapping (address => mapping (address => uint)) public allowances;

  /**
    *@dev Constructor that set the token initial parameters
    @notice modifies owner
    @notice modifies balances[owner]
  */
  constructor() public {
    owner = msg.sender;
    balances[owner] = INITIAL_SUPPLY;
  }



   function balance(address account) public view returns (uint _balance) {
	    return balances[account];
   } 


   function allowance(address _owner, address beneficiary) public view returns (uint _allowance) {
	    return allowances[_owner][beneficiary];
   }


    /**
        @notice modifies balances[msg.sender]
        @notice modifies balances[to]
    */
    function transfer(address to, uint val) public {
      require(balances[msg.sender] - val >= 0);
	    balances[msg.sender] = balances[msg.sender] - val;
	    balances[to] = balances[to] + val;

    }


    /**
        @notice modifies allowances[msg.sender][to]
    */
    function approve(address to, uint val) public {
	    allowances[msg.sender][to] = val;
    }



    /**
        @notice modifies balances[from]
        @notice modifies balances[to]
        @notice modifies allowances[from][msg.sender]
    */
    function transferFrom(address from, address to, uint val) public {
      require(allowances[from][msg.sender] - val >= 0);
      require(balances[from] - val >= 0);
	    balances[from] = balances[from] - val;
	    balances[to] = balances[to] + val;
	    allowances[from][msg.sender] = allowances[from][msg.sender] - val;
    }



    /**
        @notice modifies allowances[msg.sender][spender]
    */
    function increaseAllowance(address spender, uint val) public {
	    allowances[msg.sender][spender] = allowances[msg.sender][spender] + val;
    }

    /**
        @notice modifies allowances[msg.sender][spender]
    */
    function decreaseAllowance(address spender, uint val) public {
      require(allowances[msg.sender][spender] - val >= 0);
	    allowances[msg.sender][spender] = allowances[msg.sender][spender] - val;
    }

}