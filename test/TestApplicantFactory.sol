pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ApplicantFactory.sol";

contract TestApplicantFactory {
    ApplicantFactory applicantFactory = ApplicantFactory(DeployedAddresses.ApplicantFactory());

    function testSelectApplicantCount() public {
        uint256 testVal = uint256(applicantFactory.selectApplicantCount());
        uint256 expected = 0;
        Assert.equal(testVal, expected, "Expected Credential Count (0)");
    }

    function testCreateApplicant() public {
        applicantFactory.createApplicant(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, "519139038", "101000942", "Richard", "Noordam");
        uint256 testVal = uint256(applicantFactory.selectApplicantCount());
        uint256 expected = 1;

        Assert.equal(testVal, expected, "Expected Credential Count (0)");
    }

    function testselectValidApplicantByOrgAndPosition() public {
        address studentAddress;     // address of student requesting credential
        string memory SSN;                 // Applicant SSN
        string memory collegeStudentID;    // Applicant CollegeID
        string memory firstName;          // first name lenmax 40
        string memory lastName;           // last name  lenmax 40
        uint32 insertDate;            // unix timestamp.
        uint32 processDate;           // unix timestamp.
        (studentAddress, SSN, collegeStudentID, firstName, lastName, insertDate, processDate) = applicantFactory.selectApplicantByOrgAndPosition(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, 0);
        string memory expected = "519139038";

        Assert.equal(SSN, expected, "Valid Applicant Lookup Successful.");
    }
    function testselectInValidApplicantByOrgAndPosition() public {
        address studentAddress;     // address of student requesting credential
        string memory SSN;                 // Applicant SSN
        string memory collegeStudentID;    // Applicant CollegeID
        string memory firstName;          // first name lenmax 40
        string memory lastName;           // last name  lenmax 40
        uint32 insertDate;            // unix timestamp.
        uint32 processDate;           // unix timestamp.
        (studentAddress, SSN, collegeStudentID, firstName, lastName, insertDate, processDate) = applicantFactory.selectApplicantByOrgAndPosition(0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, 5);
        address expected = 0;

        Assert.equal(studentAddress, expected, "InValid Applicant Lookup failed appropriately. (returned 0)");
    }

}
