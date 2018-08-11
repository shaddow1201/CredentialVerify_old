pragma solidity ^0.4.21;
/**
 * @title ApplicantFactory
 * @dev The ApplicantFactory allows applicants to apply to a credentialOrg for an electronic credential.
 */
import "./Pausable.sol";
import "./SafeMath32.sol";

interface CredentialOrgFactory{
    function isCredentialOrg(address _credentialOrgAddress) external view returns (bool IsOrgAddress);
}

contract ApplicantFactory is Pausable {

    /**
    *  @dev Library useage for safemath for uint32
    */
    using SafeMath32 for uint32;

    event CreateNewApplicant(address ApplicantAddress, uint32 position, string detail);
    event ApplicantDetail(address ApplicantCallerAddress, string detail);
    
    
    mapping (address => Applicant[]) orgAddressToApplicants;
    mapping (address => uint32) orgAddressToApplicantCount;
    mapping (address => uint32) applicantAddressToApplicantPosition;
    
    uint32 applicantCount;

    struct Applicant {
        address studentAddress;     // address of student requesting credential
        string SSN;                 // Applicant SSN
        string collegeStudentID;    // Applicant CollegeID
        string firstName;          // first name lenmax 40
        string lastName;           // last name  lenmax 40
        uint32 insertDate;            // unix timestamp.
        uint32 processDate;           // unix timestamp.
    }
    
    constructor() public {
        applicantCount = 0;
    }
    
    address credentialOrgContractAddress;

    // functions
    /**
    * @dev Allows owner to set address of CredentialOrgFactory contract.
    * @param _credentialOrgContractAddress address of CredentialOrgFactory (set on deploy).
    */
    function setAddress(address _credentialOrgContractAddress) public onlyOwner {
        if (msg.sender == owner){
            credentialOrgContractAddress = _credentialOrgContractAddress;
        }
    }

    /**
    * @dev Allows creation of Applicants to Credentialing Orgs
    * @param _collegeAddress address of CredentialingOrg
    * @param _SSN SSN of Student
    * @param _collegeStudentID College Student ID
    * @param _firstName First Name of Student
    * @param _lastName Last Name of Student
    */
    function createApplicant(address _collegeAddress, string _SSN, string _collegeStudentID, string _firstName, string _lastName) 
    public 
    {
        emit CreateNewApplicant(msg.sender, 0, "createApplicant (ATTEMPT)");
        require(msg.sender !=0 && _collegeAddress != 0, "createApplicant (FAIL) Addresses can not be 0.");
        require(bytes(_SSN).length == 9,"createApplicant (FAIL) SSN Length incorrect");
        require(bytes(_collegeStudentID).length == 9, "createApplicant (FAIL)College StudentID length Problem");
        require(bytes(_firstName).length > 0 && bytes(_firstName).length <= 40, "createApplicant (FAIL) FirstName length problem"); 
        require(bytes(_lastName).length > 0 && bytes(_lastName).length <= 40, "createApplicant (FAIL) LastName length problem"); 

        CredentialOrgFactory cof = CredentialOrgFactory(credentialOrgContractAddress);
        if (cof.isCredentialOrg(_collegeAddress)){
            uint32 position = uint32(orgAddressToApplicants[_collegeAddress].push(Applicant(msg.sender, _SSN, _collegeStudentID, _firstName, _lastName, uint32(block.timestamp), 0)));
            if(position >= 0){
                applicantCount = applicantCount.add(1);
                applicantAddressToApplicantPosition[msg.sender] = position -1;
                orgAddressToApplicantCount[_collegeAddress] = orgAddressToApplicantCount[_collegeAddress].add(1);
                emit CreateNewApplicant(msg.sender, 0, "createApplicant (SUCCESS)");
            } else {
                emit CreateNewApplicant(msg.sender, 0, "createApplicant (FAIL)");
            }
        } else {
            emit CreateNewApplicant(msg.sender, 0, "createApplicant (FAIL) Not CredentialOrg");
        }
    }

    /**
    * @dev Allows Selection of Applicant by org and position.
    * @param _orgAddress address of CredentialingOrg
    * @param _position position in array of Applicant
    */
    function selectApplicantByOrgAndPosition(address _orgAddress, uint32 _position)
    public view
    returns (address studentAddress, string SSN, string collegeStudentID, string firstName,  string lastName, uint32 insertDate,  uint32 processDate)
    {
        require(_orgAddress != 0, "Applicant orgAddress can not be 0");
        CredentialOrgFactory cof = CredentialOrgFactory(credentialOrgContractAddress);
        if (_position < orgAddressToApplicantCount[_orgAddress] && cof.isCredentialOrg(_orgAddress)){
            studentAddress = orgAddressToApplicants[_orgAddress][_position].studentAddress;
            SSN = orgAddressToApplicants[_orgAddress][_position].SSN;
            collegeStudentID = orgAddressToApplicants[_orgAddress][_position].collegeStudentID;
            firstName = orgAddressToApplicants[_orgAddress][_position].firstName;
            lastName = orgAddressToApplicants[_orgAddress][_position].lastName;
            insertDate = orgAddressToApplicants[_orgAddress][_position].insertDate;
            processDate = orgAddressToApplicants[_orgAddress][_position].processDate;
            emit ApplicantDetail(msg.sender, "selectApplicantByOrgAndPosition (SUCCESS)");
        } else {
            studentAddress = 0;
            SSN = "";
            collegeStudentID = "";
            firstName = "";
            lastName = "";
            insertDate = 0;
            processDate = 0;
            emit ApplicantDetail(msg.sender, "selectApplicant (FAIL) Applicant lookup fail, or orgAddress isn't credentialing org.");
        }
        return(studentAddress, SSN, collegeStudentID, firstName, lastName, insertDate, processDate);
    }

    /**
    * @dev Allows Selection of Applicant Total Count.
    */
    function selectApplicantCount()
    public view 
    returns (uint32 appCount)
    {
        appCount = applicantCount;
        return (appCount);
    }

    /**
    * @dev Allows Selection of Applicant Count by orgAddress
    * @param _orgAddress address of CredentialingOrg
    */
    function selectOrgApplicantCount(address _orgAddress)
    public view 
    returns (uint32 appCount)
    {
        appCount = orgAddressToApplicantCount[_orgAddress];
        return (appCount);
    }
}