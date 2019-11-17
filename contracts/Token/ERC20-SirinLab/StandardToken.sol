pragma solidity ^0.5.0;

import './original/SafeMath.sol';

/**
 * @title Standard ERC20 token
 *
 * @dev Implementation of the basic standard token.
 * @dev https://github.com/ethereum/EIPs/issues/20
 * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */

/**
 * @notice simulation  __verifier_eq(BasicToken.balances, ERC20_spec.balances)
 * @notice simulation __verifier_eq(StandardToken.allowed, ERC20_spec.allowances)
 */
contract StandardToken  {

  using SafeMath_spec for uint256;

  uint256 public totalSupply;

  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);

  mapping (address => mapping (address => uint256)) internal allowed;


  mapping(address => uint256) balances;

  /**
  * @dev transfer token for a specified address
  * @param to The address to transfer to.
  * @param _value The amount to be transferred.
    @notice modifies balances[msg.sender]
    @notice modifies balances[to]
  */
  //function transfer(address to, uint256 _value) public  {
  //  require(to != address(0));
  //  require(_value <= balances[msg.sender]);
//
  //  // SafeMath.sub will throw if there is not enough balance.
  //  balances[msg.sender] = balances[msg.sender].sub(_value);
  //  balances[to] = balances[to].add(_value);
  //  emit Transfer(msg.sender, to, _value);
  //}

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balance(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }


  /**
   * @dev Transfer tokens from one address to another
   * @param from address The address which you want to send tokens from
   * @param to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   * @notice modifies balances[to]
     @notice modifies balances[from]
     @notice modifies allowed[from][msg.sender]
   */
  //function transferFrom(address from, address to, uint256 _value) public {
  //  require(to != address(0));
  //  require(_value <= balances[from]);
  //  require(_value <= allowed[from][msg.sender]);
//
  //  balances[from] = balances[from].sub(_value);
  //  balances[to] = balances[to].add(_value);
  //  allowed[from][msg.sender] = allowed[from][msg.sender].sub(_value);
  //  emit Transfer(from, to, _value);
  //}

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param to The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   * @notice modifies allowed[msg.sender][to]
   */
  //function approve(address to, uint256 _value) public{
  //  allowed[msg.sender][to] = _value;
  //  emit Approval(msg.sender, to, _value);
  //}

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  /**
   * approve should be called when allowed[spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @notice modifies allowed[msg.sender][spender]
   */
  function increaseAllowance(address spender, uint _addedValue) public {
    allowed[msg.sender][spender] = allowed[msg.sender][spender].add(_addedValue);
    emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
  }

  /**
   * @notice modifies allowed[msg.sender][spender]
   */
  function decreaseAllowance(address spender, uint _subtractedValue) public  {
    uint oldValue = allowed[msg.sender][spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][spender] = 0;
    } else {
      allowed[msg.sender][spender] = oldValue.sub(_subtractedValue);
    }
    emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
  }

}
