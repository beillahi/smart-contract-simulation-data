pragma solidity ^0.5.0;


/**
  @notice simulation  Lottery$manager == Lottery_imp$manager
  @notice simulation __verifier_eq(Lottery$players, Lottery_imp$players)
 */
contract Lottery_imp {

    address public manager;
    address payable[] public players;

    mapping(address => uint) public wagerOf;

    // Assign the creator of the contract as the manager
    /**
        @notice modifies manager
    */
    constructor() public {
        manager = msg.sender;
    }

    // Enter a player into the lottery
    /**
        @notice modifies wagerOf[msg.sender]
        @notice modifies players[players.length]
        @notice modifies address(this).balance
    */
    function enter() public payable {

        // Require each player to send enough ether
        require(msg.value > 1);

        // Add sender to the list of players
        players.push(msg.sender);

        // Keep track of the player's wager
        wagerOf[msg.sender] = msg.value;
    }

    // Send the contract's total balance to a random player
    /**
        @notice modifies players
        @notice modifies address(this).balance
    */
    function pickWinner() public restricted {

        // Can only pick the winner if the array has at least one player
        require(players.length > 0);

        // Pick a random player to be the winner
        uint index = impl$random() % players.length;

        // Send the total balance to the winner
        players[index].transfer(address(this).balance);

        // Reset the array for the next game
        players = new address payable[](0);
    }

    // Generate a pseudo-random number
    function impl$random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, now, players)));
    }

    // Returns all wagers to each player without picking a winner
    /**
        @notice modifies players
        @notice modifies wagerOf
        @notice modifies address(this).balance
    */
    function cancelLottery() restricted public {
  

      for (uint i = 0; i < players.length; i++) {
        players[i].transfer(wagerOf[players[i]]);
        wagerOf[players[i]] = 0;
      }

      // Reset the array for the next game
      players = new address payable[](0);
    }

    // Get the entire list of players in the lottery
    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    // Only the manager can do the function
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }


}
