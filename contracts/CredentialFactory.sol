pragma solidity ^0.4.21;
import "./Pausable.sol";
import "./SafeMath32.sol";
/**
 * @title CredentialFactory
 * @dev The CredentialFactory allows the credentialOrgs to add/lookup credentials
 */
interface CredentialOrgFactory{
    function isCredentialOrg(address _credentialOrgAddress) external view returns (bool IsOrgAddress);
}


contract CredentialFactory is Pausable{
    
    using SafeMath32 for uint32;
    // events
    event CredentialFactoryActivity(address credentialOrg, string credentialTitle, string detail);

    // mapping
    mapping (address => Credential[]) orgAddressToCredentials;
    mapping (address => uint32) orgAddressToCredentialTotalCount;
    mapping (address => uint32) orgAddressToActiveCredentialCount;

    // structs
    struct Credential {
        address credentialOrg;      // CredentialOwnerAddress
        string credentialLevel;     // 50 or less string
        string credentialTitle;     // 70 or less string
        string credentialDivision;  // 50 or less string
        uint32 credentialInsertDate;// Credential Insert timestamp
        bool isActive;              // is CredentialActive for use
    }
    address private credentialOrgContractAddress;
    
    // constructor
    constructor () public {
    }
    // functions
    function setAddress(address _credentialOrgContractAddress) public onlyOwner {
        if (msg.sender == owner){
            credentialOrgContractAddress = _credentialOrgContractAddress;
        }
    }
    /**
    * @dev allows credentialing Orgs to create new credentials
    * @param _credentialLevel Credential Level
    * @param _credentialTitle CredentialTitle
    * @param _credentialDivision Credential Division
    */
    function createCredential(string _credentialLevel, string _credentialTitle, string _credentialDivision) 
    public //onlyBy(msg.sender)
    {
        emit CredentialFactoryActivity(msg.sender, _credentialTitle, "New Credential Add (ATTEMPT)");
        CredentialOrgFactory cof = CredentialOrgFactory(credentialOrgContractAddress);
        if (cof.isCredentialOrg(msg.sender)){
            require(bytes(_credentialLevel).length > 0 && bytes(_credentialLevel).length < 50, "createCredential - Level length problem");
            require(bytes(_credentialTitle).length > 0 && bytes(_credentialTitle).length < 70, "createCredential - Title length problem");
            require(bytes(_credentialDivision).length >= 0 && bytes(_credentialDivision).length < 50, "createCredential - Division length problem");
            uint32 position = uint32(orgAddressToCredentials[msg.sender].push(Credential(msg.sender, _credentialLevel, _credentialTitle, _credentialDivision, uint32(block.timestamp), true)));
            if(position >= 0){
                orgAddressToCredentialTotalCount[msg.sender] = orgAddressToCredentialTotalCount[msg.sender].add(1);
                orgAddressToActiveCredentialCount[msg.sender] = orgAddressToActiveCredentialCount[msg.sender].add(1);
                emit CredentialFactoryActivity(msg.sender, _credentialTitle, "New Credential Add (SUCCCESS)");
            } else {
                emit CredentialFactoryActivity(msg.sender, _credentialTitle, "New Credential Add (FAILED)");
            }
        } else {
            emit CredentialFactoryActivity(msg.sender, _credentialTitle, "New Credential Add (FAILED), Not CredentialOrg");
        }
    }

    /**
    * @dev allows selection of credential based on position.
    * @param _credentialOrgAddress credentialOrg Address
    * @param _position allows selection of credentialing orgs details.
    */
    function selectCredential(address _credentialOrgAddress, uint32 _position) 
    public view
    returns (string credentialLevel, string credentialTitle, string credentialDivision, uint32 credentialInsertDate, bool isActive)
    {
        require(_position >= 0, "selectCredential (FAIL) position incorrect");
        CredentialOrgFactory cof = CredentialOrgFactory(credentialOrgContractAddress);
        if (cof.isCredentialOrg(_credentialOrgAddress)){
            if (_position < orgAddressToCredentialTotalCount[_credentialOrgAddress]){
                return (orgAddressToCredentials[_credentialOrgAddress][_position].credentialLevel,orgAddressToCredentials[_credentialOrgAddress][_position].credentialTitle, orgAddressToCredentials[_credentialOrgAddress][_position].credentialDivision, orgAddressToCredentials[_credentialOrgAddress][_position].credentialInsertDate,orgAddressToCredentials[_credentialOrgAddress][_position].isActive);    
            } else {
                emit CredentialFactoryActivity(msg.sender, "", "selectCredential: Credential Bounds Error");
                return ("","","", 0, false);
            }
        } else {
            emit CredentialFactoryActivity(msg.sender, "", "selectCredential: Not CredentialOrg");
            return ("","","", 0, false);
        }
    }

    /**
    * @dev allows setting credential inactive by it's owner
    * @param _position Credential position in array
    */
    function setCredentialInactiveFlag(uint _position)
    public //onlyBy(msg.sender)
    {
        require(msg.sender == orgAddressToCredentials[msg.sender][_position].credentialOrg, "setCredeentialInactiveflag - (FAIL) not owner");
        require(_position >= 0, "setCredentialInactiveFlag: Position or Org failure");
        require(orgAddressToCredentials[msg.sender][_position].isActive == true, "Credential is NOT Active");
        orgAddressToCredentials[msg.sender][_position].isActive = false;
        orgAddressToActiveCredentialCount[msg.sender] = orgAddressToActiveCredentialCount[msg.sender].sub(1);
        emit CredentialFactoryActivity(msg.sender, orgAddressToCredentials[msg.sender][_position].credentialTitle, "SetCredentialIsActive - (Set Inactive)");
    }

    /**
    * @dev allows setting credential inactive by it's credentialing org.
    * @param _position Credential position in array
    */
    function setCredentialActiveFlag(uint _position)
    public //onlyBy(msg.sender)
    {
        require(msg.sender == orgAddressToCredentials[msg.sender][_position].credentialOrg, "setCredeentialInactiveflag - (FAIL) not owner");
        require(_position >= 0 , "setCredentialActiveFlag: position lookup failure");
        require(orgAddressToCredentials[msg.sender][_position].isActive == false, "Credential is already Active");
        orgAddressToCredentials[msg.sender][_position].isActive = true;
        orgAddressToActiveCredentialCount[msg.sender] = orgAddressToActiveCredentialCount[msg.sender].add(1);
        emit CredentialFactoryActivity(msg.sender, orgAddressToCredentials[msg.sender][_position].credentialTitle, "SetCredentialIsActive - (Set Active)");
    }

    /**
    * @dev allows checking of CredentialCount
    */
    function selectOrgCredentialActiveCount(address _credentialOrgAddress)
    public view
    returns (uint32 returnCredentialCount)
    {
        returnCredentialCount = orgAddressToActiveCredentialCount[_credentialOrgAddress];
        return (returnCredentialCount);
    }

    /**
    * @dev allows checking of CredentialCount
    */
    function selectOrgCredentialCount(address _credentialOrgAddress)
    public view
    returns (uint32 returnCredentialCount)
    {
        returnCredentialCount = orgAddressToCredentialTotalCount[_credentialOrgAddress];
        return (returnCredentialCount);
    }

    /**
    * @dev allows checking of isActive flag for credential
    * @param _position Credential position in array
    */
    function isCredentialActive(address _credentialOrgAddress, uint _position)
    public view
    returns (bool activeState)
    {
        activeState = false;
        require(_position >= 0);
        if (_position < orgAddressToCredentialTotalCount[_credentialOrgAddress]){
            if (orgAddressToCredentials[_credentialOrgAddress][_position].isActive == true){
                activeState = true;
            }
        }
        return (activeState);
    }
}