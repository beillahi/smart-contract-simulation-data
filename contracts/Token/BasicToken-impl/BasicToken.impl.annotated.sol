pragma solidity >=0.5.0;

// Link to contract source code:
// https://github.com/sirin-labs/crowdsale-smart-contract/blob/master/contracts/token/BasicToken.sol

 /**
 * @notice simulation __verifier_eq(BasicToken.balances, BasicToken_spec.balances)
 * @notice simulation __verifier_eq(BasicToken.allowances, BasicToken_spec.allowances)
 */
/// @notice simulation __verifier_eq(BasicToken$balances, BasicToken_spec$balances) && __verifier_eq(BasicToken$allowances, BasicToken_spec$allowances)
contract BasicToken {

    mapping(address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowances ;


    /** 
        @notice modifies balances[msg.sender]
        @notice modifies balances[_to]
    */
    function transfer(address _to, uint256 _value) public returns (bool)
    {
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] = balances[_to] + _value;
        return true;
    }

    /**
        @notice postcondition bal == balances[_owner]
    */
    function balance(address _owner) public view returns (uint256 bal)
    {
        return balances[_owner];
    }

    /**
        @notice postcondition allowed == allowances[_owner][spender]
    */
    function allowance(address _owner, address spender) public view returns (uint256 allowed)
    {
        return allowances[_owner][spender];
    }


}