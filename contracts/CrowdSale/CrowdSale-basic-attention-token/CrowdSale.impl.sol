pragma solidity >=0.5.0;

// BAT crowdsale
// Link to contract source code:
// https://github.com/brave-intl/basic-attention-token-crowdsale/blob/master/contracts/BAToken.sol

import "./original/StandardToken.sol";
import "./original/SafeMath.sol";
/**
  @notice simulation BAToken.ethFundDeposit ==  Crowdsale._wallet
  @notice simulation BAToken.fundingStartBlock == Crowdsale._openingTime
  @notice simulation BAToken.fundingEndBlock == Crowdsale._closingTime
  @notice simulation BAToken.isFinalized == Crowdsale._finalized
 */
contract BAToken is StandardToken, SafeMath {


    // metadata
    string public constant name = "Basic Attention Token";
    string public constant symbol = "BAT";
    uint256 public constant decimals = 18;
    string public version = "1.0";

    // contracts
    address payable public ethFundDeposit;      // deposit address for ETH for Brave International
    address public batFundDeposit;      // deposit address for Brave International use and BAT User Fund

    // crowdsale parameters
    bool public isFinalized;              // switched to true in operational state
    uint256 public fundingStartBlock;
    uint256 public fundingEndBlock;
    uint256 public constant batFund = 500 * (10**6) * 10**decimals;   // 500m BAT reserved for Brave Intl use
    uint256 public constant tokenExchangeRate = 6400; // 6400 BAT tokens per 1 ETH
    uint256 public constant tokenCreationCap =  1500 * (10**6) * 10**decimals;
    uint256 public constant tokenCreationMin =  675 * (10**6) * 10**decimals;


    // events
    event LogRefund(address indexed _to, uint256 _value);
    event CreateBAT(address indexed _to, uint256 _value);

    // constructor
    constructor(
        address payable _ethFundDeposit,
        address _batFundDeposit,
        uint256 _fundingStartBlock,
        uint256 _fundingEndBlock) internal
    {
      isFinalized = false;                   //controls pre through crowdsale state
      ethFundDeposit = _ethFundDeposit;
      batFundDeposit = _batFundDeposit;
      fundingStartBlock = _fundingStartBlock;
      fundingEndBlock = _fundingEndBlock;
      totalSupply = batFund;
      balances[batFundDeposit] = batFund;    // Deposit Brave Intl share
      emit CreateBAT(batFundDeposit, batFund);  // logs Brave Intl fund
    }

    /// @dev Accepts ether and creates new BAT tokens.
    function createTokens() external payable  {
      if (isFinalized) revert();
      if (block.number < fundingStartBlock) revert();
      if (block.number > fundingEndBlock) revert();
      if (msg.value == 0) revert();

      uint256 tokens = safeMult(msg.value, tokenExchangeRate); // check that we're not over totals
      uint256 checkedSupply = safeAdd(totalSupply, tokens);

      // return money if something goes wrong
      if (tokenCreationCap < checkedSupply) revert();  // odd fractions won't be found

      totalSupply = checkedSupply;
      balances[msg.sender] += tokens;  // safeAdd not needed; bad semantics to use here
      emit CreateBAT(msg.sender, tokens);  // logs token creation
    }

    /// @dev Ends the funding period and sends the ETH home
    function finalize() external {
      if (isFinalized) revert();
      if (msg.sender != ethFundDeposit) revert(); // locks finalize to the ultimate ETH owner
      if(totalSupply < tokenCreationMin) revert();      // have to sell minimum to move to operational
      if(block.number <= fundingEndBlock && totalSupply != tokenCreationCap) revert();
      // move to operational
      isFinalized = true;
      if(!ethFundDeposit.send(address(this).balance)) revert();  // send the eth to Brave International
    }

    /// @dev Allows contributors to recover their ether in the case of a failed funding campaign.
    function refund() external {
      if(isFinalized) revert();                       // prevents refund if operational
      if (block.number <= fundingEndBlock) revert(); // prevents refund until sale period is over
      if(totalSupply >= tokenCreationMin) revert();  // no refunds if we sold enough
      if(msg.sender == batFundDeposit) revert();    // Brave Intl not entitled to a refund
      uint256 batVal = balances[msg.sender];
      if (batVal == 0) revert();
      balances[msg.sender] = 0;
      totalSupply = safeSubtract(totalSupply, batVal); // extra safe
      uint256 ethVal = batVal / tokenExchangeRate;     // should be safe; previous revert()s covers edges
      emit LogRefund(msg.sender, ethVal);               // log it
      if (!msg.sender.send(ethVal)) revert();       // if you're using a contract; make sure it works with .send gas limits
    }

}
