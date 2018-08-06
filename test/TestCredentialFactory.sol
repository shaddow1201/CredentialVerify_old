pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CredentialFactory.sol";

contract TestCredentialFactory {
    CredentialFactory credentialFactory = CredentialFactory(DeployedAddresses.CredentialFactory());

    function testSelectCredentialCount() public {
        uint256 testVal = credentialFactory.SelectCredentialCount();
        uint256 expected = 1;
        Assert.equal(testVal, expected, "Expected Credential Count (1)");
    }

    function testIsActiveValid() public {
        bool r = credentialFactory.isCredentialActive(0);
        Assert.isTrue(r, "Valid isActive Test.");
    }

    function testIsActiveInvalid() public {
        bool r = credentialFactory.isCredentialActive(5);
        Assert.isFalse(r, "Outside Range IsActive Test");
    }
}