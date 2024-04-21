# Balance Craft

BalanceCraft is a groundbreaking NFT (Non-Fungible Token) platform where users can mint unique digital assets by sending Ethereum to the contract. Each transaction triggers the creation of a personalized NFT for the user, with attributes dynamically adjusted based on the amount of ETH deposited. As users accumulate ETH over time, their NFTs evolve, unlocking prestigious levels and ranks such as bronze, gold, and diamond.

## Features

- Mint unique NFTs by sending ETH to the contract
- Evolving NFTs based on accumulated ETH, unlocking prestigious ranks
- Withdraw funds anytime
- Dynamic attributes based on the amount of ETH deposited

### Getting Started

```bash

npm install

# Compile the contracts
npx hardhat compile

# Set your private key
npx hardhat vars set PRIVATE_KEY

# Deploy the contract
npx hardhat run scripts/deploy.ts --network arbitrumSepolia
```

### Usage

Send ETH to the deployed contract address to mint your NFT!. Send between 0 to 1 ETH to mint rank nfts. Your nft attributes will be updated based on the amount of ETH you send. You can withdraw your funds anytime.

For quick demo purposes, Send aribtrum sepolia testnet eth to the address `0xf22e5533157cB4917E7d45e0ee78aFaeBCe1bb01` to mint your NFT and see the magic happen.

## Safety

This project is a proof of concept and should not be used in a production environment. The code has not been audited and is not safe to use with real funds.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
