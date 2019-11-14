pragma solidity ^0.5.0;

contract Lottery {
    address public manager;
    address payable[] public players;
    
    /**
        @notice postcondition manager == msg.sender
        @notice modifies manager
    */
    constructor() public {
        manager = msg.sender;
    }
    
    /**
        @notice precondition msg.value > 1
        @notice postcondition players[players.length - 1] = msg.sender
        @notice postcondition address(this).balance == __verifier_old_uint(address(this).balance) + msg.value
        @notice postcondition players.length == __verifier_old_uint(players.length) + 1
        @notice modifies players[players.length - 1]
        @notice modifies address(this).balance
    */
    function enter() public payable {
        require(msg.value > 1);
        
        players.push(msg.sender); 
    }
    
    function spec$random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, now, players)));
    }
    
    /**
        @notice precondition players.length > 0
        @notice precondition manager == msg.sender
        @notice postcondition __verifier_eq(players, new address payable[](0))
        @notice postcondition address(this).balance == 0
        @notice modifies players
        @notice modifies address(this).balance
    */
    function pickWinner() public restricted {

        require(players.length > 0);
        uint index = spec$random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0);
        
    }
    
    modifier restricted() {
        require(manager == msg.sender);
        _;
    }

    /**
        @notice postcondition __verifier_eq(val, players)
    */
    function getPlayers() public view returns(address payable[] memory val){
        return players;
    }
 }