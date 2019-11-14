pragma solidity >=0.5.0;

// link to the contract source code
// https://github.com/FCKOfficial/FCK-contracts/blob/master/dice/fck.com%20Sol


 /**
 * @notice simulation  __verifier_eq(FckDice.bets, Dice.bets)
 */
contract FckDice {


    uint public constant HOUSE_EDGE_OF_TEN_THOUSAND = 98;
    uint public constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0003 ether;

    uint public constant MIN_JACKPOT_BET = 0.1 ether;

    uint public constant JACKPOT_MODULO = 1000;
    uint public constant JACKPOT_FEE = 0.001 ether;

    uint constant MIN_BET = 0.01 ether;
    uint constant MAX_AMOUNT = 300000 ether;

    uint constant MAX_MODULO = 216;

    uint constant MAX_MASK_MODULO = 216;

    uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;

    uint constant BET_EXPIRATION_BLOCKS = 250;


    uint constant POPCNT_MULT = 0x0000000000002000000000100000000008000000000400000000020000000001;
    uint constant POPCNT_MASK = 0x0001041041041041041041041041041041041041041041041041041041041041;
    uint constant POPCNT_MODULO = 0x3F;
    uint constant MASK40 = 0xFFFFFFFFFF;
    uint constant MASK_MODULO_40 = 40;

    uint128 public maxProfit;

    uint128 public jackpotSize;

    uint128 public lockedInBets;

    struct FCKBet {
        uint80 amount;
        uint8 modulo;
        uint8 rollUnder;
        address payable gambler;
        uint40 placeBlockNumber;
        uint216 mask;
    }

    mapping(uint => FCKBet) internal bets;


    function increaseJackpot(uint increaseAmount) external  {
        require(increaseAmount <= address(this).balance, "Increase amount larger than balance.");
        require(jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
        jackpotSize += uint128(increaseAmount);
    }


    function placeBet(uint betId, uint modulo, uint betMask) external payable {
        // Check that the bet is in 'clean' state.
        FCKBet storage bet = bets[betId];
        require(bet.gambler == address(0), "Bet should be in a 'clean' state.");

        // Validate input data ranges.
        require(modulo >= 2 && modulo <= MAX_MODULO, "Modulo should be within range.");
        require(msg.value >= MIN_BET && msg.value <= MAX_AMOUNT, "Amount should be within range.");
        require(betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");

        uint rollUnder;
        uint mask;

        if (modulo <= MASK_MODULO_40) {
            rollUnder = ((betMask * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
            mask = betMask;
        } else if (modulo <= MASK_MODULO_40 * 2) {
            rollUnder = getRollUnder(betMask, 2);
            mask = betMask;
        } else if (modulo == 100) {
            require(betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
            rollUnder = betMask;
        } else if (modulo <= MASK_MODULO_40 * 3) {
            rollUnder = getRollUnder(betMask, 3);
            mask = betMask;
        } else if (modulo <= MASK_MODULO_40 * 4) {
            rollUnder = getRollUnder(betMask, 4);
            mask = betMask;
        } else if (modulo <= MASK_MODULO_40 * 5) {
            rollUnder = getRollUnder(betMask, 5);
            mask = betMask;
        } else if (modulo <= MAX_MASK_MODULO) {
            rollUnder = getRollUnder(betMask, 6);
            mask = betMask;
        } else {
            require(betMask > 0 && betMask <= modulo, "High modulo range, betMask larger than modulo.");
            rollUnder = betMask;
        }

        uint possibleWinAmount;
        uint jackpotFee;

        (possibleWinAmount, jackpotFee) = getDiceWinAmount(msg.value, modulo, rollUnder);

        require(possibleWinAmount <= msg.value + maxProfit, "maxProfit limit violation.");

        lockedInBets += uint128(possibleWinAmount);
        jackpotSize += uint128(jackpotFee);

        require(jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");

        bet.amount = uint80(msg.value);
        bet.modulo = uint8(modulo);
        bet.rollUnder = uint8(rollUnder);
        bet.placeBlockNumber = uint40(block.number);
        bet.mask = uint216(mask);
        bet.gambler = msg.sender;
    }


    function getRollUnder(uint betMask, uint n) private pure returns (uint rollUnder) {
        uint _betMask = betMask;
        rollUnder += (((_betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
        for (uint i = 1; i < n; i++) {
            _betMask = _betMask >> MASK_MODULO_40;
            rollUnder += (((_betMask & MASK40) * POPCNT_MULT) & POPCNT_MASK) % POPCNT_MODULO;
        }
        return rollUnder;
    }


    function getDiceWinAmount(uint amount, uint modulo, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
        require(0 < rollUnder && rollUnder <= modulo, "Win probability out of range.");

        jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;

        uint houseEdge = amount * HOUSE_EDGE_OF_TEN_THOUSAND / 10000;

        if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
            houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
        }

        require(houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");

        winAmount = (amount - houseEdge - jackpotFee) * modulo / rollUnder;
    }



    /**
        notice postcondition bets[betId].modulo != 100
        notice postcondition bets[betId].modulo <= MAX_MASK_MODULO
        notice postcondition (_dice & bets[betId].mask != 0 and amount >= MIN_JACKPOT_BET and (_dice \div modulo) \div JACKPOT\_MODULO == 0) ==> bets[commit].gambler.balance == bets[commit].gambler.balance + jackpotSize + getDiceWinAmount(bets[commit].amount, bets[commit].modulo, bets[commit].rollUnder)
        notice postcondition lockedInBets -= getDiceWinAmount(bets[betId].amount, bets[betId].modulo, bets[betId].rollUnder) \land jackpotSize = 0)$$
    */
    function settleBet(uint betId, uint _dice) public {

        FCKBet storage bet = bets[betId];
        uint placeBlockNumber = bet.placeBlockNumber;

        // Check that bet has not expired yet (see comment to BET_EXPIRATION_BLOCKS).
        require(block.number > placeBlockNumber, "settleBet in the same block as placeBet, or before.");
        require(block.number <= placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");

        // Fetch bet parameters into local variables (to save gas).
        uint amount = bet.amount;
        uint modulo = bet.modulo;
        uint rollUnder = bet.rollUnder;
        address payable gambler = bet.gambler;

        // Check that bet is in 'active' state.
        require(amount != 0, "Bet should be in an 'active' state");

        // Move bet into 'processed' state already.
        bet.amount = 0;

        uint dice = _dice;

        uint diceWinAmount;
        uint _jackpotFee;
        (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, modulo, rollUnder);

        uint diceWin = 0;
        uint jackpotWin = 0;

        // Determine dice outcome.
        if ((modulo != 100) && (modulo <= MAX_MASK_MODULO)) {
            // For small modulo games, check the outcome against a bit mask.
            if (dice & bet.mask != 0) {
                diceWin = diceWinAmount;
            }
        } else {
            // For larger modulos, check inclusion into half-open interval.
            if (dice < rollUnder) {
                diceWin = diceWinAmount;
            }
        }

        // Unlock the bet amount, regardless of the outcome.
        lockedInBets -= uint128(diceWinAmount);

        // Roll for a jackpot (if eligible).
        if (amount >= MIN_JACKPOT_BET) {
            // The second modulo, statistically independent from the "main" dice roll.
            // Effectively you are playing two games at once!
            uint jackpotRng = (dice / modulo) % JACKPOT_MODULO;

            // Bingo!
            if (jackpotRng == 0) {
                jackpotWin = jackpotSize;
                jackpotSize = 0;
            }
        }

        // Send the funds to gambler
        gambler.transfer(diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin);
    }


    function refundBet(uint commit) external {
        // Check that bet is in 'active' state.
        FCKBet storage bet = bets[commit];
        uint amount = bet.amount;

        require(amount != 0, "Bet should be in an 'active' state");

        // Check that bet has already expired.
        require(block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");

        // Move bet into 'processed' state, release funds.
        bet.amount = 0;

        uint diceWinAmount;
        uint jackpotFee;
        (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.modulo, bet.rollUnder);

        lockedInBets -= uint128(diceWinAmount);
        if (jackpotSize >= jackpotFee) {
            jackpotSize -= uint128(jackpotFee);
        }

        // Send the refund.
        bet.gambler.transfer(amount);
    }


}