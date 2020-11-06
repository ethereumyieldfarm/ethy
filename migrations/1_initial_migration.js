const Migrations = artifacts.require("Migrations");
const ETHY = artifacts.require("ETHY");

module.exports = async function (deployer) {
  console.log("deploying...");
  await deployer.deploy(ETHY);
  console.log("deployed");
};
