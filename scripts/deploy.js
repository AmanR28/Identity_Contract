const { ethers, network } = require("hardhat");

async function main() {
	console.log("Contract Btp Deploying on Network :", network.name);
	const BtpContract = await ethers.getContractFactory("Btp");
	const btpContract = await BtpContract.deploy();
	await btpContract.waitForDeployment();

	const btpAddress = await btpContract.getAddress();
	console.log("Contract Btp Deployed at " + btpAddress);
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
