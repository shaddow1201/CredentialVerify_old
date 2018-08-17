var CredentialOrgFactory = artifacts.require("CredentialOrgFactory");  
var CredentialFactory = artifacts.require("CredentialFactory");        
var ApplicantFactory = artifacts.require("ApplicantFactory");          
var ProcessApplicants = artifacts.require("ProcessApplicants");      

 module.exports = async function(deployer, accounts) {
    let aInst, bInst, cInst, dInst;
    let aAccount;
  
    await Promise.all([
      deployer.deploy(CredentialOrgFactory),
      deployer.deploy(CredentialFactory),
      deployer.deploy(ApplicantFactory),
      deployer.deploy(ProcessApplicants)
    ]);
  
    instances = await Promise.all([
      CredentialOrgFactory.deployed(),
      CredentialFactory.deployed(),
      ApplicantFactory.deployed(),
      ProcessApplicants.deployed()
    ])
  
    aInst = instances[0];
    bInst = instances[1];
    cInst = instances[2];
    dInst = instances[3];
    aAccount = accounts[0];
  
    results = await Promise.all([
      // stuff for A.
      aInst.createCredentialOrg("INITRECORD", "BASE INIT RECORD", 0x5a186B7FeC36909678211F69beB67EC3b1E4fFBB),
      // don't think i need the next two.
      //aInst.createCredentialOrg("CREDENTIAL", "CREDENTIAL CONTRACT", bInst.address),
      //aInst.createCredentialOrg("APPLICANT", "APPLICANT CONTRACT", cInst.address),
      bInst.setAddress(aInst.address),
      cInst.setAddress(aInst.address),
      dInst.setAddress(aInst.address, bInst.address, cInst.address)
    ]);

  };