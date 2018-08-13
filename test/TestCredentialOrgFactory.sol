pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CredentialOrgFactory.sol";

contract TestCredentialOrgFactory {
    CredentialOrgFactory credentialOrgFactory = CredentialOrgFactory(DeployedAddresses.CredentialOrgFactory());

    /**
    * @dev Tests to see if INIT record was created upon deploy.
    */
    function testSelectCredentialOrgCount() public {

        uint256 orgCount = uint256(credentialOrgFactory.selectOrgCount());
        uint256 expected = 1;

        Assert.equal(orgCount, expected, "Select of CredentialOrg Count.");
    }

    /**
    * @dev Tests to see if INIT record values were set correctly.
    */
    function testSelectCredentialOrgBeforeNewInsert() public {

        string memory shortName;
        (shortName, , ) = credentialOrgFactory.selectCredentialOrgByPosition(0);
        string memory expected = "INITRECORD";

        Assert.equal(shortName, expected, "Retreival of CredentialOrg shortName.");
    }

    /*
    * @dev Test to see if credentialling Org can be created.
    */
    function testInsertCredentialOrg() public {

        bool testVal = false;
        string memory shortName = "TESTREC";
        string memory officialSchoolName = "TESTREC";
        address schoolAddress = 0x459c758575A93727fbfE16C4B8A9934Cd8Ab092C;
        testVal = credentialOrgFactory.createCredentialOrg(shortName, officialSchoolName, schoolAddress);
        
        Assert.isTrue(testVal, "Insert of CredentialOrg Test Successful");
    }

    /*
    * @dev Test to see credentialing ord data was set correctly.
    */
    function testSelectCredentialOrgAfterNewInsert() public {

        string memory shortName;
        (shortName, , ) = credentialOrgFactory.selectCredentialOrgByPosition(1);
        string memory expected = "TESTREC";

        Assert.equal(shortName, expected, "Retreival of CredentialOrg shortName.");
    }

    /*
    * @dev Test to see credentialing ord data was set correctly.
    */
    function testSelectCredentialOrgInvalidPosition() public {

        string memory shortName;
        (shortName, , ) = credentialOrgFactory.selectCredentialOrgByPosition(10);
        string memory expected = "";

        Assert.equal(shortName, expected, "Retreival of CredentialOrg shortName.");
    }


    /*
    * @dev Test to see if invalid credentialling org IS a credentialling org (should return false)
    */
    function testisCredentialOrgInValid() public {

        bool testVal = credentialOrgFactory.isCredentialOrg(0x1eC2c24e0110a0c0C4e0E03e694dBC95cd825162);
        Assert.isFalse(testVal, "Base Inserted Test Org Valid");
    }

    /*
    * @dev Test to see if valid credentialling org IS a credentialling org (should return true)
    */
    function testIsCredentialOrgValidByPosition() public {

        address schoolAddress;
        ( , , schoolAddress) = credentialOrgFactory.selectCredentialOrgByPosition(0);
        bool testVal = credentialOrgFactory.isCredentialOrg(schoolAddress);

        Assert.isTrue(testVal, "Credential Org Valid");
    }

    /*
    * @dev Test to see if credentialling org can be looked up by address
    */
    function testselectValidCredentialOrgByAddress() public {

        string memory shortName;
        (shortName , , ) = credentialOrgFactory.selectCredentialOrgByAddress(0x459c758575A93727fbfE16C4B8A9934Cd8Ab092C);
        string memory expected = "TESTREC";

        Assert.equal(shortName, expected, "Retreival of CredentialOrg shortName.");
    }
}