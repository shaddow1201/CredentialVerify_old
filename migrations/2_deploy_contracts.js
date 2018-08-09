var CredentialOrgFactory = artifacts.require("CredentialOrgFactory");
var CredentialFactory = artifacts.require("CredentialFactory");
var ApplicantFactory = artifacts.require("ApplicantFactory");
//var ProcessCredentials = artifacts.require("ProcessCredentials");

module.exports = async(deployer) => {
    let deployCredentialOrgFactory = await deployer.deploy(CredentialOrgFactory);
    let deployCredentialFactory = await deployer.deploy(CredentialFactory);
    contractCredentialFactory = await CredentialFactory.deployed()
    let setAddress = await contractCredentialFactory.setAddress(
        CredentialOrgFactory.address,
        { gas: 200000 }
    );
};
//module.exports = async(deployer) => {
//    let deployOne = await deployer.deploy(CredentialOrgFactory);
//    let deployTwo = await deployer.deploy(CredentialFactory,CredentialFactory.address);
//    //let deployThree = await deployer.deploy(ApplicantFactory);
//  };

//module.exports = (deployer, network) => {
//  deployer.deploy(CredentialOrgFactory).then(function() {
//    return deployer.deploy(CredentialFactory, CredentialOrgFactory.address)
//  });
//};

