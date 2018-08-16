# Credential Verify

Credential Verify is intended to be an off-chain enterprise solution pointed at verifying Educational Institutions awarded credentials cryptographically.

## What it does
1. allows the creation of CredentialOrgs (CredentialOrgFactory.sol)
2. allows those CredentialOrgs to create Credentials for themselves (CredentialFactory.sol)
3. allows Applicants to apply to credentiallying orgs for Credentials (ApplicantFactory.sol)
4. allows CredentialOrgs to to take and apply credentials to Applicants (ProcessApplicants.sol)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

1. Truffle install - https://github.com/trufflesuite/truffle
2. ganache-cli install - https://github.com/trufflesuite/ganache-cli
3. project files (this git collection)

### Installing

1. Copy files to CredentialVerify Directory
2. run ganache-cli with following mnemonic "delay film punch stool adult expect bulb grab clinic lawsuit clown amused"

```
ganache-cli -port 8545 -m "delay film punch stool adult expect bulb grab clinic lawsuit clown amused"
```

3. Compile truffle

```
truffle compile
```

3. Migrate

```
truffle migrate
```

## Tests

Explain how to run the automated tests for this system

### Break down into end to end tests

Explain what these tests test and why

```
Give an example
```

### And coding style tests

Explain what these tests test and why

```
Give an example
```

## Built With

* [Truffle Suite](https://truffleframework.com) - Truffle Suite Framework.
* [ganache-cli](https://github.com/trufflesuite/ganache-cli) - Ganache-cli (command line)
* [truffle react box]() - used as base

## Authors

* **Richard Noordam ** 

