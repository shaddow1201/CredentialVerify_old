var CredentialOrgFactory = artifacts.require("CredentialOrgFactory");
var CredentialFactory = artifacts.require("CredentialFactory");
var ApplicantFactory = artifacts.require("ApplicantFactory");
//var ProcessCredentials = artifacts.require("ProcessCredentials");

module.exports = function(deployer) {
  deployer.deploy(CredentialOrgFactory);
  deployer.deploy(CredentialFactory);
  deployer.deploy(ApplicantFactory);
  //deployer.deploy(ProcessCredentials);
};


