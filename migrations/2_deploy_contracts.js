var CredentialOrgFactory = artifacts.require("CredentialOrgFactory");  
var CredentialFactory = artifacts.require("CredentialFactory");        
var ApplicantFactory = artifacts.require("ApplicantFactory");          
var ProcessApplicants = artifacts.require("ProcessApplicants");      

 module.exports = async function(deployer, accounts) {
    let aInst, bInst, cInst, dInst;
  
    await Promise.all([
      deployer.deploy(CredentialOrgFactory),
      //deployer.deploy(CredentialFactory),
      //deployer.deploy(ApplicantFactory),
      //deployer.deploy(ProcessApplicants)
    ]);
  
    instances = await Promise.all([
      CredentialOrgFactory.deployed(),
      //CredentialFactory.deployed(),
      //ApplicantFactory.deployed(),
      //ProcessApplicants.deployed()
    ])
  
    aInst = instances[0];
    //bInst = instances[1];
    //cInst = instances[2];
    //dInst = instances[3];
  
    results = await Promise.all([
      //bInst.setAddress(aInst.address),
      //cInst.setAddress(aInst.address),
      //bInst.createCredential("TESTRECA", "AAAA", "AAAAAA"),
      //dInst.setAddress(aInst.address, bInst.address, cInst.address)
    ]);
  
  };

