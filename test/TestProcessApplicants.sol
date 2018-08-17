pragma solidity ^0.4.21;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ProcessApplicants.sol";

contract TestProcessApplicants {
    ProcessApplicants processApplicants = ProcessApplicants(DeployedAddresses.ProcessApplicants());

    address account0 = 0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB;

    /**
    * @dev Checks Owner address vs expected.   Makes sure that the contract was deployed properly.
    */
    function testCheckContractOwner() public {

        address contractOwner = processApplicants.getOwner();
        address expected = account0;

        Assert.equal(contractOwner, expected, "Check Owner");
    }

}