pragma solidity ^0.4.18;

import "./ResponseToken.sol";

contract DownvoteToken is ResponseToken {
  string public constant name = "Downvotes";
  string public constant symbol = "DOWNVOTE";
  uint public constant decimals = 0;

  function DownvoteToken(RegistrationSystem _registration) ResponseToken(_registration) public {
  }
}

