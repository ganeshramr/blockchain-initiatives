FROM kunstmaan/ethereum-geth

LABEL version="1.0"
LABEL maintainer="ganeshram.ramamurthy@objectfrontier.com"
RUN apt-get update && apt-get install -y curl less bash openssh-client openssh-server python
RUN adduser --disabled-login --gecos "" eth_runner
RUN mkdir /home/eth_runner/myeth
RUN mkdir /home/eth_runner/myeth/node
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
COPY genesis.json /home/eth_runner/myeth
COPY password /home/eth_runner/myeth

RUN chown -R eth_runner:eth_runner /home/eth_runner/myeth

USER eth_runner

WORKDIR /home/eth_runner/myeth

RUN geth --datadir=./node init genesis.json
RUN geth --datadir=./node account new --password /home/eth_runner/myeth/password
CMD geth --networkid="007" --datadir=./node --rpc --rpccorsdomain "*" --rpcaddr 0.0.0.0 --rpcport=8080 --unlock "0" --password "/home/eth_runner/myeth/password" --mine
