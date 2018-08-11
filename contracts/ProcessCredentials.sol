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
    
    // events
    event ProcessApplicant(address ApplicantAddress, uint32 position, string detail);

    // variables
    uint32 processedApplicants;
    address credentialOrgFactoryAddress;
    address credentialFactoryAddress;
    address applicantFatoryAddress;

    // constructor
    constructor () public {
        processedApplicants = 0;
    }

    // functions
    /**
    * @dev Allows owner to set address of CredentialOrgFactory contract.
    * @param _credentialOrgContractAddress address of CredentialOrgFactory (set on deploy).
    */
    function setAddress(address _credentialOrgContractAddress, address _credentialContractAddress, address _applicantContractAddress) public onlyOwner {
        if (msg.sender == owner){
            credentialOrgFactoryAddress = _credentialOrgContractAddress;
            credentialFactoryAddress = _credentialContractAddress;
            applicantFatoryAddress = _applicantContractAddress;
        }
    }    
}