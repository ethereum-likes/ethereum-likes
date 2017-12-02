pragma solidity ^0.4.18;

import "./core/SafeMath.sol";
import "./core/ERC20.sol";
import "./RegistrationSystem.sol";

/**
 * @title Standard ResponseToken
 *
 * @dev ResponseTokens have external interfaces like ERC20 tokens
 * @dev but if you try interacting with them, they act more like
 * @dev upvotes on Reddit or likes on Facebook.
 */
contract ResponseToken is ERC20 {
  using SafeMath for uint256;

  mapping(address => uint256) internal balances;
  mapping (address => mapping (address => uint256)) internal allowed;
  RegistrationSystem public registration;

  modifier onlyRegistered() {
    require(registration.isRegistered(msg.sender));
    _;
  }

  function ResponseToken(RegistrationSystem _registration) public {
    registration = _registration;
  }

  /**
  * @dev Sends a ResponseToken from the sender to the receiver. This
  * @dev also gives the sender an allowance to burn the sent ResponseToken.
  * @dev if the user has already sent a ResponseToken to the receiver,
  * @dev it will burn the existing response token instead.
  *
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred. Needs to be 1.
  */
  function transfer(address _to, uint256 _value) public onlyRegistered returns (bool) {
    require(_value > 0);
    if (allowed[_to][msg.sender] == 0) {
      totalSupply = totalSupply.add(1);
      balances[_to] = balances[_to].add(1);
      allowed[_to][msg.sender] = 1;
      Transfer(msg.sender, _to, _value);
      Approval(_to, msg.sender, _value);
    } else {
      transferFrom(_to, address(0), 1);
    }
    return true;
  }

  /**
  * @dev Gets how many ResponseToken the specified address has received.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return balances[_owner];
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public onlyRegistered returns (bool) {
    require(_to == address(0));
    require(_value > 0);
    require(allowed[_from][msg.sender] == 1);

    totalSupply = totalSupply.sub(1);
    balances[_from] = balances[_from].sub(1);
    allowed[_from][msg.sender] = 0;
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev This method intentionally does nothing for ResponseTokens.
   */
  function approve(address /* _spender */, uint256 /* _value */) public returns (bool) {
    return false;
  }

  /**
   * @dev In ResponseTokens, allowance represents if a contract has sent a ResponseToken
   * @dev to another contract. Transfer events automatically update this.
   */
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  /**
   * @dev This method intentionally does nothing for ResponseTokens.
   */
  function increaseApproval(address /* _spender */, uint /* _addedValue */) public returns (bool) {
    return false;
  }

  /**
   * @dev This method intentionally does nothing for ResponseTokens.
   */
  function decreaseApproval(address /* _spender */, uint /* _subtractedValue */) public returns (bool) {
    return false;
  }

  /**
   * @dev Any money paid directly to this contract is sent as a registration fee instead.
   */
  function() external payable {
    registration.register.value(msg.value)(msg.sender, msg.sender);
  }
}

