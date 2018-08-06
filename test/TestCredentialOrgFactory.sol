pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CredentialOrgFactory.sol";

contract TestCredentialOrgFactory {
    CredentialOrgFactory credentialOrgFactory = CredentialOrgFactory(DeployedAddresses.CredentialOrgFactory());

    // Test to see if base accounts were added. (base, scc and sfcc)
    function testSelectCredentialOrgCount() public {
        uint256 orgCount = uint256(credentialOrgFactory.selectOrgCount());
        uint256 expected = 3;
        Assert.equal(orgCount, expected, "Select of CredentialOrg Count.");
    }

    // test the return of a college.
    function testSelectCredentialOrg() public {
        bytes32 shortName;
        bytes6 schoolCode;
        string memory officialSchoolName;
        address schoolAddress;
        
        (shortName, schoolCode, officialSchoolName, schoolAddress) = credentialOrgFactory.selectCredentialOrg(0);
        bytes32 expected = "ABC";

        Assert.equal(shortName, expected, "Retreival of CredentialOrg shortName.");
    }

    // test to see if invalid org returns false
    function testisCredentialOrgInValid() public {
        bool testVal = credentialOrgFactory.isCredentialOrg(0xCDC30Be90065b8Dda7eb417fAe64d6697d5A8965);
        Assert.isFalse(testVal, "Base Inserted Test Org Valid");
    }

    // test to see if valid org returns false
    function testIsCredentialOrgValid() public {
        bytes32 shortName;
        bytes6 schoolCode;
        string memory officialSchoolName;
        address schoolAddress;
        
        (shortName, schoolCode, officialSchoolName, schoolAddress) = credentialOrgFactory.selectCredentialOrg(0);
        bool testVal = credentialOrgFactory.isCredentialOrg(schoolAddress);
        Assert.isTrue(testVal, "Base Inserted Test Org Valid");
    }
    // Test to see if insertion possible.
    function testInsertCredentialOrg() public {
        uint256 checkVal = uint256(credentialOrgFactory.selectOrgCount());
        uint256 arrayLen = credentialOrgFactory.createCredentialOrg("TestOrg", 0xc4c0Fd9475A6C8D1656aeD27d2582bE2608Eb8c7, "XXXX", "Test School of Dentistry");
        Assert.notEqual(arrayLen, checkVal, "Insert of CredentialOrg Test Successful");
    }

}