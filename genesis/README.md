## Flow of the process:

- Create private/public keys for the validators & update the secrets/validator-keys-secret.yaml with the validator private keys
- Update the configmap/configmap.yml with the public keys & genesis file
- Run kubectl

## NOTE:

### 0. Create a Storage if it does not exists

```bash
cd nfs
./deploy.sh
```

#### 1. Create

by quorum-genesis-tool:

```bash
./install.sh
```

#### 2. Genesis.json

Copy the genesis.json file and copy its contents into the configmap/configmap as shown

#### 3. Update any more config if required

eg: To alter the number of nodes on the network, alter the `replicas: 2` in the deployments/node-deployments.yaml to suit

#### 4. Deploy:

```bash
./deploy.sh
```

#### 5. In the dashboard, you will see each bootnode deployment & service, nodes & a node service, miner if enabled, secrets(opaque) and a configmap

```bash
TODO dashboard
```

#### 6. Verify that the nodes are communicating:

```bash
./jsonrpc.sh

# which should return:
The result confirms that the node running the JSON-RPC service has two peers:
{
  "jsonrpc" : "2.0",
  "id" : 1,
  "result" : "0x5"
}

```

#### 7. Monitoring

https://monitoring.ledgermaster.kr/

#### 8. Delete

```
./remove.sh
```
