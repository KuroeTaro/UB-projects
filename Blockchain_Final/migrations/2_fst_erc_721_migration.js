// Help Truffle find `TruffleTutorial.sol` in the `/contracts` directory
const fst_erc_721 = artifacts.require("fst_erc_721");

module.exports = function(deployer) {
  // Command Truffle to deploy the Smart Contract
  deployer.deploy(fst_erc_721);
};