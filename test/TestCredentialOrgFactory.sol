pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CredentialOrgFactory.sol";

contract TestCredentialOrgFactory {
    CredentialOrgFactory credentialOrgFactory = CredentialOrgFactory(DeployedAddresses.CredentialOrgFactory());

    function testSelectCredentialOrgCount() public {
        uint256 orgCount = uint256(credentialOrgFactory.selectOrgCount());
        uint256 expected = 1;
        Assert.equal(orgCount, expected, "Select of CredentialOrg Count.");
    }

    /*
    * @dev Test to see if base account was added.
    */
    function testInsertCredentialOrg() public {

        bool testVal = false;
        string memory shortName = "TESTREC";
        string memory officialSchoolName = "TESTREC";
        address schoolAddress = 0x20cC1600E38dB028e3bAFC0396f4f54B0D5462D8;

        testVal = credentialOrgFactory.createCredentialOrg(shortName, officialSchoolName, schoolAddress);
        
        Assert.isTrue(testVal, "Insert of CredentialOrg Test Successful");
    }


    // @dev test the return of a college.
    function testSelectCredentialOrg() public {
        string memory shortName;
        
        (shortName, , ) = credentialOrgFactory.selectCredentialOrgByPosition(0);
        string memory expected = "INITRECORD";

        Assert.equal(shortName, expected, "Retreival of CredentialOrg shortName.");
    }

    // test to see if invalid org returns false
    function testisCredentialOrgInValid() public {
        bool testVal = credentialOrgFactory.isCredentialOrg(0x1eC2c24e0110a0c0C4e0E03e694dBC95cd825162);
        Assert.isFalse(testVal, "Base Inserted Test Org Valid");
    }

    // test to see if valid org returns true
    function testIsCredentialOrgValid() public {
        address schoolAddress;
        
        ( , , schoolAddress) = credentialOrgFactory.selectCredentialOrgByPosition(0);

        bool testVal = credentialOrgFactory.isCredentialOrg(schoolAddress);
        Assert.isTrue(testVal, "Credential Org Valid");

    }

}