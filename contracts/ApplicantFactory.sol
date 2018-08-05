pragma solidity ^0.4.21;

import "./Ownable.sol";

contract ApplicantFactory is Ownable {

    event NewApplicantAdd(address ApplicantAddress, uint32 position, string detail);

    uint256 applicantCount;

    struct Applicant {
        address studentAddress;     // address of student requesting credential
        address collegeAddress;      // college address
        string SSN;                 // Applicant SSN
        string collegeStudentID;    // Applicant CollegeID
        bytes32 firstName;          // first name
        bytes32 middleName;         // middle name
        bytes32 lastName;           // last name
        bytes8 nameSuffix;          // name suffix
        bytes8 dateOfBirth;         // YYYYMMDD
        uint insertDate;            // unix timestamp.
        uint processDate;           // unix timestamp.
    }
    
    Applicant[] public applicants;
    
    constructor() public {
        applicantCount = 0;
    }
    
    function createApplicant(address _collegeAddress, string _SSN, string _collegeStudentID, bytes32 _firstName, bytes32 _middleName, bytes32 _lastName, bytes8 _nameSuffix, bytes8 _dateOfBirth) 
    public 
    {
        emit NewApplicantAdd(msg.sender, 0, "NewApplicantAdd (ATTEMPT)");
        require(msg.sender !=0 && _collegeAddress !=0 && bytes(_SSN).length == 9 && bytes(_collegeStudentID).length == 9 && _firstName.length > 0 && _lastName.length > 0); 
        uint position = applicants.push(Applicant(msg.sender, _collegeAddress, _SSN, _collegeStudentID, _firstName, _middleName, _lastName, _nameSuffix, _dateOfBirth, block.timestamp, 0));
        if (position > 0){
            applicantCount++;
            emit NewApplicantAdd(msg.sender, 0, "NewApplicantAdd (SUCCESS)");
        } else {
            emit NewApplicantAdd(msg.sender, 0, "NewApplicantAdd (FAIL-PUSH)");
        }
    }

    function selectApplicantCount()
    public view
    returns (uint256 appCount)
    {
        appCount = applicantCount;
        return (appCount);
    }

}