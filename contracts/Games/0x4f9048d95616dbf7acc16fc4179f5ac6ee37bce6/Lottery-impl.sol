pragma solidity ^0.5.0;

contract Lottery_impl {
    
    address public manager;
    address payable[] public players;
    address payable public winner;
    event Transfer(address indexed to, uint256 value);
    
    /**
        @notice modifies manager
    */
    constructor() public {
        manager = msg.sender;
    }
    
    //投注
    /**
        @notice modifies players[players.length]
        @notice modifies address(this).balance
    */
    function enter() public payable {
        //最小金额
        require(msg.value > .01 ether);
        
        players.push(msg.sender);
        
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, now, players)));
    }
    
    /**
        @notice modifies players
        @notice modifies winner
        @notice modifies address(this).balance
    */
    function pickWinner() public restricted {
        uint index = random() % players.length;
        winner =  players[index];
        winner.transfer(address(this).balance);
        emit Transfer(winner,address(this).balance);
        players = new address payable[](0);
    }
    
    modifier restricted(){
        require(msg.sender == manager);
        _;
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory){
        return players;
    }
}