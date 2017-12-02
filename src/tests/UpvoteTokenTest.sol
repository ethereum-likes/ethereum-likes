pragma solidity ^0.4.18;

import "ds-test/test.sol";

import "./Puppet.sol";
import "../RegistrationSystem.sol";
import "../UpvoteToken.sol";

contract UpvoteTokenTest is DSTest {
    RegistrationSystem registration;
    UpvoteToken token;
    Puppet registered1;
    Puppet registered2;
    Puppet unregistered;
    Puppet collection;
    Puppet dummy;

    function setUp() public {
        collection = new Puppet();
        registration = new RegistrationSystem();
        registration.setCollection(collection);
        token = new UpvoteToken(registration);
        registered1 = new Puppet();
        registered1.transfer(10 ether);
        registered1.register(registration, registration.registrationPrice());
        registered2 = new Puppet();
        registered2.transfer(10 ether);
        registered2.register(registration, registration.registrationPrice());
        unregistered = new Puppet();
        unregistered.transfer(10 ether);
        dummy = new Puppet();
    }

    function test_indirect_registration() public {
        // Initially not registered
        assertTrue(!registration.isRegistered(unregistered));
        uint256 initial = unregistered.balance;
        unregistered.payToken(token, registration.registrationPrice() + 1 ether);

        // Registered and paid exactly registration price
        assertTrue(registration.isRegistered(unregistered));
        assertEq(initial - registration.registrationPrice(), unregistered.balance);
    }

    function test_indirect_registration_insufficient() public {
        assertTrue(!registration.isRegistered(unregistered));
        unregistered.payToken(token, registration.registrationPrice() - 1);
        assertTrue(!registration.isRegistered(unregistered));
    }

    function test_upvotes() public {
        registered1.sendResponse(token, dummy, 1);
        registered2.sendResponse(token, dummy, 1);
        assertEq(token.balanceOf(dummy), 2);
        assertEq(token.allowance(dummy, registered1), 1);
        assertEq(token.allowance(dummy, registered2), 1);
    }

    function test_upvotes_send_many() public {
        registered1.sendResponse(token, dummy, 10000);
        registered2.sendResponse(token, dummy, 10000);
        assertEq(token.balanceOf(dummy), 2);
        assertEq(token.allowance(dummy, registered1), 1);
        assertEq(token.allowance(dummy, registered2), 1);
    }

    function test_upvotes_double_send() public {
        registered1.sendResponse(token, dummy, 10000);
        registered1.sendResponse(token, dummy, 500);
        assertEq(token.balanceOf(dummy), 0);
        assertEq(token.allowance(dummy, registered1), 0);
    }

    function test_upvotes_burn_response() public {
        registered1.sendResponse(token, dummy, 10000);
        registered2.sendResponse(token, dummy, 10000);
        registered1.burnResponse(token, dummy, address(0), 500);
        assertEq(token.balanceOf(dummy), 1);
        assertEq(token.allowance(dummy, registered1), 0);
        assertEq(token.allowance(dummy, registered2), 1);
    }

    function testFail_burn_nothing() public {
        registered1.burnResponse(token, dummy, address(0), 1);
    }

    function testFail_unregistered_upvote() public {
        unregistered.sendResponse(token, dummy, 1);
    }
}
