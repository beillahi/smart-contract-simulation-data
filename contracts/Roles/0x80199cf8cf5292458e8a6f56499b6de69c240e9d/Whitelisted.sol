pragma solidity ^0.5.0;



/// @title CCWhitelist contract
contract CCWhitelist  {
    
    mapping (address => bool) public whitelisted;


    address public owner;

      /**
            @notice modifies owner
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

    /// @dev Whitelist a single address
    /// @param account Address to be whitelisted
    /// @notice modifies whitelisted[account]
    function addWhitelisted(address account) public onlyOwner {
        require(!whitelisted[account]);
        whitelisted[account] = true;
    }

    /// @dev Remove an address from whitelist
    /// @param account Address to be removed from whitelist
    /// @notice modifies whitelisted[account]
    function removeWhitelisted(address account) public onlyOwner {
        require(whitelisted[account]);
        whitelisted[account] = false;
    }

    /// @dev Whitelist array of addresses
    /// @param arr Array of addresses to be whitelisted
    function bulkWhitelist(address[] memory arr) public onlyOwner {
        for (uint i = 0; i < arr.length; i++) {
            whitelisted[arr[i]] = true;
        }
    }

    /// @dev Check if address is whitelisted
    /// @param addr Address to be checked if it is whitelisted
    /// @return Is address whitelisted?
    function isWhitelisted(address addr) public view returns (bool) {
        return whitelisted[addr];
    }  
}