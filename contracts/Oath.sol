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

        witnesses1 = msg.sender;
    }

    function registerAsAVoter2() public {
        require(witnesses2 == address(0));

        witnesses2 = msg.sender;
    }
}
