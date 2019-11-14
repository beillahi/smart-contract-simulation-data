pragma solidity >=0.5.0;

// OpenZeppelin crowdsale
// Link to contract source code:
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/crowdsale

//import '../../Token/ERC20-openzeppelin/ERC20.spec.sol';

import './original/ERC20.spec.sol';
import './original/SafeMath.sol';

contract Crowdsale_specB {

    using SafeMath_spec for uint256;
    //using SafeERC20 for IERC20;

    // The token being sold
    ERC20_spec private _token;

    // The token being sold
    address private _tokenOwner;

    // Address where funds are collected
    address payable private _wallet;

    // How many token units a buyer gets per wei.
    // The rate is the conversion between wei and the smallest and indivisible token unit.
    // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
    // 1 wei will give you 1 unit, or 0.001 TOK.
    uint256 private _rate;

    // Amount of wei raised
    uint256 private _weiRaised;

    bool private _finalized;

    uint256 private _openingTime;
    uint256 private _closingTime;


    constructor (address payable wallet, address token, uint256 openingTime, uint256 closingTime) public {
        //require(rate > 0, "Crowdsale: rate is 0");
        require(wallet != address(0), "Crowdsale: wallet is the zero address");
        require(address(token) != address(0), "Crowdsale: token is the zero address");
        require(openingTime >= now, "TimedCrowdsale: opening time is before current time");
        // solhint-disable-next-line max-line-length
        require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");

        _openingTime = openingTime;
        _closingTime = closingTime;

        _rate = 6400; // 6400 tokens per 1 ETH
        _wallet = wallet;
        _token = ERC20_spec(token);
    }


    /**
     * @notice modifies _finalized
    */
    function finalize() public {
        require(!_finalized, "FinalizableCrowdsale: already finalized");

        _finalized = true;

    }

    /**
     * @return true if the crowdsale is finalized, false otherwise.
    */
    function finalized() public view returns (bool) {
        return _finalized;
    }

    /**
     * @return the crowdsale opening time.
     */
    function openingTime() public view returns (uint256) {
        return _openingTime;
    }

    /**
     * @return the crowdsale closing time.
     */
    function closingTime() public view returns (uint256) {
        return _closingTime;
    }

    /**
     * @return true if the crowdsale is open, false otherwise.
     */
    function isOpen() public view returns (bool) {
        // solhint-disable-next-line not-rely-on-time
        return block.number >= _openingTime && block.number <= _closingTime;
    }

    /**
     * @dev Checks whether the period in which the crowdsale is open has already elapsed.
     * @return Whether crowdsale period has elapsed
     */
    function hasClosed() public view returns (bool) {
        // solhint-disable-next-line not-rely-on-time
        return block.number > _closingTime;
    }



    /**
     * @return the address where funds are collected.
     */
    function wallet() public view returns (address payable) {
        return _wallet;
    }

    /**
     * @return the number of token units a buyer gets per wei.
     */
    function getRate() public view returns (uint256) {
        return _rate;
    }

    /**
     * @return the amount of wei raised.
     */
    function weiRaised() public view returns (uint256) {
        return _weiRaised;
    }

    /**
        * @notice precondition msg.sender != address(0)
        * @notice precondition msg.value != 0
        * @notice precondition block.number >= _openingTime && block.number <= _closingTime
        * @notice precondition _finalized
        * @notice postcondition address(this).balance == __verifier_old_uint(address(this).balance) + msg.value
    */
    function createTokens() external payable  {
        buyTokens(msg.sender);
    }

    /**
     * @dev low level token purchase ***DO NOT OVERRIDE***
     * @param beneficiary Recipient of the token purchase
     */

    /**
        * @notice precondition beneficiary != address(0)
        * @notice precondition msg.value != 0
        * @notice precondition block.number >= _openingTime && block.number <= _closingTime
        * @notice precondition _finalized
        * @notice postcondition address(this).balance == __verifier_old_uint(address(this).balance) + msg.value
    */
    function buyTokens(address beneficiary) public  payable {
        require(!_finalized, "FinalizableCrowdsale: already finalized");
        require(isOpen(), "TimedCrowdsale: not open");
        uint256 weiAmount = msg.value;
        _preValidatePurchase(beneficiary, weiAmount);

        // calculate token amount to be created
        uint256 tokens = _getTokenAmount(weiAmount);

        // update state
         _weiRaised = _weiRaised.add(weiAmount);


        _processPurchase(beneficiary, tokens);

        _updatePurchasingState(beneficiary, weiAmount);

        _forwardFunds();
        _postValidatePurchase(beneficiary, weiAmount);
    }

    /**
     * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
     * Use `super` in contracts that inherit from Crowdsale to extend their validations.
     * Example from CappedCrowdsale.sol's _preValidatePurchase method:
     *     super._preValidatePurchase(beneficiary, weiAmount);
     *     require(weiRaised().add(weiAmount) <= cap);
     * @param beneficiary Address performing the token purchase
     * @param weiAmount Value in wei involved in the purchase
     */
    /**
        * @notice precondition beneficiary != address(0)
        * @notice precondition weiAmount != 0
    */
    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
        require(weiAmount != 0, "Crowdsale: weiAmount is 0");
    }

    /**
     * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
     * conditions are not met.
     * @param beneficiary Address performing the token purchase
     * @param weiAmount Value in wei involved in the purchase
     */
    function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
     * its tokens.
     * @param beneficiary Address performing the token purchase
     * @param tokenAmount Number of tokens to be emitted
     */
    /**
        * @notice precondition beneficiary != address(0)
        * @notice precondition tokenAmount != 0
        * @notice precondition  _token.balances(address(this)) >= tokenAmount
        * @notice postcondition _token.balances(beneficiary) == __verifier_old_uint(_token.balances(beneficiary)) + tokenAmount
        * @notice postcondition _token.balances(address(this)) == __verifier_old_uint(_token.balances(address(this))) - tokenAmount
    */
    function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
        _token.transfer(beneficiary, tokenAmount);
    }

    /**
     * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
     * tokens.
     * @param beneficiary Address receiving the tokens
     * @param tokenAmount Number of tokens to be purchased
     */
    /**
        * @notice precondition beneficiary != address(0)
        * @notice precondition tokenAmount != 0
        * @notice precondition  _token.balances(address(this)) >= tokenAmount
        * @notice postcondition _token.balances(beneficiary) == __verifier_old_uint(_token.balances(beneficiary)) + tokenAmount
        * @notice postcondition _token.balances(address(this)) == __verifier_old_uint(_token.balances(address(this))) - tokenAmount
    */
    function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
        _deliverTokens(beneficiary, tokenAmount);
    }

    /**
     * @dev Override for extensions that require an internal state to check for validity (current user contributions,
     * etc.)
     * @param beneficiary Address receiving the tokens
     * @param weiAmount Value in wei involved in the purchase
     */
    function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
     * @dev Override to extend the way in which ether is converted to tokens.
     * @param weiAmount Value in wei to be converted into tokens
     * @return Number of tokens that can be purchased with the specified _weiAmount
     */
    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
        return weiAmount.mul(_rate);
    }

    /**
     * @dev Determines how ETH is stored/forwarded on purchases.
     */
    /**
        * @notice postcondition address(this).balance == __verifier_old_uint(address(this).balance) + msg.value
    */
    function _forwardFunds() public payable {
        _wallet.transfer(msg.value);
    }

}