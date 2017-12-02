pragma solidity ^0.4.18;

import "ds-test/test.sol";

import "./Puppet.sol";
import "../RegistrationSystem.sol";
import "../UpvoteToken.sol";

contract RegistrationSystemTest is DSTest {
    RegistrationSystem registration;
    Puppet puppet1;
    Puppet puppet2;
    Puppet collection;

    function setUp() public {
        collection = new Puppet();
        registration = new RegistrationSystem();
        registration.setCollection(collection);
        puppet1 = new Puppet();
        puppet1.transfer(10 ether);
        puppet2 = new Puppet();
        puppet2.transfer(10 ether);
    }

    function test_unregistered() public {
        assertTrue(!registration.isRegistered(puppet1));
    }

    function test_registration() public {
        uint256 initialPuppet = puppet1.balance;
        uint256 initialCollection = collection.balance;
        puppet1.register(registration, registration.registrationPrice() + 1 ether);

        assertTrue(registration.isRegistered(puppet1));
        assertEq(initialPuppet - registration.registrationPrice(), puppet1.balance);
        assertEq(initialCollection + registration.registrationPrice(), collection.balance);
    }

    function test_registration_for_friend() public {
        uint256 initialPuppet1 = puppet1.balance;
        uint256 initialPuppet2 = puppet2.balance;
        uint256 initialCollection = collection.balance;
        puppet1.registerAs(registration, puppet2, registration.registrationPrice());

        assertTrue(!registration.isRegistered(puppet1));
        assertTrue(registration.isRegistered(puppet2));
        assertEq(initialPuppet1 - registration.registrationPrice(), puppet1.balance);
        assertEq(initialPuppet2, puppet2.balance);
        assertEq(initialCollection + registration.registrationPrice(), collection.balance);
    }

    function test_insufficient_funds_registration() public {
        uint256 initialPuppet1 = puppet1.balance;
        puppet1.register(registration, registration.registrationPrice() - 1);
        assertEq(initialPuppet1, puppet1.balance);
        assertTrue(!registration.isRegistered(puppet1));
    }

    function test_double_registration() public {
        puppet1.register(registration, registration.registrationPrice());
        uint256 postregistration = puppet1.balance;
        puppet1.register(registration, registration.registrationPrice());
        assertEq(postregistration, puppet1.balance);
        assertTrue(registration.isRegistered(puppet1));
    }

    function testFail_set_collection() public {
        puppet1.setCollection(registration, puppet2);
    }

    function testFail_set_collection_zero() public {
        registration.setCollection(address(0));
    }

    function test_change_owner_set_collection() public {
        registration.transferOwnership(puppet1);
        puppet1.setCollection(registration, puppet2);
        assertEq(registration.collection(), puppet2);
    }

    function testFail_set_registration_price() public {
        puppet1.setRegistrationPrice(registration, 5 ether);
    }

    function test_change_owner_set_registration_price() public {
        registration.transferOwnership(puppet1);
        puppet1.setRegistrationPrice(registration, 5 ether);
        assertEq(registration.registrationPrice(), 5 ether);
    }
}
