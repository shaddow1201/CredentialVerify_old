var CredentialOrgFactory = artifacts.require("CredentialOrgFactory");
var CredentialFactory = artifacts.require("CredentialFactory");
var ApplicantFactory = artifacts.require("ApplicantFactory");
//var ProcessCredentials = artifacts.require("ProcessCredentials");

 module.exports = async function(deployer, network, accounts) {
    let aInst, bInst;
  
    await Promise.all([
      deployer.deploy(CredentialOrgFactory),
      deployer.deploy(CredentialFactory),
      deployer.deploy(ApplicantFactory)
    ]);
  
    instances = await Promise.all([
        CredentialOrgFactory.deployed(),
        CredentialFactory.deployed(),
        ApplicantFactory.deployed()
    ])
  
    aInst = instances[0];
    bInst = instances[1];
    cInst = instances[2];
  
    results = await Promise.all([
      bInst.setAddress(aInst.address),
      cInst.setAddress(aInst.address),
      bInst.createCredential("A", "AAAA", "BA-Arts")
      //cInst.createApplicant(accounts[0], "519139038", "10100942", "Richard", "Noordam")
    ]);
  
  };

