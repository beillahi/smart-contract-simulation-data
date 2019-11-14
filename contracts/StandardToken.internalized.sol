pragma solidity ^0.5.0;


//import '/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/original/ERC20.sol';
import '/home/beillahi/Desktop/solidity/smart-contract-explorer/resources/contracts/original/SafeMath-SONM-IO.sol';


// Link to contract source code:
// https://github.com/JackBekket/escrow-eth/blob/master/contracts/token/StandardToken.sol



/**
 * Standard ERC20 token
 *
 * https://github.com/ethereum/EIPs/issues/20
 * Based on code by FirstBlood:
 * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */

/**
 * @notice simulation  __verifier_eq(StandardToken.balances, ERC20_spec.balances)
 * @notice simulation __verifier_eq(StandardToken.allowed, ERC20_spec.allowances)
 */
contract StandardToken is  SafeMath {

  mapping(address => uint) balances;
  mapping (address => mapping (address => uint)) allowed;

  uint internal totalSupply;

  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);

   /**
        @notice modifies balances[msg.sender]
        @notice modifies balances[to]
   */
  function transfer(address to, uint _value) internal {
    balances[msg.sender] = safeSub(balances[msg.sender], _value);
    balances[to] = safeAdd(balances[to], _value);
    emit Transfer(msg.sender, to, _value);
  }


   /**
        @notice modifies balances[from]
        @notice modifies balances[to]
        @notice modifies allowed[from][msg.sender]
   */
  function transferFrom(address from, address to, uint _value) internal {
    uint _allowance = allowed[from][msg.sender];
    
    balances[to] = safeAdd(balances[to], _value);
    balances[from] = safeSub(balances[from], _value);
    allowed[from][msg.sender] = safeSub(_allowance, _value);
    emit Transfer(from, to, _value);
  }

  function balance(address _owner) internal view returns (uint) {
    return balances[_owner];
  }

 
    /**
        @notice modifies allowed[msg.sender]
   */
  function approve(address _spender, uint _value) internal {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
  }

  function allowance(address _owner, address _spender) internal view returns (uint) {
    return allowed[_owner][_spender];
  }

}