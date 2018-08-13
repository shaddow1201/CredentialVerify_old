pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CredentialFactory.sol";

contract TestCredentialFactory {
    CredentialFactory credentialFactory = CredentialFactory(DeployedAddresses.CredentialFactory());

    function testSelectValidOrgCredentialCount() public {
        address owner = credentialFactory.getOwner();
        uint256 testVal = uint256(credentialFactory.selectOrgCredentialCount(owner));
        uint256 expected = 0;
        Assert.equal(testVal, expected, "Expected Credential Count (0)");
    }

    function testCreateCredential() public {
        bool insertSuccess = credentialFactory.createCredential("A","AAAA","AAAAA");
        Assert.isTrue(insertSuccess, "testCreateCredential Insert Success");
    }

    function testSelectIncreasedValidOrgCredentialCount() public {
        address owner = credentialFactory.getOwner();
        uint256 testVal = uint256(credentialFactory.selectOrgCredentialCount(owner));
        uint256 expected = 1;
        Assert.equal(testVal, expected, "Expected Credential Count (1)");
    }

    function testSelectInvalidOrgCredentialCount() public {
        uint256 testVal = uint256(credentialFactory.selectOrgCredentialCount(0x839c18df17236382f8832d9Ab5ef3FaCAFBAC891));
        uint256 expected = 0;
        Assert.equal(testVal, expected, "Expected Credential Count (1)");
    }

    function testSelectCredential() public {
        address owner = credentialFactory.getOwner();
        string memory credentialLevel;

        (credentialLevel, , ) = credentialFactory.selectCredential(owner, 0);
        string memory expected = "A";

        Assert.equal(credentialLevel,expected,"Credential Division Matches Expected (A)");

    }


}