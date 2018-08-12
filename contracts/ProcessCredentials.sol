pragma solidity ^0.4.21;
/**
 * @title ProcessCredentials
 * @dev The ProcessCredentials contracts allows credentialing orgs to assign credentials to an Applicant.
 */
import "./Pausable.sol";
import "./SafeMath32.sol";

interface CredentialOrgFactory{
    function isCredentialOrg(address _credentialOrgAddress) external view returns (bool IsOrgAddress);
}

interface CredentialFactory{
    function selectCredential(address _credentialOrgAddress, uint32 _position) external view returns (string credentialLevel, string credentialTitle, string credentialDivision, uint32 credentialInsertDate, bool isActive);
    function isCredentialActive(address _credentialOrgAddress, uint _position) external view returns (bool activeState);
}

interface ApplicantFactory{
    function selectApplicantByOrgAndPosition(address _orgAddress, uint32 _position) external view returns (address studentAddress, string SSN, string collegeStudentID, string firstName,  string lastName, uint32 insertDate,  uint32 processDate);
    function selectOrgApplicantCount(address _orgAddress) external view returns (uint32 appCount);
}

contract ProcessCredentials is Pausable {
    /**
    *  @dev Library useage for safemath for uint32
    */
    using SafeMath32 for uint32;
    // mappings
    mapping (address => ApplicantCredential) applicantAddressToApplicantCredential;
    mapping (address => ApplicantCredential[]) credentialOrgToApplicantCredential;
    mapping (address => uint32) credentialOrgToApplicantCredentials;
    mapping (address => uint32) credentailOrgToApplicantPosition;


    // events
    event ProcessCredentialApplicant(address orgAddress, address ApplicantAddress, uint32 position, string detail);
    event ProcessCredentialDetail(address orgAddress,string detail);

    // structs
    struct ApplicantCredential {
        // addresses
        address credentialOrg;
        address applicant;
        // student detail
        string SSN;                 // Applicant SSN
        string collegeStudentID;    // Applicant CollegeID
        string firstName;          // first name lenmax 40
        string lastName;           // last name  lenmax 40
        // credential details
        string credentialLevel;     // 50 or less string
        string credentialTitle;     // 70 or less string
        string credentialDivision;  // 50 or less string
    }

    // variables
    uint32 processedApplicants;
    address private credentialOrgFactoryAddress;
    address private credentialFactoryAddress;
    address private applicantFatoryAddress;

    // constructor
    constructor () public {
        processedApplicants = 0;
    }

    // functions
    /**
    * @dev Allows owner to set address of CredentialOrgFactory contract.
    * @param _credentialOrgContractAddress address of CredentialOrgFactory (set on deploy).
    */
    function setAddress(address _credentialOrgContractAddress, address _credentialContractAddress, address _applicantContractAddress) 
    public onlyOwner 
    {
        if (msg.sender == owner){
            credentialOrgFactoryAddress = _credentialOrgContractAddress;
            credentialFactoryAddress = _credentialContractAddress;
            applicantFatoryAddress = _applicantContractAddress;
        }
    }    

    function setCredentialOrgApplicantPosition (uint32 _position)
    public 
    {
        require(_position >= 0,"setCredentialOrgApplicantPosition (FAIL) Position must be 0 or greater.");
        CredentialOrgFactory cof = CredentialOrgFactory(credentialOrgFactoryAddress);
        if (cof.isCredentialOrg(msg.sender)){
            credentailOrgToApplicantPosition[msg.sender] = _position;
            emit ProcessCredentialDetail (msg.sender, "setCredentialOrgApplicantPosition (SUCCESS)");
        } else {
            emit ProcessCredentialDetail (msg.sender, "setCredentialOrgApplicantPosition (FAIL) Not Credential Org");
        }
    }

    function selectCredentialOrgNextApplicant()
    public view
    returns (address studentAddress, string SSN, string collegeStudentID, string firstName,  string lastName, uint32 insertDate,  uint32 processDate)
    {
        CredentialOrgFactory cof = CredentialOrgFactory(credentialOrgFactoryAddress);
        if (cof.isCredentialOrg(msg.sender)){
            ApplicantFactory af = ApplicantFactory(applicantFatoryAddress);
            if (af.selectOrgApplicantCount(msg.sender) >= credentailOrgToApplicantPosition[msg.sender]){
                (studentAddress, SSN, collegeStudentID, firstName, lastName, insertDate, processDate) = af.selectApplicantByOrgAndPosition(msg.sender, credentailOrgToApplicantPosition[msg.sender]);
            } else {
                studentAddress = 0;
                SSN = "";
                collegeStudentID = "";
                firstName = "";
                lastName = "";
                insertDate = 0;
                processDate = 0;
                emit ProcessCredentialDetail (msg.sender, "selectCredentialOrgNextApplicant (FAIL) No Applicants to Process.");
            }
        } else {
            studentAddress = 0;
            SSN = "";
            collegeStudentID = "";
            firstName = "";
            lastName = "";
            insertDate = 0;
            processDate = 0;
            emit ProcessCredentialDetail (msg.sender, "selectCredentialOrgNextApplicant (FAIL) Not Credential Org");
        }
        return (studentAddress, SSN, collegeStudentID, firstName, lastName, insertDate, processDate);
    }
}