pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CredentialOrgFactory.sol";

contract TestCredentialOrgFactory {
    CredentialOrgFactory credentialOrgFactoryA = CredentialOrgFactory(DeployedAddresses.CredentialOrgFactory());
    CredentialOrgFactory credentialOrgFactoryB = new CredentialOrgFactory();
    /**
    * @dev Checks Owner address vs expected
    */
    function testCheckContractOwner() public {

        address contractOwner = credentialOrgFactoryA.getOwner();
        address expected = 0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB;

        Assert.equal(contractOwner, expected, "Check Owner");
    }

    /**
    * @dev Tests to see if INIT record was created upon deploy.
    */
    function testSelectCredentialOrgCount() public {

        uint256 orgCount = uint256(credentialOrgFactoryA.selectOrgCount());
        uint256 expected = 1;

        Assert.equal(orgCount, expected, "Select of CredentialOrg Count.");
    }

    /**
    * @dev Tests to see if INIT record values were set correctly.
    */
    function testSelectCredentialOrgTestRecord() public {

        string memory shortName;
        (shortName, , ) = credentialOrgFactoryA.selectCredentialOrgByPosition(0);
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
        testVal = credentialOrgFactoryB.createCredentialOrg(shortName, officialSchoolName, schoolAddress);
        
        Assert.isTrue(testVal, "Insert of CredentialOrg Test Successful");
    }

    /*
    * @dev Test to see newly inserted credentialing ord data was set correctly.
    */
    function testSelectCredentialOrgDataOnNewInsert() public {

        string memory shortName;
        (shortName, , ) = credentialOrgFactoryB.selectCredentialOrgByPosition(0);
        string memory expected = "TESTREC";

        Assert.equal(shortName, expected, "Retreival of CredentialOrg shortName.");
    }

    /**
    * @dev Tests to see if INIT record was created upon deploy.
    */
    function testSelectCredentialOrgCountAfterInsert() public {

        uint256 orgCount = uint256(credentialOrgFactoryB.selectOrgCount());
        uint256 expected = 1;

        Assert.equal(orgCount, expected, "Select of CredentialOrg Count.");
    }


    /*
    * @dev Test to see credentialing ord data from wrong bad position returns blanks and zeros.
    */
    function testSelectCredentialOrgInvalidPosition() public {

        string memory shortName;
        (shortName, , ) = credentialOrgFactoryA.selectCredentialOrgByPosition(10);
        string memory expected = "";

        Assert.equal(shortName, expected, "Retreival of CredentialOrg shortName.");
    }


    /*
    * @dev Test to see if invalid credentialling org address IS a credentialling org (should return false)
    */
    function testisCredentialOrgInValid() public {

        bool testVal = credentialOrgFactoryA.isCredentialOrg(0x1eC2c24e0110a0c0C4e0E03e694dBC95cd825162);
        Assert.isFalse(testVal, "Base Inserted Test Org Valid");
    }

    /*
    * @dev Test to see if credentialling org can be looked up by address
    */
    function testselectValidCredentialOrgByAddress() public {

        string memory shortName;
        (shortName , , ) = credentialOrgFactoryB.selectCredentialOrgByAddress(0x459c758575A93727fbfE16C4B8A9934Cd8Ab092C);
        string memory expected = "TESTREC";

        Assert.equal(shortName, expected, "Retreival of CredentialOrg shortName.");
    }
}