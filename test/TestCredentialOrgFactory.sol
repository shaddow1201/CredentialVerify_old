pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CredentialOrgFactory.sol";

contract TestCredentialOrgFactory {
    CredentialOrgFactory credentialOrgFactory = CredentialOrgFactory(DeployedAddresses.CredentialOrgFactory());
    /*
    * @dev Test to see if base account was added.
    */
    function testSelectCredentialOrgCount() public {
        uint256 orgCount = uint256(credentialOrgFactory.selectOrgCount());
        uint256 expected = 1;
        Assert.equal(orgCount, expected, "Select of CredentialOrg Count.");
    }

    // @dev test the return of a college.
    function testSelectCredentialOrg() public {
        bytes32 shortName;
        bytes6 schoolCode;
        string memory officialSchoolName;
        address schoolAddress;
        
        (shortName, schoolCode, officialSchoolName, schoolAddress) = credentialOrgFactory.selectCredentialOrgByPosition(0);
        bytes32 expected = "INITRECORD";

        Assert.equal(shortName, expected, "Retreival of CredentialOrg shortName.");
    }

    // test to see if invalid org returns false
    function testisCredentialOrgInValid() public {
        bool testVal = credentialOrgFactory.isCredentialOrg(0x3018d5d4653ee2ae42c73d9208592ad9f3b6f3a3);
        Assert.isFalse(testVal, "Base Inserted Test Org Valid");
    }

    // test to see if valid org returns true
    function testIsCredentialOrgValid() public {
        bytes32 shortName;
        bytes6 schoolCode;
        string memory officialSchoolName;
        address schoolAddress;
        
        (shortName, schoolCode, officialSchoolName, schoolAddress) = credentialOrgFactory.selectCredentialOrgByPosition(0);

        bool testVal = credentialOrgFactory.isCredentialOrg(schoolAddress);
        Assert.isTrue(testVal, "Credential Org Valid");

    }
    // Test to see if insertion possible.
    function testInsertCredentialOrg() public {
        uint256 checkVal = uint256(credentialOrgFactory.selectOrgCount());
        uint256 arrayLen = credentialOrgFactory.createCredentialOrg("TestOrg", "XXXX", "Test School of Dentistry");
        
        Assert.notEqual(arrayLen, checkVal, "Insert of CredentialOrg Test Successful");
    }

}