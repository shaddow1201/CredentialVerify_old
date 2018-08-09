pragma solidity ^0.4.21;
import "./CredentialOrgFactory.sol";
/**
 * @title CredentialFactory
 * @dev The CredentialFactory allows the credentialOrgs to add/lookup credentials
 */
contract CredentialFactory is CredentialOrgFactory{
    
    using SafeMath32 for uint32;
    // events
    event CredentialFactoryActivity(address credentialOrg, string credentialTitle, string detail);

    // mapping
    mapping (address => Credential[]) orgAddressToCredentials;
    mapping (address => uint32) orgAddressToCredentialTotalCount;
    mapping (address => uint32) orgAddressToActiveCredentialCount;

    // structs
    struct Credential {
        //address credentialOrg;      // CredentialOwnerAddress
        bytes1 credentialLevel;     // single byte string 
        string credentialTitle;     // 70 or less string
        string credentialDivision;  // 50 or less string
        uint32 credentialInsertDate;// Credential Insert timestamp
        bool isActive;              // is CredentialActive for use
    }
   
    // constructor
    constructor () public {
        //credentialCount = 0;
        createCredential("A", "Associate Degree in Basket Weaving", "BA - Arts");
        //createCredentialByOwner(0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C, "A", "Associate Degree in Basket Weaving", "BA - Arts");
        //createCredentialByOwner(0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB, "A", "Associate Degree in Basket Weaving", "BA - Arts");
    }
    
    // functions
    /**
    * @dev allows credentialing Orgs to create new credentials
    * @param _credentialLevel Credential Level
    * @param _credentialTitle CredentialTitle
    * @param _credentialDivision Credential Division
    */
    function createCredential(bytes1 _credentialLevel, string _credentialTitle, string _credentialDivision) 
    public //onlyBy(msg.sender)
    {
        emit CredentialFactoryActivity(msg.sender, _credentialTitle, "New Credential Add (ATTEMPT)");
        if (isCredentialOrg(msg.sender)){
            require(bytes(_credentialTitle).length > 0 && bytes(_credentialTitle).length < 70, "createCredential - Title length problem");
            require(bytes(_credentialDivision).length >= 0 && bytes(_credentialDivision).length < 50, "createCredential - Division length problem");
            //CredentialOrgCredentials credOrgHolder = addressToCredentialOrgCredentials[msg.sender];
            uint32 position = uint32(orgAddressToCredentials[msg.sender].push(Credential( _credentialLevel, _credentialTitle, _credentialDivision, uint32(block.timestamp), true)));
            //uint32(addressToCredentialOrgCredentials[msg.sender].credentials.push(Credential( _credentialLevel, _credentialTitle, _credentialDivision, uint32(block.timestamp), true)));

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
    returns (bytes1 credentialLevel, string credentialTitle, string credentialDivision, uint32 credentialInsertDate, bool isActive)
    {
        require(_position >= 0 && _position < orgAddressToCredentialTotalCount[msg.sender], "selectCredential: Credential Bounds Error");
        return (orgAddressToCredentials[msg.sender][_position].credentialLevel,orgAddressToCredentials[msg.sender][_position].credentialTitle, orgAddressToCredentials[msg.sender][_position].credentialDivision, orgAddressToCredentials[msg.sender][_position].credentialInsertDate,orgAddressToCredentials[msg.sender][_position].isActive);
    }

    /**
    * @dev allows setting credential inactive by it's owner
    * @param _position Credential position in array
    */
    function setCredentialInactiveFlag(uint _position)
    public //onlyBy(msg.sender)
    {
        if (isCredentialOrg(msg.sender)){
            require(_position >= 0, "setCredentialInactiveFlag: Position or Org failure");
            require(orgAddressToCredentials[msg.sender][_position].isActive == true, "Credential is NOT Active");
            orgAddressToCredentials[msg.sender][_position].isActive = false;
            orgAddressToActiveCredentialCount[msg.sender] = orgAddressToActiveCredentialCount[msg.sender].sub(1);
            emit CredentialFactoryActivity(msg.sender, orgAddressToCredentials[msg.sender][_position].credentialTitle, "SetCredentialIsActive - (Set Inactive)");
        } else {
            emit CredentialFactoryActivity(msg.sender, orgAddressToCredentials[msg.sender][_position].credentialTitle, "SetCredentialIsActive - (FAIL) not CredentialOrg");
        }
    }

    /**
    * @dev allows setting credential inactive by it's credentialing org.
    * @param _position Credential position in array
    */
    function setCredentialActiveFlag(uint _position)
    public //onlyBy(msg.sender)
    {
        if (isCredentialOrg(msg.sender)){
            require(_position >= 0 , "setCredentialActiveFlag: position lookup failure");
            require(orgAddressToCredentials[msg.sender][_position].isActive == false, "Credential is already Active");
            orgAddressToCredentials[msg.sender][_position].isActive = true;
            orgAddressToActiveCredentialCount[msg.sender] = orgAddressToActiveCredentialCount[msg.sender].add(1);
            emit CredentialFactoryActivity(msg.sender, orgAddressToCredentials[msg.sender][_position].credentialTitle, "SetCredentialIsActive - (Set Active)");
        } else {
            emit CredentialFactoryActivity(msg.sender, orgAddressToCredentials[msg.sender][_position].credentialTitle, "SetCredentialActive - (FAIL) not CredentialOrg");
        }
    }

    /**
    * @dev allows checking of CredentialCount
    */
    function SelectOrgCredentialActiveCount(address _credentialOrgAddress)
    public view
    returns (uint32 returnCredentialCount)
    {
        returnCredentialCount = orgAddressToActiveCredentialCount[_credentialOrgAddress];
        return (returnCredentialCount);
    }

    /**
    * @dev allows checking of CredentialCount
    */
    function SelectOrgCredentialCount(address _credentialOrgAddress)
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