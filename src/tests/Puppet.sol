pragma solidity ^0.4.18;

import "../RegistrationSystem.sol";
import "../ResponseToken.sol";

/* Contract created specifically for running tests */
contract Puppet {
    function register(RegistrationSystem _registration, uint256 _amount) public {
        // _registration.transfer.gas(1 ether)(1 ether);
        _registration.call.gas(msg.gas).value(_amount)();
    }

    function registerAs(RegistrationSystem _registration, address _other, uint256 _amount) public {
        _registration.register.gas(msg.gas).value(_amount)(_other, this);
    }

    function setCollection(RegistrationSystem _registration, address _collection) public {
        _registration.setCollection(_collection);
    }

    function setRegistrationPrice(RegistrationSystem _registration, uint256 _price) public {
        _registration.setRegistrationPrice(_price);
    }

    function payToken(ResponseToken _token, uint256 _amount) public {
        _token.call.gas(msg.gas).value(_amount)();
    }

    function sendResponse(ResponseToken _token, address _target, uint256 _amount) public {
        _token.transfer(_target, _amount);
    }

    function burnResponse(ResponseToken _token, address _target, address _destination, uint256 _amount) public {
        _token.transferFrom(_target, _destination, _amount);
    }

    function() payable {
        /* Just accept ethers */
    }
}
