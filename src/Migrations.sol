pragma solidity ^0.4.18;


import './core/Ownable.sol';

/**
 * @title Migrations
 * @dev This is a truffle contract, needed for truffle integration.
 */
contract Migrations is Ownable {
  uint256 public lastCompletedMigration;

  function setCompleted(uint256 completed) onlyOwner public {
    lastCompletedMigration = completed;
  }

  function upgrade(address newAddress) onlyOwner public {
    Migrations upgraded = Migrations(newAddress);
    upgraded.setCompleted(lastCompletedMigration);
  }
}
