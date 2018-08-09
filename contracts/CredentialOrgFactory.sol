pragma solidity ^0.4.21;

/**
 * @title CredentialOrgFactory
 * @dev The CredentialOrgFactory allows the contract owner to add new credentialing orgs
 */
import "./Pausable.sol";
import "./SafeMath.sol";

contract CredentialOrgFactory is Pausable {

    /**
    *  @dev Library useage for safemath for uint32
    */
    using SafeMath32 for uint32;

    /**
    * @dev mappings
    */
    mapping(uint32 => address) orgPositionToAddress;
    mapping(address => CredentialOrg) addressToCredentialOrg;
    
    /**
    * @dev events for contract
    * One for the create CredentialOrg and one for the basic 'logging'.
    */
    event CredentialOrgCreateEvent(bytes32 shortName, address schoolAddress, string detail);
    event CredentialOrgEvent(address schoolAddress, string detail);

    /**
    * @dev CredentialOrg Count
    */
    uint32 private credentialOrgCount;

    /**
    * @dev Primary CredentialOrg structure, and following array.
    */
    struct CredentialOrg {
        bytes32 shortName;  // School shortName
        bytes6 schoolCode; // Dept of Education "FICE" code
        string officialSchoolName; // official school shortName (70 or less)
        address schoolAddress;
    }
    CredentialOrg[] private credentialOrgs; // array to hold Credentialing Orgs

    /**
    * @dev Modifer onlyBy for Access Control
    */
    modifier onlyBy(address _credentialOrgAddress){
        uint32 foundAccount = 0;
        CredentialOrg testCredentialOrg = addressToCredentialOrg[_credentialOrgAddress];
        if (testCredentialOrg.schoolAddress != 0){
            foundAccount = 1;
        }
        if (foundAccount == 0) revert("Not Authorized");
        _;
    }
    
    /**
    * @dev class constructor
    */
    constructor() public {
        credentialOrgCount = 0;
        createCredentialOrg("INITRECORD", "000000","Initialization Record for owner.");
        //createCredentialOrg("BCD", 0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB, "000000"," BaseRecordFor Account A");
        //createCredentialOrg("SCC",0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C,"003793","Spokane Community College");
        //createCredentialOrg("SFCC",0x4B0897b0513fdC7C541B6d9D7E929C4e5364D2dB, "009544","Spokane Falls Community College");
    }
    
    /**
    * @dev allows owner to create new credentialing orgs
    * @param _shortName shortName of Credentialing orgs
    * @param _schoolCode Credentialing FICE School Code
    * @param _officialSchoolName official School Name
    */
    function createCredentialOrg(bytes32 _shortName, bytes6 _schoolCode, string _officialSchoolName) 
    public
    returns (uint32 position)
    {
        emit CredentialOrgCreateEvent(_shortName, msg.sender, "New Org Add (PRE)");
        require(_shortName.length > 0 && msg.sender != 0 && _schoolCode.length == 6 && bytes(_officialSchoolName).length > 0 && bytes(_officialSchoolName).length < 70);
        position = uint32(credentialOrgs.push(CredentialOrg(_shortName, _schoolCode, _officialSchoolName, msg.sender)));
        if (position > 0){
            orgPositionToAddress[position] = msg.sender;
            addressToCredentialOrg[msg.sender] = credentialOrgs[position.sub(1)];
            credentialOrgCount = credentialOrgCount.add(1);
            emit CredentialOrgCreateEvent(_shortName, msg.sender, "createCredentialOrg (SUCCESS)");
        } else {
            revert("New Org Add (FAIL)");
            emit CredentialOrgCreateEvent(_shortName, msg.sender, "createCredentialOrg (FAIL)");
        }
        return (position);
    }

    /**
    * @dev allows selection of a credentialingOrg by position
    * @param _credentialOrgPosition allows selection of credentialing orgs details.
    */
    function selectCredentialOrgByPosition(uint32 _credentialOrgPosition) 
    public view
    returns (bytes32 shortName, bytes6 schoolCode, string officialSchoolName, address schoolAddress)
    {
        shortName = "";
        schoolCode = "";
        officialSchoolName = "";
        schoolAddress = 0;
        require(_credentialOrgPosition >= 0, "selectCredentialOrg - position had to be greater or equal to 0.");
        if (_credentialOrgPosition < credentialOrgCount){
            emit CredentialOrgEvent(msg.sender, "selectCredentialOrg~position - (SUCCESS)");
            return (credentialOrgs[_credentialOrgPosition].shortName, credentialOrgs[_credentialOrgPosition].schoolCode, credentialOrgs[_credentialOrgPosition].officialSchoolName, credentialOrgs[_credentialOrgPosition].schoolAddress);
        } else {
            emit CredentialOrgEvent(msg.sender, "selectCredentialOrg~position - (FAIL) top boundry exceeded.");
            return (shortName,schoolCode,officialSchoolName,schoolAddress);
        }
    }

    /**
    * @dev allows selection of a credentialingOrg by address
    * @param _credentialOrgAddress allows selection of credentialing orgs details.
    */
    function selectCredentialOrgByAddress(address _credentialOrgAddress) 
    public view
    returns (bytes32 shortName, bytes6 schoolCode, string officialSchoolName, address schoolAddress)
    {
        require(_credentialOrgAddress != 0, "selectCredentialOrg - Address 0 not valid");
        shortName = "";
        schoolCode = "";
        officialSchoolName = "";
        schoolAddress = 0;
        CredentialOrg testCred = addressToCredentialOrg[_credentialOrgAddress];
        if (testCred.schoolAddress != 0){
            emit CredentialOrgEvent(msg.sender, "selectCredentialOrg~address - (SUCCESS)");
            return (testCred.shortName, testCred.schoolCode, testCred.officialSchoolName, testCred.schoolAddress);
        } else {
            emit CredentialOrgEvent(msg.sender, "selectCredentialOrg~address - (FAIL)");
            return (shortName, schoolCode, officialSchoolName, schoolAddress);
        }
        
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
        CredentialOrg testCredentialOrg = addressToCredentialOrg[_credentialOrgAddress];
        if (testCredentialOrg.schoolAddress != 0){
            IsOrgAddress = true;
            emit CredentialOrgEvent(msg.sender, "isCredentialOrg - (SUCCESS)");
        } else {
            emit CredentialOrgEvent(msg.sender, "isCredentialOrg - (FAIL)");
        }
        return (IsOrgAddress);
    }

    /**
    * @dev returns the credentialOrgCount
    */
    function selectOrgCount()
    public view
    returns (uint32 returnOrgCount)
    {
        returnOrgCount = credentialOrgCount;
        emit CredentialOrgEvent(msg.sender, "selectOrgCount - (SUCCESS)");
        return (returnOrgCount);
    }

}