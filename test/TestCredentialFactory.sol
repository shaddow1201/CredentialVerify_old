pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/CredentialFactory.sol";

contract TestCredentialFactory {
    CredentialFactory credentialFactory = CredentialFactory(DeployedAddresses.CredentialFactory());

    function testCreateCredential() public {
        credentialFactory.createCredential("A","AAAA","AAAAA");
        string memory credentialLevel;
        string memory credentialTitle;
        string memory credentialDivision; 
        uint32 credentialInsertDate;
        bool isActive;

        (credentialLevel, credentialTitle, credentialDivision, credentialInsertDate, isActive) = credentialFactory.selectCredential(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, 1);

        Assert.isTrue(isActive, "Valid isActive Test.");
    }


    function testIsActiveValid() public {
        bool r = credentialFactory.isCredentialActive(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, 0);
        Assert.isTrue(r, "Valid isActive Test.");
    }

    function testIsActiveInvalid() public {
        bool r = credentialFactory.isCredentialActive(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, 5);
        Assert.isFalse(r, "Outside Range IsActive Test");
    }
    function testSelectOrgCredentialCount() public {
        uint256 testVal = uint256(credentialFactory.selectOrgCredentialCount(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB));
        uint256 expected = 1;
        Assert.equal(testVal, expected, "Expected Credential Count (1)");
    }
    function testSelectOrgCredentialActiveCount() public {
        uint256 testVal = uint256(credentialFactory.selectOrgCredentialActiveCount(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB));
        uint256 expected = 1;
        Assert.equal(testVal, expected, "Expected Credential Count (1)");
    }

    function testSelectCredential() public {
        string memory credentialLevel;
        string memory credentialTitle;
        string memory credentialDivision; 
        uint32 credentialInsertDate;
        bool isActive;

        (credentialLevel, credentialTitle, credentialDivision, credentialInsertDate, isActive) = credentialFactory.selectCredential(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, 0);
        string memory expected = "AAAA";

        Assert.equal(credentialDivision,expected,"Credential Division Matches Expected (AAAA)");

    }


}