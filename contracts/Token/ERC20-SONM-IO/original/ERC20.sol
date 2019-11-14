pragma solidity ^0.5.0;


/*
 * ERC20 interface
 * see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
  uint public totalSupply;
  function balance(address who) public view returns (uint);
  function allowance(address owner, address spender) public view returns (uint);

  function transfer(address to, uint value) public;
  function transferFrom(address from, address to, uint value) public;
  function approve(address spender, uint value) public;
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}