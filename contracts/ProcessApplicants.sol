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
    function selectApplicantByOrgAndPosition(address _orgAddress, uint32 _position) external view returns (address studentAddress, string SSN, string collegeStudentID, string firstName,  string lastName);
    function updateApplicantByOrgAndPosition(uint32 _position, string _processDetail) external returns (bool updateSuccess);
    function selectOrgApplicantCount(address _orgAddress) external view returns (uint32 appCount);
}

contract ProcessApplicants is Pausable {
    /**
    *  @dev Library useage for safemath for uint32
    */
    using SafeMath32 for uint32;
    // mappings
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
        string firstName;          // first name lenmax 40
        string lastName;           // last name  lenmax 40
        // credential details
        string credentialLevel;     // 50 or less string
        string credentialTitle;     // 70 or less string
        string credentialDivision;  // 50 or less string
    }

    // variables
    address private credentialOrgFactoryAddress;
    address private credentialFactoryAddress;
    address private applicantFatoryAddress;

    // modifiers
    /**
    * @dev Modifer onlyBy for Access Control
    */
    modifier onlyBy(address _credentialOrgAddress){
        uint32 foundAccount = 0;
        CredentialOrgFactory cof = CredentialOrgFactory(credentialOrgFactoryAddress);
        if (cof.isCredentialOrg(msg.sender)){
            foundAccount = 1;
        }
        if (foundAccount == 0) revert("Not Authorized CredentialOrg");
        _;
    }

    // constructor
    constructor () public {
    }

    // functions
    /**
    * @dev Allows owner to set addresses needed for ProcessCredentials contract.
    * @param _credentialOrgContractAddress address of CredentialOrgFactory (set on deploy).
    * @param _credentialContractAddress address of CredentialFactory (set on deploy).
    * @param _applicantContractAddress address of ApplicantFactory (set on deploy).
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
    /**
    * @dev Allows credentialOrg to set where they want to begin processing Applicants (int=0)
    * @param _position address of CredentialOrgFactory (set on deploy).
    */
    function setCredentialOrgApplicantPosition (uint32 _position)
    public onlyBy(msg.sender)
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
    /**
    * @dev Allows credentialOrg to select next Applicant (or sends back blank of not available/error)
    */
    function selectCredentialOrgNextApplicant()
    public view onlyBy(msg.sender)
    returns (address studentAddress, string SSN, string collegeStudentID, string firstName,  string lastName, uint32 insertDate)
    {
        ApplicantFactory af = ApplicantFactory(applicantFatoryAddress);
        if (af.selectOrgApplicantCount(msg.sender) >= credentailOrgToApplicantPosition[msg.sender]){
            (studentAddress, SSN, collegeStudentID, firstName, lastName) = af.selectApplicantByOrgAndPosition(msg.sender, credentailOrgToApplicantPosition[msg.sender]);
        } else {
            studentAddress = 0;
            SSN = "";
            collegeStudentID = "";
            firstName = "";
            lastName = "";
            emit ProcessCredentialDetail (msg.sender, "selectCredentialOrgNextApplicant (FAIL) No Applicants to Process.");
        }
        return (studentAddress, SSN, collegeStudentID, firstName, lastName, insertDate);
    }

    function createApplicantCredential(uint32 _credentialPosition)
    public onlyBy(msg.sender)
    returns (bool insertSuccess)
    {
        insertSuccess = false;
        bool insertStatus = false;
        ApplicantCredential memory appCredential;
        ApplicantFactory af = ApplicantFactory(applicantFatoryAddress);
        CredentialFactory cf = CredentialFactory(credentialFactoryAddress);
        (appCredential.applicant, , , appCredential.firstName, appCredential.lastName) = af.selectApplicantByOrgAndPosition(msg.sender, credentailOrgToApplicantPosition[msg.sender]);
        (appCredential.credentialLevel, appCredential.credentialTitle, appCredential.credentialDivision, , ) = cf.selectCredential(msg.sender, _credentialPosition);
        uint32 position = uint32(credentialOrgToApplicantCredential[msg.sender].push(appCredential));
        if (position > 0){
            insertStatus = true;
        }
        bool updateStatus = updateApplicant("AWARDED");
        if (updateStatus && insertStatus){
            insertSuccess = true;
        }
        return (insertSuccess);
    }

    function denyApplicantCredential()
    public onlyBy(msg.sender)
    returns (bool updateStatus)
    {
        updateStatus = updateApplicant("DENIED");
        return (updateStatus);
    }

    function updateApplicant (string _status)
    internal 
    returns (bool updateStatus)
    {
        ApplicantFactory af = ApplicantFactory(applicantFatoryAddress);
        if (af.selectOrgApplicantCount(msg.sender) >= credentailOrgToApplicantPosition[msg.sender]){
            updateStatus = af.updateApplicantByOrgAndPosition(credentailOrgToApplicantPosition[msg.sender], _status);
        } else {
            updateStatus = false;
            emit ProcessCredentialDetail (msg.sender, "denyApplicantCredential (FAIL) credentialOrgToApplicantPosition failure.");
        }
    }
}