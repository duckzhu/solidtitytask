require("@nomicfoundation/hardhat-toolbox");
require("hardhat-deploy");
require("hardhat-deploy-ethers");
require("@nomicfoundation/hardhat-ethers");
//覆盖率插件
require("solidity-coverage");
/** @type import('hardhat/config').H  ardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  namedAccounts: {
    firstAccount: 0,
    secondAccount: 1,
    thirdAccount: 2
  },
};
