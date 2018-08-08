pragma solidity ^0.4.21;
/**
 * @title ProcessCredentials
 * @dev The ProcessCredentials allows the contract owner to process and write out credentials.
 */
import "./ApplicantFactory.sol";
import "./CredentialOrgFactory.sol";

contract ProcessCredentials is CredentialOrgFactory, ApplicantFactory {
    
    // mappings
    
    // events
    event ProcessApplicant(address ApplicantAddress, uint32 position, string detail);

    // structs
    struct OrgProcessor{
        address credentialOrgAddress;
        uint32 lastApplicantPosition;
    }    
    
    OrgProcessor[] public orgProcessors;
    
    uint32 public orgProcessorsCount;
    
    // constructor
    constructor () public {
        orgProcessorsCount = 0;
    }
    
    // functions
    function updateOrgProcessors() public onlyOwner {
        bool found = false;
        uint32 localOrgCount = selectOrgCount();
        if (orgProcessorsCount != localOrgCount){
            for(uint32 i=0; i < localOrgCount; i++){
                bytes32 shortName;
                bytes6 schoolCode;
                string memory officialSchoolName;
                address schoolAddress;
                for (uint32 j=0; j < orgProcessorsCount; j++){
                    //(shortName, schoolCode, officialSchoolName, schoolAddress) = selectCredentialOrg(i);
                    if (schoolAddress == orgProcessors[j].credentialOrgAddress){
                        found = true;
                    }
                }            
                if (found == false){
                    orgProcessors.push(OrgProcessor(schoolAddress,0));
                    orgProcessorsCount++;
                }
                found = false;
            }
        }
    }

    function updateApplicant(uint32 _position) public onlyBy(msg.sender) {
        require(msg.sender == applicants[_position].collegeAddress);
        applicants[_position].processDate = block.timestamp;
    }
    
    
    function selectNextApplicantID(uint32 _startPosition) public view onlyBy(msg.sender) returns (uint ID){
        require(_startPosition > 0 && _startPosition <= applicantCount);
        uint startPosition = _startPosition;
        bool foundRec = false;
        uint foundPosition = 0;
        while (!foundRec && startPosition <= applicantCount){
            if (applicants[startPosition].collegeAddress == msg.sender){
                foundRec = true;
                foundPosition = startPosition;
            }
            startPosition++;
        }
        return (foundPosition);
    }
    
    function selectApplicantPartA(uint32 _position) public view onlyBy(msg.sender) returns (address studentAddress, address collegeAddress, string SSN, string collegeStudentID, bytes32 firstName, bytes32 middleName){
        require(_position > 0 && _position <= applicantCount);
        return (applicants[_position].studentAddress, applicants[_position].collegeAddress, applicants[_position].SSN, applicants[_position].collegeStudentID, applicants[_position].firstName, applicants[_position].middleName);
    }

    function selectApplicantPartB(uint32 _position) public view onlyBy(msg.sender) returns (bytes32 lastName, bytes8 nameSuffix, bytes8 dateOfBirth, uint insertDate){
        require(_position > 0 && _position <= applicantCount);
        return (applicants[_position].lastName, applicants[_position].nameSuffix, applicants[_position].dateOfBirth, applicants[_position].insertDate);
    }

    function processApplicant(uint32 _position) public onlyBy(msg.sender) {
        applicants[_position].processDate = block.timestamp;
    }
}