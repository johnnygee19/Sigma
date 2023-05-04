const { expect } = require("chai");
const hre = require("hardhat");

describe("Sigma smart contract", function() {
  let contract;
  let sigma;
  let owner;
  let address1;
  let address2;
  let capacity = 100000000; // 100_000_000
  let blockReward = 40;
  let initialSupply = 80000000 // 80_000_000

  beforeEach(async function () {
    contract = await hre.ethers.getContractFactory("Sigma");
    [owner, address1, address2] = await hre.ethers.getSigners();
    sigma = await contract.deploy(initialSupply, capacity, blockReward);
  });

  describe("Deployment", function () {
    it("Should make sure the owner is the one who deploys the contract.", async function () {
      expect(await sigma.owner()).to.equal(owner.address);
    });

    it("Should make sure the tokens minted so far (total supply) are equal to the owner's balance who is the minter.", async function () {
      const ownerBalance = await sigma.balanceOf(owner.address);
      expect(await sigma.totalSupply()).to.equal(ownerBalance);
    });
    /*
    AssertionError: expected 8e-11 to equal 80000000
      + expected - actual

      -8e-11
      +80000000
    */
    it("Should make sure the maximum supply was set correctly after the deployment.", async function () {
      const capacityAfterDeployment = await sigma.capacity();
      expect(Number(hre.ethers.utils.formatEther(capacityAfterDeployment))).to.equal(capacity);
    });

    /*
      AssertionError: expected 4e-17 to equal 40
      + expected - actual

      -4e-17
      +40
    */
    it("Should make sure the block reward was set correctly after the deployment.", async function () {
      const blockRewardAfterDeployment = await sigma.blockReward();
      expect(Number(hre.ethers.utils.formatEther(blockRewardAfterDeployment))).to.equal(blockReward);
    });
  });

  describe("Transactions", function () {
    it("Should transfer tokens between accounts.", async function () {
      // Transfer 40 tokens from owner to address1
      await sigma.transfer(address1.address, 40);
      const balance1 = await sigma.balanceOf(address1.address);
      expect(balance1).to.equal(40);

      // Transfer 40 tokens from address1 to address2
      // We use .connect(signer) to send a transaction from another account
      await sigma.connect(address1).transfer(address2.address, 40);
      const balance2 = await sigma.balanceOf(address2.address);
      expect(balance2).to.equal(40);
    });

    it("Should fail if the sender doesn't have enough tokens.", async function () {
      const initialOwnerBalance = await sigma.balanceOf(owner.address);
      // Try to send 1 token from address1 (0 tokens) to owner (1000000 tokens).
      // `require` will return a boolean value of false and revert the transaction.
      await expect(
        sigma.connect(address1).transfer(owner.address, 1)
      ).to.be.reverted;

      // Owner's balance shouldn't have changed.
      expect(await sigma.balanceOf(owner.address)).to.equal(initialOwnerBalance);
    });

    it("Should update the balances after the transfers.", async function () {
      const initialOwnerBalance = await sigma.balanceOf(owner.address);

      // Transfer 100 tokens from owner to address1.
      await sigma.transfer(address1.address, 100);

      // Transfer another 40 tokens from owner to address2.
      await sigma.transfer(address2.address, 40);

      // Check the balances of owner, address1, and address2.
      const finalOwnerBalance = await sigma.balanceOf(owner.address);
      expect(finalOwnerBalance).to.equal(initialOwnerBalance.sub(140));

      const balance1 = await sigma.balanceOf(address1.address);
      expect(balance1).to.equal(100);

      const balance2 = await sigma.balanceOf(address2.address);
      expect(balance2).to.equal(40);
    });
  });
});