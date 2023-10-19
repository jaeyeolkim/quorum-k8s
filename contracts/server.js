const express = require("express");
const ethers = require("ethers");
const path = require("path");
const fs = require("fs-extra");
const app = express();
const port = 3000;
const { quorum } = require("./keys.js");
const ethereumNodeUrl = quorum.rpcnode.url;
const accountPrivateKey = quorum.rpcnode.accountPrivateKey;

// Define the contract ABI and address
const contractJsonPath = path.resolve("./", "SimpleStorage.json");
const contractJson = JSON.parse(fs.readFileSync(contractJsonPath));
const contractABI = contractJson.abi;
const contractAddress = "0xE00e70B84ABB9b8996F67ccfD603F867E8b08e90"; // 배포된 컨트랙트 주소

// Create a contract instance
const provider = new ethers.JsonRpcProvider(ethereumNodeUrl);
const contract = new ethers.Contract(contractAddress, contractABI, provider);

async function getSimpleValue() {
  const res = await contract.get();
  console.log("Obtained value at deployed contract is: " + res);
  return res;
}

// You need to use the accountAddress details provided to Quorum to send/interact with contracts
async function setSimpleValue(store) {
  const wallet = new ethers.Wallet(accountPrivateKey, provider);
  const contractWithSigner = contract.connect(wallet);
  const tx = await contractWithSigner.set(store);
  await tx.wait();
  return tx;
}

app.use("/get", async (req, res) => {
  const result = await getSimpleValue();
  console.log(result);
  res.json({ value: result.toString() });
});

app.use("/set", async (req, res) => {
  const store = req.query.store;
  const tx = await setSimpleValue(store);
  console.log(tx);
  const result = await getSimpleValue();
  res.json({ value: result.toString() });
});

// Start the Express server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
