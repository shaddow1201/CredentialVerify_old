pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ApplicantFactory.sol";

contract TestApplicantFactory {
    ApplicantFactory applicantFactory = ApplicantFactory(DeployedAddresses.ApplicantFactory());

    function testCreateApplicant() public {
        applicantFactory.createApplicant(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, "519139038", "101000942", "Richard", "Noordam");
        uint256 testVal = uint256(applicantFactory.selectOrgApplicantCount(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB));
        uint256 expected = 1;

        Assert.equal(testVal, expected, "Expected Credential Count (0)");
    }

    function testselectValidApplicantByOrgAndPosition() public {
        string memory SSN;                 // Applicant SSN
        (, SSN, , , ) = applicantFactory.selectApplicantByOrgAndPosition(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, 0);
        string memory expected = "519139038";

        Assert.equal(SSN, expected, "Valid Applicant Lookup Successful.");
    }
    function testselectInValidApplicantByOrgAndPosition() public {
        address studentAddress;     // address of student requesting credential
        (studentAddress, , , , ) = applicantFactory.selectApplicantByOrgAndPosition(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, 5);
        address expected = 0;

        Assert.equal(studentAddress, expected, "InValid Applicant Lookup failed appropriately. (returned 0)");
    }

}
