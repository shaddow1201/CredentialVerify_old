pragma solidity ^0.4.21;
/**
 * @title CredentialOrgFactory
 * @dev The CredentialOrgFactory allows the contract owner to add new credentialing orgs
 */
import "./Ownable.sol";

contract CredentialOrgFactory is Ownable {

    mapping(uint => address) orgPositionToAddress;
    mapping(address => uint) addressToOrgPosition;
    
    event NewOrgAdd(bytes32 shortName, address schoolAddress, string detail);

    uint256 private orgCount;

    struct CredentialOrg {
        bytes32 shortName;  // School shortName
        bytes6 schoolCode; // Dept of Education "FICE" code
        string officialSchoolName; // official school shortName (70 or less)
        address schoolAddress;
    }
    
    modifier onlyBy(address _account){
        uint foundAccount = 0;
        for(uint i = 0; i < orgCount; i++){
            if (msg.sender == orgPositionToAddress[i]){
                foundAccount = 1;
            }
        }
        if (foundAccount == 0) revert();
        _;
    }
    
    CredentialOrg[] private credentialOrgs; // array to hold Credentialing Orgs
    /**
    * @dev class constructor
    */
    constructor() public {
        orgCount = 0;
        createCredentialOrg("ABC", owner,"000000","BaseRecordforOwner");
        createCredentialOrg("SCC",0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C,"003793","Spokane Community College");
        createCredentialOrg("SFCC",0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB, "009544","Spokane Falls Community College");
    }
    
    /**
    * @dev allows owner to create new credentialing orgs
    * @param _shortName shortName of Credentialing orgs
    * @param _schoolAddress Credentialling orgAddress
    * @param _schoolCode Credentialing FICE School Code
    * @param _officialSchoolName official School Name
    */
    function createCredentialOrg(bytes32 _shortName, address _schoolAddress, bytes6 _schoolCode, string _officialSchoolName) 
    onlyOwner public
    returns (uint position)
    {
        emit NewOrgAdd(_shortName, _schoolAddress, "New Org Add (PRE)");
        require(_shortName.length > 0 && _schoolAddress != 0 && _schoolCode.length == 6 && bytes(_officialSchoolName).length > 0 && bytes(_officialSchoolName).length < 70);
        position = credentialOrgs.push(CredentialOrg(_shortName, _schoolCode, _officialSchoolName, _schoolAddress));
        if (position >= 0){
            orgPositionToAddress[position] = _schoolAddress;
            addressToOrgPosition[_schoolAddress] = position-1;
            orgCount++;
            emit NewOrgAdd(_shortName, _schoolAddress, "New Org Add (SUCCESS)");
        } else {
            revert();
            emit NewOrgAdd(_shortName, _schoolAddress, "New Org Add (FAIL)");
        }
        return (position);
    }
    /**
    * @dev allows owner to create new credentialing orgs
    * @param _credentialPosition allows selection of credentialing orgs details.
    */
    function selectCredentialOrg(uint256 _credentialPosition) 
    public view
    returns (bytes32 shortName, bytes6 schoolCode, string officialSchoolName, address schoolAddress)
    {
        require(_credentialPosition >= 0 && _credentialPosition < orgCount);
        return (credentialOrgs[_credentialPosition].shortName, credentialOrgs[_credentialPosition].schoolCode, credentialOrgs[_credentialPosition].officialSchoolName, credentialOrgs[_credentialPosition].schoolAddress);
    }
    
    /**
    * @dev allows checking if credentialOrg exists
    * @param _credentialOrgAddress function returns bool if an address is a credentialingOrg
    */
    function isCredentialOrg(address _credentialOrgAddress) 
    public view
    returns (bool IsOrgAddress)
    {
        IsOrgAddress = false;
        require(_credentialOrgAddress != 0);
        for (uint256 i = 0; i < orgCount; i++){
            if (credentialOrgs[i].schoolAddress == _credentialOrgAddress){
                IsOrgAddress = true;
            }
        }
        return (IsOrgAddress);
    }

    /**
    * @dev returns the orgCount
    */
    function selectOrgCount()
    public view
    returns (uint256 returnOrgCount)
    {
        returnOrgCount = orgCount;
        return (returnOrgCount);
    }

}