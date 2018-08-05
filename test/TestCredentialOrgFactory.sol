pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CredentialOrgFactory.sol";

contract TestCredentialOrgFactory {
    CredentialOrgFactory credentialOrgFactory = CredentialOrgFactory(DeployedAddresses.CredentialOrgFactory());

    function testSelectCredentialOrgCount() public {
        uint256 position = credentialOrgFactory.selectOrgCount();
        uint256 expected = 3;
        Assert.equal(position, expected, "Select of CredentialOrg Count.");
    }

    function testSelectCredentialOrg() public {
        bytes32 shortName;
        bytes6 schoolCode;
        string memory officialSchoolName;
        address schoolAddress;
        
        (shortName, schoolCode, officialSchoolName, schoolAddress) = credentialOrgFactory.selectCredentialOrg(0);
        bytes32 expected = "ABC";

        Assert.equal(shortName, expected, "Retreival of CredentialOrg shortName.");
    }
    function testSelectOrgCount() public {
        uint256 testVal = credentialOrgFactory.selectOrgCount();
        uint256 expected = 3;
        Assert.equal(testVal, expected, "Expected Org Count True");
    }
    function testisCredentialOrgInValid() public {
        bool testVal = credentialOrgFactory.isCredentialOrg(0xCDC30Be90065b8Dda7eb417fAe64d6697d5A8965);
        Assert.isFalse(testVal, "Base Inserted Test Org Valid");
    }

    function testisCredentialOrgValid() public {
        bytes32 shortName;
        bytes6 schoolCode;
        string memory officialSchoolName;
        address schoolAddress;
        
        (shortName, schoolCode, officialSchoolName, schoolAddress) = credentialOrgFactory.selectCredentialOrg(0);
        bool testVal = credentialOrgFactory.isCredentialOrg(schoolAddress);
        Assert.isTrue(testVal, "Base Inserted Test Org Valid");
    }
}