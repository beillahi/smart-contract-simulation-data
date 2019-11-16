pragma solidity ^0.5.0;

/**
 * @title ModulumInvestorsWhitelist
 * @dev ModulumInvestorsWhitelist is a smart contract which holds and manages
 * a list whitelist of investors allowed to participate in Modulum ICO.
 * 
*/
contract ModulumInvestorsWhitelist  {

  mapping (address => bool) public _isWhitelisted;

   address public owner;

   /**
   * @dev Contructor
   * @notice modifies owner
     */
      constructor() public {
        owner = msg.sender;
      }

      modifier onlyOwner() {
        if (msg.sender != owner) {
          revert();
        }
        _;
      }
  /**
   * @dev Add a new investor to the whitelist
   * @notice modifies _isWhitelisted[account]
   */
    function addWhitelisted(address account) public onlyOwner {
    require(account != address(0));
    require(!_isWhitelisted[account]);
    _isWhitelisted[account] = true;
  }

  /**
   * @dev Remove an investor from the whitelist
   * @notice modifies _isWhitelisted[account]
   */
    function removeWhitelisted(address account) public onlyOwner {
    require(account != address(0));
    require(_isWhitelisted[account]);
    _isWhitelisted[account] = false;
  }

  /**
   * @dev Test whether an investor
   */
  function isWhitelisted(address account) view public returns (bool result) {
    return _isWhitelisted[account];
  }
}