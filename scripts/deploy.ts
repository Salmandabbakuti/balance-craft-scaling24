import { ethers } from "hardhat";

async function main() {
  const balanceCraftInstance = await ethers.deployContract("BalanceCraft");

  await balanceCraftInstance.waitForDeployment();
  return balanceCraftInstance;
}

main()
  .then(async (contractInstance) => {
    console.log("BalanceCraft Contract deployed to:", contractInstance.target);
  })
  .catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
