# Basic Notes for Geth
## START A NEW PRIVATE BLOCKCHAIN , ENABLING EXPLORER CROS
geth --dev --ipcpath ~/Library/Ethereum/geth.ipc -rpc --rpccorsdomain "http://localhost:8000"
## ATTACH AND START A JS CONSOLE TO  GETH
geth --dev attach
miner.start()
miner.stop()
# Calling pre deployed contract function from JS
*creation of contract object*
var contractToWatch = web3.eth.contract(JSON.parse(ABI));

*initiate contract for an address*
var myContractInstance = contractToWatch.at('0xc4abd0339eb8d57087278718986382264244252f');

*call constant function*
var result = myContractInstance.myConstantMethod('myParam');
console.log(result) // '0x25434534534'

myContractInstance.addAccident.sendTransaction("1",{from: web3.eth.coinbase});

## Some commands to remember
```shell
geth --datadir=./node1 init genesis.json
geth --identity="NODE_ONE" --networkid="500" --datadir=./node1 --rpc --rpcaddr 0.0.0.0
geth --identity="NODE_TWO" --networkid="500" --datadir=./node1 --rpc --rpcaddr 0.0.0.0 --rpcport=8546
geth attach ipc:./geth.ipc
web3.fromWei(eth.getBalance(eth.coinbase), "ether")
eth.getBlock('pending', true)

docker network create ETH
docker run --rm -it -p 8546:8546 --net=ETH <image>
docker network inspect ETH

#!/bin/bash
### Delete all containers
docker rm $(docker ps -a -q)
### Delete all images
docker  rmi -f $(docker images -q)
```

## Evolution of commands
```
curl http://localhost:8545 -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}'

docker run -it -p 127.0.0.1:8545:8545 -p 30303:30303 5e6230054273 geth --networkid="500" --datadir=./node -rpcaddr 0.0.0.0 --rpc --rpccorsdomain "http://ofsblockchain.herokuapp.com" --unlock "0" --password "password" console

geth --datadir ./node1 --networkid 001 --ipcpath ~/Library/Ethereum/geth.ipc console 2>> node1.log

geth --datadir ./node2 --networkid 001 --port 30304 console 2>> node2.log
geth --datadir=./node1 account new
geth --datadir=./node1 init genesis.json
geth --datadir ./node1 --networkid 98765
personal.unlockAccount(eth.accounts[0], "password", 150000)

geth --datadir ./node1 --networkid 0102 --bootnodes enode://afe8e9b6ef1212cd2ef30c93114d1511ef8240bf9d0930a5abde116a7d214e41f16381dd6afa6e21741b7a1fb9c9fad907ac2f37fc7ab44e920bc6b7f86f4ad4@172.17.0.2:30303

geth --datadir ./node1 --identity="NODE_TWO" --networkid="1020" --verbosity=1 --mine --minerthreads=1 --rpc --rpcport=8546
https://www.myetherwallet.com/helpers.html

geth --datadir ./node1--networkid 98765 --port 30304 --bootnodes "enode://afe8e9b6ef1212cd2ef30c93114d1511ef8240bf9d0930a5abde116a7d214e41f16381dd6afa6e21741b7a1fb9c9fad907ac2f37fc7ab44e920bc6b7f86f4ad4@172.17.0.2:30303"

admin.addPeer("enode://afe8e9b6ef1212cd2ef30c93114d1511ef8240bf9d0930a5abde116a7d214e41f16381dd6afa6e21741b7a1fb9c9fad907ac2f37fc7ab44e920bc6b7f86f4ad4@172.17.0.2:30303")
--rpccorsdomain "https://ofiamdb.herokuapp.com"

geth --networkid="500" --datadir=./node --rpc  --rpccorsdomain "https://ofiamdb.herokuapp.com" --unlock "0" --password "password" console 2>> eth.log

```

## Refrences

ABI Program :
http://ethdocs.org/en/latest/contracts-and-transactions/accessing-contracts-and-transactions.html

https://ethereum.github.io/browser-solidity/#version=soljson-v0.4.11+commit.68ef5810.js

Input Data Decoder:
https://lab.miguelmota.com/ethereum-input-data-decoder/example/

Private Ethereum network:
https://gist.github.com/fishbullet/04fcc4f7af90ee9fa6f9de0b0aa325ab
