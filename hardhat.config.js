require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("@nomicfoundation/hardhat-chai-matchers");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.4.24",
  networks: {
    sepolia: {
      url: process.env.INFURA_SEPOLIA_ENDPOINT,
      accounts: [process.env.PRIVATE_KEY]
    }
  },
};
