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
    
    uint256 public orgProcessorsCount;
    
    // constructor
    constructor () public {
        orgProcessorsCount = 0;
    }
    
    // functions
    function updateOrgProcessors() public onlyOwner {
        bool found = false;
        uint256 localOrgCount = selectOrgCount();
        if (orgProcessorsCount != localOrgCount){
            for(uint256 i=0; i < localOrgCount; i++){
                bytes32 shortName;
                bytes6 schoolCode;
                string memory officialSchoolName;
                address schoolAddress;
                for (uint256 j=0; j < orgProcessorsCount; j++){
                    (shortName, schoolCode, officialSchoolName, schoolAddress) = selectCredentialOrg(i);
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

    function updateApplicant(uint _position) public onlyBy(msg.sender) {
        require(msg.sender == applicants[_position].collegeAddress);
        applicants[_position].processDate = block.timestamp;
    }
    
    
    function selectNextApplicantID(uint _startPosition) public view onlyBy(msg.sender) returns (uint ID){
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
    
    function selectApplicantPartA(uint _position) public view onlyBy(msg.sender) returns (address studentAddress, address collegeAddress, string SSN, string collegeStudentID, bytes32 firstName, bytes32 middleName){
        require(_position > 0 && _position <= applicantCount);
        return (applicants[_position].studentAddress, applicants[_position].collegeAddress, applicants[_position].SSN, applicants[_position].collegeStudentID, applicants[_position].firstName, applicants[_position].middleName);
    }

    function selectApplicantPartB(uint _position) public view onlyBy(msg.sender) returns (bytes32 lastName, bytes8 nameSuffix, bytes8 dateOfBirth, uint insertDate){
        require(_position > 0 && _position <= applicantCount);
        return (applicants[_position].lastName, applicants[_position].nameSuffix, applicants[_position].dateOfBirth, applicants[_position].insertDate);
    }



    function processApplicant(uint _position) public onlyBy(msg.sender) {
        applicants[_position].processDate = block.timestamp;
    }
}