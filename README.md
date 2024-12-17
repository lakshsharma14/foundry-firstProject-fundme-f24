  
  # FundMe smart contract

The `FundMe` smart contract enables users to deposit funds in Wei, with the requirement that the amount must exceed a specified `MINIMUM_USD` value in USD. This project leverages [Chainlink Data Feeds](https://data.chain.link/) to convert the deposited Wei into its equivalent USD value. Subsequently, the contract owner has the ability to withdraw these funds.

### Requirements

 - `FundMe` contract use a Foundry framework. [Install foundry](https://getfoundry.sh/)

### Work with project

1. Clone git repo and build project

```bash
git clone https://github.com/AsyaMaior/foundry-fund-me-f23
cd foundry-fund-me-f23
forge build
```

2. Install the dependencies

```bash
make install
```

This project relies on the following dependencies:

- [chainlink-brownie-contracts](https://github.com/smartcontractkit/chainlink-brownie-contracts) for interacting with Chainlink Price Feeds.
- [foundry-devops](https://github.com/cyfrin/foundry-devops) for creating interaction scripts with the contract.

To utilize `foundry-devops`, you may need to install `jq`, a lightweight and flexible command-line JSON processor. You can install `jq` using `sudo apt-get install jq` (for Debian) or verify its installation by running `jq --version`. Additionally, ensure the `ffi = true` setting is enabled in the `foundry.toml` file for the tool to function correctly.

3. To deploy and interact with the contract, create your `.env` file; an example is provided in the repository. Than utilize a `Makefile` .

```bash
# to deploy to a specific network
make deploy-anvil
make deploy-sepolia

# to interact with contract in a specific network
make fund-anvil
make fund-sepolia

make withdraw-anvil
make withdraw-anvil
```

4. To run tests use the following command:

```bash
forge test
```

To run tests using a forked mainnet network, use the following command:

```bash
make fork-test_mainnet-eth
#or
make fork-test_mainnet-arb
```

To view the test coverage, utilize the following command:

```bash
forge coverage
```

![test_coverage](./test_coverage.png)


5. You can generate two types of reports:  `gas report` and `coverage report`

To use the coverage report, you need to install the  `genhtml` utilite. To install use `pip install genhtml` or verify its installation by running `genhtml -version` 

Then, use the command:

```bash
make coverage-report
```

To create a gas report, use:

```bash
make gas-report
```

---
This project was created and finalized while completing a course on [Cyfrin Updraft](https://updraft.cyfrin.io/) 