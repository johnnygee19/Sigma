# Sigma
Sigma is a fungible token which lives on the Ethereum blockchain in compliance with the ERC20 Token Standard.

## ERC20 Token Standard

Go to https://eips.ethereum.org/EIPS/eip-20 to see the standard API for tokens within smart contracts.

## Hardhat Project Setup

```bash
mkdir sigma
```

```bash
cd sigma
```

```bash
npm init
```

```bash
npm i --save-dev hardhat
```

```bash
npx hardhat
```

```bash
npm i --save-dev "hardhat@^2.11.1" "@nomicfoundation/hardhat-toolbox@^1.0.1"
```

```bash
npm install --save-dev @nomicfoundation/hardhat-chai-matchers
```

```bash
npm install dotenv --save
```

```bash
npx hardhat compile
```

```bash
npx hardhat test
```

```bash
npx hardhat run --network sepolia scripts/deploy.js
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[GNU General Public License v3.0](https://choosealicense.com/licenses/gpl-3.0/)
