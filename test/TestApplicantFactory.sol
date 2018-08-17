pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ApplicantFactory.sol";

contract TestApplicantFactory {
    ApplicantFactory applicantFactoryA = ApplicantFactory(DeployedAddresses.ApplicantFactory());
    ApplicantFactory applicantFactoryB = new ApplicantFactory();

    function testCreateApplicantDeployed() public {
        bool insertSuccess = applicantFactoryA.createApplicant(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, "987654321", "222222222", "Richard", "Noordam");

        Assert.isTrue(insertSuccess, "Test Insert Successful (True)");
    }

    function testSelectValidApplicantByOrgAndPosition() public {
        string memory SSN;                 // Applicant SSN
        (, SSN, , , ) = applicantFactoryA.selectApplicantByOrgAndPosition(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, 0);
        string memory expected = "519139038";

        Assert.equal(SSN, expected, "Valid Applicant Lookup Successful.");
    }

    function testCreateApplicantLocalTest() public {
        bool insertSuccess = applicantFactoryA.createApplicant(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, "123456789", "111111111", "Some", "Body");

        Assert.isTrue(insertSuccess, "Test Insert Successful (True)");
    }

    function testUpdateApplicantByOrgAndPosition() public {
        bool updateSuccess = applicantFactoryB.updateApplicantByOrgAndPosition(0, "APPROVED");

        Assert.isTrue(updateSuccess, "Record Update Successful (True)");
    }

    function testselectInValidApplicantByOrgAndPosition() public {
        address studentAddress;     // address of student requesting credential
        (studentAddress, , , , ) = applicantFactoryA.selectApplicantByOrgAndPosition(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, 5);
        address expected = 0;

        Assert.equal(studentAddress, expected, "InValid Applicant Lookup failed appropriately. (returned 0)");
    }

}
