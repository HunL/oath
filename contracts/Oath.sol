pragma solidity ^0.4.23;

contract Oath {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }
}
