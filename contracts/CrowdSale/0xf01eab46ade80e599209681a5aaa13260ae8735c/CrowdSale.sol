

import './original/ERC20.spec.sol';
import './original/SafeMath.sol';

/**
 * @title Crowdsale
 * @dev Crowdsale is a base contract for managing a token crowdsale.
 * Crowdsales have a start and end timestamps, where investors can make
 * token purchases and the crowdsale will assign them tokens based
 * on a token per ETH rate. Funds collected are forwarded to a wallet
 * as they arrive.
 */
contract Crowdsale {
  using SafeMath_spec for uint256;

  // The token being sold
  ERC20_spec public token;

  // start and end timestamps where investments are allowed (both inclusive)
  uint256 public startTime;
  uint256 public endTime;

  // address where funds are collected
  address payable public wallet;

  // how many token units a buyer gets per wei
  uint256 public rate;

  // amount of raised money in wei
  uint256 public weiRaised;

  /**
   * event for token purchase logging
   * @param purchaser who paid for the tokens
   * @param beneficiary who got the tokens
   * @param value weis paid for purchase
   * @param amount amount of tokens purchased
   */
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);

  /**
    * @notice modifies startTime
    * @notice modifies endTime
    * @notice modifies rate
    * @notice modifies wallet
    * @notice modifies token
    */
  constructor (uint256 _rate, address payable _wallet, address _token, uint256 _startTime, uint256 _endTime) public {
    //require(_startTime >= now);
    //require(_endTime >= _startTime);
    require(_rate > 0);
    require(_wallet != address(0));

    token = ERC20_spec(_token);
    startTime = _startTime;
    endTime = _endTime;
    rate = _rate;
    wallet = _wallet;
  }

  // low level token purchase function
  /**
    * @notice modifies weiRaised
    * @notice modifies address(this).balance
    * @notice modifies wallet.balance
   */
  function buyTokens(address beneficiary) public payable {
    require(beneficiary != address(0));
    require(validPurchase());

    uint256 weiAmount = msg.value;

    // calculate token amount to be created
    uint256 tokens = getTokenAmount(weiAmount);

    // update state
    weiRaised = weiRaised.add(weiAmount);

    //token.mint(beneficiary, tokens);
    emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);

    forwardFunds();
  }

  // @return true if crowdsale event has ended
  function hasEnded() public view returns (bool) {
    return now > endTime;
  }


  // Override this method to have a way to add business logic to your crowdsale when buying
  function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
    return weiAmount.mul(rate);
  }

  // send ether to the fund collection wallet
  // override to create custom fund forwarding mechanisms
  /**
    * @notice modifies wallet.balance
    * @notice modifies address(this).balance
   */
  function forwardFunds() public payable {
    wallet.transfer(msg.value);
  }

  // @return true if the transaction can buy tokens
  function validPurchase() internal view returns (bool) {
    bool withinPeriod = now >= startTime && now <= endTime;
    bool nonZeroPurchase = msg.value != 0;
    return withinPeriod && nonZeroPurchase;
  }


    /**
     * @return the address where funds are collected.
     */
    function getwallet() public view returns (address payable) {
        return wallet;
    }

    /**
     * @return the number of token units a buyer gets per wei.
     */
    function getRate() public view returns (uint256) {
        return rate;
    }

    /**
     * @return the amount of wei raised.
     */
    function getweiRaised() public view returns (uint256) {
        return weiRaised;
    }


        /**
     * @return the crowdsale closing time.
     */
    function closingTime() public view returns (uint256) {
        return endTime;
    }


    function openingTime() public view returns (uint256) {
        return startTime;
    }

}