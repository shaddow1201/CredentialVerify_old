var CredentialOrgFactory = artifacts.require("CredentialOrgFactory");
var CredentialFactory = artifacts.require("CredentialFactory");
var ApplicantFactory = artifacts.require("ApplicantFactory");
//var ProcessCredentials = artifacts.require("ProcessCredentials");

// An async function
//const setCredentialFactory = async function setCredentialFactory() {
//    let setAddress = await contractCredentialFactory.setAddress(
//        CredentialOrgFactory.address,
//        { gas: 200000 }
//    );
//};
//module.exports = (deployer) => {
//    deployer.deploy(CredentialOrgFactory);    
//    deployer.deploy(CredentialFactory).then(() => await setCredentialFactory())
//};

 module.exports = async function(deployer) {
    let aInst, bInst;
  
    await Promise.all([
      deployer.deploy(CredentialOrgFactory),
      deployer.deploy(CredentialFactory)
    ]);
  
    instances = await Promise.all([
        CredentialOrgFactory.deployed(),
        CredentialFactory.deployed()
    ])
  
    aInst = instances[0];
    bInst = instances[1];
  
    results = await Promise.all([
      bInst.setAddress(aInst.address)
    ]);
  
//    const xCheck = await aInst.x.call();
//    const yCheck = await bInst.y.call();
//  
//    console.log('X: ', xCheck, bInst.address);
//    console.log('Y: ', yCheck, aInst.address);
  };

//module.exports = async(deployer) => {
//    let deployCredentialOrgFactory = await deployer.deploy(CredentialOrgFactory);
//    let deployCredentialFactory = await deployer.deploy(CredentialFactory);
//    contractCredentialFactory = await CredentialFactory.deployed()
//    let setAddress = await contractCredentialFactory.setAddress(
//        CredentialOrgFactory.address,
//        { gas: 200000 }
//    );
//};


//module.exports = (deployer, network) => {
//  deployer.deploy(CredentialOrgFactory).then(function() {
//    return deployer.deploy(CredentialFactory, CredentialOrgFactory.address)
//  });
//};

