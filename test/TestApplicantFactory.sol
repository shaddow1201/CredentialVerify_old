pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ApplicantFactory.sol";

contract TestApplicantFactory {
    ApplicantFactory applicantFactory = ApplicantFactory(DeployedAddresses.ApplicantFactory());

    function testSelectApplicantCount() public {
        uint256 testVal = credentialFactory.SelectApplicantCount();
        uint256 expected = 0;
        Assert.equal(testVal, expected, "Expected Credential Count (0)");
    }

}
