pragma solidity >=0.5.0;

import './original/SafeMath.sol';


/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20Mintable}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20_spec {

    using SafeMath_spec for uint256;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint value);

    mapping(address=>uint) internal balances ;
    mapping (address => mapping (address => uint)) internal allowances ;

  
    /** @notice precondition msg.sender != address(0)
        @notice postcondition balances[msg.sender] == supply
        @notice modifies balances[msg.sender]
    */
    constructor(uint supply) public {
        balances[msg.sender] = balances[msg.sender] + supply;
    }


    /** @notice postcondition _balance == balances[account]
    */
   function balance(address account) public view returns (uint _balance) {
	    return balances[account];
   }

    /** @notice postcondition _allowance == allowances[owner][beneficiary]
    */
   function allowance(address owner, address beneficiary) public view returns (uint _allowance) {
	    return allowances[owner][beneficiary];
   }


    /** @notice precondition to != address(0)
        @notice precondition msg.sender != address(0)
	    @notice precondition to != msg.sender
        @notice precondition  balances[to] + val >= balances[to]
	    @notice precondition  balances[msg.sender] >= val
        @notice postcondition balances[to] == __verifier_old_uint(balances[to]) + val
	    @notice postcondition balances[msg.sender] == __verifier_old_uint(balances[msg.sender]) - val
        @notice modifies balances[msg.sender]
        @notice modifies balances[to]
    */
    function transfer(address to, uint val) public {
        require(msg.sender != address(0));
        require(to != address(0));
	    balances[msg.sender] = balances[msg.sender].sub(val);
	    balances[to] = balances[to].add(val);
    }


    /** @notice precondition to != address(0)
        @notice precondition msg.sender != address(0)
        @notice postcondition allowances[msg.sender][to] == val
        @notice modifies allowances[msg.sender][to]
    */
    function approve(address to, uint val) public {
        require(msg.sender != address(0));
        require(to != address(0));
	    allowances[msg.sender][to] = allowances[msg.sender][to] = val;
        emit Approval(msg.sender, to, val);
    }



   /**  @notice precondition to != address(0)
	    @notice precondition to != from
        @notice precondition allowances[from][msg.sender] >= val
	    @notice precondition  balances[to] + val >= balances[to]
	    @notice precondition  balances[from] >= val
        @notice postcondition balances[to] == __verifier_old_uint(balances[to]) + val
	    @notice postcondition balances[from] == __verifier_old_uint(balances[from]) - val
        @notice postcondition allowances[from][msg.sender] == __verifier_old_uint(allowances[from][msg.sender]) - val
        @notice modifies balances[to]
        @notice modifies balances[from]
        @notice modifies allowances[from][msg.sender] */

    function transferFrom(address from, address to, uint val) public {
        require(msg.sender != address(0));
        require(to != address(0));
        require(from != address(0));
	    balances[from] = balances[from].sub(val);
	    balances[to] = balances[to].add(val);
	    allowances[from][msg.sender] = allowances[from][msg.sender].sub(val);
    }



   /**  @notice precondition spender != address(0)
        @notice precondition msg.sender != address(0)
        @notice precondition allowances[msg.sender][spender] + val >= allowances[msg.sender][spender]
        @notice postcondition allowances[msg.sender][spender] == __verifier_old_uint(allowances[msg.sender][spender]) + val
        @notice modifies allowances[msg.sender][spender] */

    function increaseAllowance(address spender, uint val) public {
        require(msg.sender != address(0));
        require(spender != address(0));
	    allowances[msg.sender][spender] = allowances[msg.sender][spender].add(val);
        emit Approval(msg.sender, spender, allowances[msg.sender][spender]);
    }



   /**  @notice precondition spender != address(0)
        @notice precondition msg.sender != address(0)
        @notice precondition allowances[msg.sender][spender] >= val
        @notice postcondition allowances[msg.sender][spender] == __verifier_old_uint(allowances[msg.sender][spender]) - val
        @notice modifies allowances[msg.sender][spender] */

    function decreaseAllowance(address spender, uint val) public {
        require(msg.sender != address(0));
        require(spender != address(0));
	    allowances[msg.sender][spender] = allowances[msg.sender][spender].sub(val);
        emit Approval(msg.sender, spender, allowances[msg.sender][spender]);
    }


  /**   @notice precondition to != address(0)
        @notice precondition balances[to] + val >= balances[to]
        @notice postcondition balances[to] == __verifier_old_uint(balances[to]) + val
        @notice modifies balances[to]
    */
    function mint(address to, uint val) public {
        require(to != address(0));
	    balances[to] = balances[to].add(val);
        emit Transfer(address(0), to, val);
    }



   /**  @notice precondition from != address(0)
        @notice precondition balances[from] >= val
        @notice postcondition balances[from] == __verifier_old_uint(balances[from]) - val
        @notice modifies balances[from] 
    */
    function burn(address from, uint val) public {
        require(from != address(0));
	    balances[from] = balances[from].sub(val);
        emit Transfer(from, address(0), val);
    }
}