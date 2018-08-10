var CredentialOrgFactory = artifacts.require("CredentialOrgFactory");
var CredentialFactory = artifacts.require("CredentialFactory");
var ApplicantFactory = artifacts.require("ApplicantFactory");
//var ProcessCredentials = artifacts.require("ProcessCredentials");

 module.exports = async function(deployer) {
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
  
    results = await Promise.all([
      bInst.setAddress(aInst.address),
      bInst.createCredential("A", "Associate Degree in Basket Weaving", "BA-Arts")
    ]);
  
  };

