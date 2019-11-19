pragma solidity ^0.5.0;

import './original/SafeMath.sol';


/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract GlobalEcoToken {


  using SafeMath_spec for uint256;

  mapping (address => mapping (address => uint256)) allowed;


  uint256 public totalSupply;
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  mapping(address => uint256) balances;


  string public constant name = "Global Eco Token";
   
  string public constant symbol = "GECO";
    
 // address public _owner = 0x81DB2080dC1Da5f41618Ae5a340d78D1617A7CB6;
  address private _owner ;

  uint256 public INITIAL_SUPPLY = 700000000 * 1 ether;

  /**
  * @notice modifies _owner
  * @notice modifies totalSupply
  * @notice modifies balances[msg.sender]
   */
  constructor () public {
    _owner = msg.sender;
    totalSupply = INITIAL_SUPPLY;
    balances[_owner] = INITIAL_SUPPLY;
  }

  /**
  * @dev transfer token for a specified address
  * @param to The address to transfer to.
  * @param _value The amount to be transferred.
  * @notice modifies balances[to]
  * @notice modifies balances[msg.sender]
  */
  function transfer(address to, uint256 _value) public {
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[to] = balances[to].add(_value);
    emit Transfer(msg.sender, to, _value);
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of. 
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param from address The address which you want to send tokens from
   * @param to address The address which you want to transfer to
   * @param _value uint256 the amout of tokens to be transfered
   * @notice modifies balances[to]
   * @notice modifies balances[from]
   * @notice modifies allowed[from][msg.sender]
   */
  function transferFrom(address from, address to, uint256 _value) public {
    uint256 _allowance = allowed[from][msg.sender];

    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
    // require (_value <= _allowance);

    balances[to] = balances[to].add(_value);
    balances[from] = balances[from].sub(_value);
    allowed[from][msg.sender] = _allowance.sub(_value);
    emit Transfer(from, to, _value);
  }

  /**
   * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * @param to The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   * @notice modifies allowed[msg.sender][to]
   */
  function approve(address to, uint256 _value) public {

    // To change the approve amount you first have to reduce the addresses`
    //  allowance to zero by calling `approve(_spender, 0)` if it is not
    //  already 0 to mitigate the race condition described here:
    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    require((_value == 0) || (allowed[msg.sender][to] == 0));

    allowed[msg.sender][to] = _value;
    emit Approval(msg.sender, to, _value);
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifing the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

    /**
   * @dev Burns a specific amount of tokens.
   * @param _value The amount of token to be burned.
   */
  function burn(uint _value) public {
    require(_value > 0);
    address burner = msg.sender;
    balances[burner] = balances[burner].sub(_value);
    totalSupply = totalSupply.sub(_value);
    emit Burn(burner, _value);
  }

  event Burn(address indexed burner, uint indexed value);

}