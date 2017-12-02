pragma solidity ^0.4.18;

import "./ResponseToken.sol";

contract UpvoteToken is ResponseToken {
  string public constant name = "Upvotes";
  string public constant symbol = "UPVOTE";
  uint public constant decimals = 0;

  function UpvoteToken(RegistrationSystem _registration) ResponseToken(_registration) public {
  }
}

