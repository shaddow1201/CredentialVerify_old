var CredentialOrgFactory = artifacts.require("CredentialOrgFactory");
var CredentialFactory = artifacts.require("CredentialFactory");
var ApplicantFactory = artifacts.require("ApplicantFactory");
var ProcessCredentials = artifacts.require("ProcessCredentials");

 module.exports = async function(deployer, network, accounts) {
    let aInst, bInst;
  
    await Promise.all([
      deployer.deploy(CredentialOrgFactory),
      deployer.deploy(CredentialFactory),
      deployer.deploy(ApplicantFactory),
      deployer.deploy(ProcessCredentials)
    ]);
  
    instances = await Promise.all([
        CredentialOrgFactory.deployed(),
        CredentialFactory.deployed(),
        ApplicantFactory.deployed(),
        ProcessCredentials.deployed()
    ])
  
    aInst = instances[0];
    bInst = instances[1];
    cInst = instances[2];
    dInst = instances[3];
  
    results = await Promise.all([
      bInst.setAddress(aInst.address),
      cInst.setAddress(aInst.address),
      bInst.createCredential("A", "AAAA", "BA-Arts"),
      dInst.setAddress(aInst.address, bInst.address, cInst.address)
    ]);
  
  };

