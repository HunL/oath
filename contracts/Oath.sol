pragma solidity ^0.4.23;

library SafeMath {

    /**
    * @dev Multiplies two numbers, throws on overflow.
    */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        assert(c / a == b);
        return c;
    }

    /**
    * @dev Integer division of two numbers, truncating the quotient.
    */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    /**
    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
    */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    /**
    * @dev Adds two numbers, throws on overflow.
    */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}

contract Oath {
    /**
    * Our owner and witnesses
    */
    address public owner;

    address public witnesses1;
    address public witnesses2;

    bool public witnesses1Voted;
    bool public witnesses2Voted;

    uint private witnesses1Deposit;
    uint private witnesses2Deposit;

    bool public oathFinished;
    address public theWinner;
    uint gains;

    /**
    * The logs that will be emitted in every step of the contract's life cycle
    */
    event VoteStartsEvent(address witnesses1, address witnesses2);
    event EndOfRoundEvent(uint witnesses1Deposit, uint witnesses2Deposit);
    event EndOfOathEvent(address winner, uint gains);

    /**
    * The contract constructor
    */
    constructor() public {
        owner = msg.sender;
    }

    /**
    * A witnesses can register as a voter
    */
    function registerAsAVoter1() public {
        require(witnesses1 == address(0));
        require(witnesses2 == address(0));

        witnesses1 = msg.sender;
    }

    function registerAsAVoter2() public {
        require(witnesses2 == address(0));

        witnesses2 = msg.sender;

        emit VoteStartsEvent(witnesses1, witnesses2);
    }

    /**
    * Every round a player can put a sum of ether, if one of the player put 
    * in twice or more the money (in total) than the other did, the first wins
    */
    function vote() public payable {
        require(!oathFinished && (msg.sender == witnesses1 || msg.sender == witnesses2));

        if(msg.sender == witnesses1) {
            require(witnesses1Voted == false);
            witnesses1Voted = true;
            witnesses1Deposit = witnesses1Deposit + msg.value;
        } else {
            require(witnesses2Voted == false);
            witnesses2Voted = true;
            witnesses2Deposit = witnesses2Deposit + msg.value;
        }

        if(witnesses1Voted && witnesses2Voted) {
            if(witnesses1Deposit >= witnesses2Deposit * 2) {
                endOfOath(witnesses1);
            } else if(witnesses1Deposit >= witnesses2Deposit * 2) {
                endOfOath(witnesses2);
            } else {
                endOfRound();
            }
        }
    }

    function endOfRound() internal {
        witnesses1Voted = false;
        witnesses2Voted = false;

        emit EndOfRoundEvent(witnesses1Deposit, witnesses2Deposit);
    }

    function endOfOath(address winner) internal {
        oathFinished = true;
        theWinner = winner;

        gains = witnesses1Deposit + witnesses2Deposit;
        emit EndOfOathEvent(winner, gains);
    }

    function withraw() public {
        require(oathFinished && theWinner == msg.sender);

        uint amount = gains;

        gains = 0;
        msg.sender.transfer(amount);
    }
}
