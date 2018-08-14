pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CredentialFactory.sol";

contract TestCredentialFactory {
    CredentialFactory credentialFactory = CredentialFactory(DeployedAddresses.CredentialFactory());

    /**
    * @dev Checks Owner address vs expected
    */
    function testCheckContractOwner() public {

        address contractOwner = credentialFactory.getOwner();
        address expected = 0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB;

        Assert.equal(contractOwner, expected, "Check Owner");
    }

    function testSelectValidOrgCredentialCount() public {
        address owner = credentialFactory.getOwner();
        uint256 testVal = uint256(credentialFactory.selectOrgCredentialCount(owner));
        uint256 expected = 1;
        Assert.equal(testVal, expected, "Expected Credential Count (1)");
    }

    function testCreateCredential() public {
        bool insertSuccess = credentialFactory.createCredential("A","AAAA","AAAAA");
        Assert.isTrue(insertSuccess, "testCreateCredential Insert Success");
    }

    function testSelectIncreasedValidOrgCredentialCount() public {
        address owner = credentialFactory.getOwner();
        uint256 testVal = uint256(credentialFactory.selectOrgCredentialCount(owner));
        uint256 expected = 2;
        Assert.equal(testVal, expected, "Expected Credential Count (2)");
    }

    function testSelectInvalidOrgCredentialCount() public {
        uint256 testVal = uint256(credentialFactory.selectOrgCredentialCount(0x839c18df17236382f8832d9Ab5ef3FaCAFBAC891));
        uint256 expected = 0;
        Assert.equal(testVal, expected, "Expected Credential Count (0)");
    }

    function testSelectCredentialInitRecord() public {
        address owner = credentialFactory.getOwner();
        string memory credentialLevel;

        (credentialLevel, , ) = credentialFactory.selectCredential(owner, 0);
        string memory expected = "TESTREC";

        Assert.equal(credentialLevel,expected,"Credential Division Matches Expected (TESTREC)");

    }
    function testSelectCredentialInsertedRecord() public {
        address owner = credentialFactory.getOwner();
        string memory credentialLevel;

        (credentialLevel, , ) = credentialFactory.selectCredential(owner, 1);
        string memory expected = "A";

        Assert.equal(credentialLevel,expected,"Credential Division Matches Expected (A)");

    }


}