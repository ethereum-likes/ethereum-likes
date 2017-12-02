pragma solidity ^0.4.18;

import "./core/SafeMath.sol";
import "./core/Ownable.sol";

/**
 * @title RegistrationSystem
 *
 * @dev Smart contract where people send ethers to register to use the response token system.
 */
contract RegistrationSystem is Ownable {
  using SafeMath for uint256;
  mapping (address => bool) public registered;
  uint256 public registrationPrice = 1 ether;
  address public collection;
  event RegistrationComplete(address user);

  /**
   * @dev Register a user to use the system. Leftover funds are transfered back
   *
   * @param _user The user to register
   * @param _refundee The address to send extra eth to
   */
  function register(address _user, address _refundee) public payable {
    require(msg.value >= registrationPrice);
    require(!registered[_user]);
    registered[_user] = true;
    collection.transfer(registrationPrice);
    _refundee.transfer(this.balance);
    RegistrationComplete(_user);
  }

  /**
   * @dev Checks if a user is registered
   *
   * @param _user The user to query
   */
  function isRegistered(address _user) external view returns (bool) {
    return registered[_user];
  }

  /**
   * @dev Updates the address to send all registration fees
   *
   * @param _collection The address to send fees
   */
  function setCollection(address _collection) external onlyOwner {
    require(_collection != address(0));
    collection = _collection;
  }


  /**
   * @dev Updates the registration fees
   *
   * @param _registrationPrice The new price for all future registration
   */
  function setRegistrationPrice(uint256 _registrationPrice) external onlyOwner {
    registrationPrice = _registrationPrice;
  }

  function() external payable {
    register(msg.sender, msg.sender);
  }
}
