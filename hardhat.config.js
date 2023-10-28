require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const RPC_URL_GANACHE = process.env.RPC_URL_GANACHE;
const PRIVATE_KEY_GANACHE = process.env.PRIVATE_KEY_GANACHE;

const RPC_URL_ALCHEMY = process.env.RPC_URL_ALCHEMY;
const PRIVATE_KEY_ALCHEMY = process.env.PRIVATE_KEY_ALCHEMY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	solidity: "0.8.19",
	defaultNetwork: "ganache",
	networks: {
		ganache: {
			url: RPC_URL_GANACHE,
			accounts: [PRIVATE_KEY_GANACHE],
			chainId: 1337,
		},
		sepolia: {
			url: RPC_URL_ALCHEMY,
			accounts: [PRIVATE_KEY_ALCHEMY],
			chainId: 11155111,
			blockConfirmations: 6,
		},
	},
};
