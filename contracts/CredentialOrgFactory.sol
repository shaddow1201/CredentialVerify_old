pragma solidity ^0.4.21;

/**
 * @title CredentialOrgFactory
 * @dev The CredentialOrgFactory allows the contract owner to add new credentialing orgs
 */
import "./Pausable.sol";
import "./SafeMath32.sol";

contract CredentialOrgFactory is Pausable {

    /**
    *  @dev Library useage for safemath for uint32
    */
    using SafeMath32 for uint32;

    /**
    * @dev mappings
    */
    mapping(address => CredentialOrg) addressToCredentialOrg;
    
    /**
    * @dev events for contract
    * One for the create CredentialOrg and one for the basic 'logging'.
    */
    event CredentialOrgCreateEvent(string shortName, address schoolAddress, string detail);
    event CredentialOrgEvent(address schoolAddress, string detail);

    /**
    * @dev CredentialOrg Count
    */
    uint32 private credentialOrgCount;

    /**
    * @dev Primary CredentialOrg structure, and following array.
    */
    struct CredentialOrg {
        string shortName;  // School shortName (len 30)
        string officialSchoolName; // official school shortName (70 or less)
        address schoolAddress;
    }
    
    CredentialOrg[] private credentialOrgs; // array to hold Credentialing Orgs

    /**
    * @dev class constructor
    */
    constructor() public {
        credentialOrgCount = 0;
    }
    
    /**
    * @dev allows owner to create new credentialing orgs
    * @param _shortName shortName of Credentialing orgs
    * @param _officialSchoolName official School Name
    * @param _schoolAddress address of credential org.
    */
    function createCredentialOrg(string _shortName, string _officialSchoolName, address _schoolAddress) 
    public 
    returns (bool createStatus)
    {
        emit CredentialOrgCreateEvent(_shortName, _schoolAddress, "New Org Add (PRE)");
        require(bytes(_shortName).length > 0 && bytes(_shortName).length < 31, "createCredentialOrg shortName problem");
        require(bytes(_officialSchoolName).length > 0 && bytes(_officialSchoolName).length < 70, "createCredentialOrg officalSchoolName length problem");
        require(_schoolAddress != 0, "createCredentialOrg (FAIL) school Address can not be 0");
        createStatus = false;

        uint32 position = uint32(credentialOrgs.push(CredentialOrg(_shortName, _officialSchoolName, _schoolAddress)));
        if (position > 0){
            addressToCredentialOrg[_schoolAddress] = credentialOrgs[position.sub(1)];
            credentialOrgCount = credentialOrgCount.add(1);
            createStatus = true;
            emit CredentialOrgCreateEvent(_shortName, _schoolAddress, "createCredentialOrg (SUCCESS)");
        } else {
            emit CredentialOrgCreateEvent(_shortName, _schoolAddress, "createCredentialOrg (FAIL)");
        }
        return (createStatus);
    }

    /**
    * @dev allows selection of a credentialingOrg by position
    * @param _credentialOrgPosition allows selection of credentialing orgs details.
    */
    function selectCredentialOrgByPosition(uint32 _credentialOrgPosition) 
    public view
    returns (string shortName, string officialSchoolName, address schoolAddress)
    {
        shortName = "";
        officialSchoolName = "";
        schoolAddress = 0;
        require(_credentialOrgPosition >= 0, "selectCredentialOrg - position had to be greater or equal to 0.");
        if (_credentialOrgPosition < credentialOrgCount){
            emit CredentialOrgEvent(msg.sender, "selectCredentialOrg~position - (SUCCESS)");
            return (credentialOrgs[_credentialOrgPosition].shortName, credentialOrgs[_credentialOrgPosition].officialSchoolName, credentialOrgs[_credentialOrgPosition].schoolAddress);
        } else {
            emit CredentialOrgEvent(msg.sender, "selectCredentialOrg~position - (FAIL) top boundry exceeded.");
            return (shortName, officialSchoolName, schoolAddress);
        }
    }

    /**
    * @dev allows selection of a credentialingOrg by address
    * @param _credentialOrgAddress allows selection of credentialing orgs details.
    */
    function selectCredentialOrgByAddress(address _credentialOrgAddress) 
    public view
    returns (string shortName, string officialSchoolName, address schoolAddress)
    {
        require(_credentialOrgAddress != 0, "selectCredentialOrg - Address 0 not valid");
        CredentialOrg memory testCred = addressToCredentialOrg[_credentialOrgAddress];
        if (testCred.schoolAddress != 0){
            emit CredentialOrgEvent(msg.sender, "selectCredentialOrg~address - (SUCCESS)");
            return (testCred.shortName, testCred.officialSchoolName, testCred.schoolAddress);
        } else {
            emit CredentialOrgEvent(msg.sender, "selectCredentialOrg~address - (FAIL)");
            return ("", "", 0);
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
        CredentialOrg memory testCredentialOrg = addressToCredentialOrg[_credentialOrgAddress];
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