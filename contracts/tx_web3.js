const path = require("path");
const fs = require("fs-extra");
const { quorum } = require("./keys.js");
const host = quorum.rpcnode.url;
const address = quorum.rpcnode.accountAddress;

// read in the contracts
const contractJsonPath = path.resolve("./", "SimpleStorage.json");
const contractJson = JSON.parse(fs.readFileSync(contractJsonPath));
const contractAbi = contractJson.abi;
const contractBytecode = contractJson.bytecode;

async function createContract(
  host,
  contractAbi,
  contractByteCode,
  contractInit,
  fromAddress
) {
  const web3 = new Web3(host);
  const contractInstance = new web3.eth.Contract(contractAbi);
  const ci = await contractInstance
    .deploy({ data: "0x" + contractByteCode, arguments: [contractInit] })
    .send({ from: fromAddress, gasLimit: "0x24A22" })
    .on("transactionHash", function (hash) {
      console.log("The transaction hash is: " + hash);
    });
  return ci;
}

// create the contract
async function main() {
  createContract(host, contractAbi, contractByteCode, 47, address)
    .then(async function (ci) {
      console.log("Address of transaction: ", ci.options.address);
    })
    .catch(console.error);
}
