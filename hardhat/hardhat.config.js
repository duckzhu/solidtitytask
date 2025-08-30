require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require('hardhat-deploy');
require("@openzeppelin/hardhat-upgrades");


const SEPOLIA_URL  = process.env.SEPOLIA_URL
const PRIVATE_KEY1 = process.env.PRIVATE_KEY1
const PRIVATE_KEY2 = process.env.PRIVATE_KEY2
const PRIVATE_KEY3 = process.env.PRIVATE_KEY3
const API_KEY = process.env.API_KEY

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.22",
  networks: {
    sepolia: {
      url: SEPOLIA_URL,
      accounts: [PRIVATE_KEY1,PRIVATE_KEY2,PRIVATE_KEY3],
      chainId: 11155111
    }
  },
  etherscan: {
    apiKey: {
      sepolia: API_KEY
    }
  },

};
