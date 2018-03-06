#!/bin/bash
# Start the geth
echo "Attempting to start Geth"
geth --networkid="007" --datadir=./node --rpc --rpccorsdomain "*" --rpcaddr 0.0.0.0 --unlock "0" --password /home/eth_runner/myeth/password --mine 2>> eth.log &
echo "Started Geth waiting for the endpoints to open"
sleep 10;
echo "Installing Admin App"

apt-get -qq update && apt-get -y autoclean
apt-get -qq update
apt-get -qq install git
curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash > /dev/null
chmod -R 700 $NVM_DIR
source /usr/local/nvm/nvm.sh
$NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm alias default $NODE_VERSION && nvm use default >/dev/null
echo "Patience is a virtue"
cd /home/eth_runner/myeth/admin
echo "Starting admin app"
npm install >/dev/null
node app.js &
echo "See we are 90 % done.Started admin app, waiting for ports to open"
sleep 10;
echo "Starting Proxy server"
#REPLACE ENV variable in nginx.conf
echo "PORT for PROXY is" $PORT
sed -i "s/HEROKU_PORT/$PORT/g" /etc/nginx/nginx.conf
nginx &
echo "Private Blockchain Instance Started. Rock On /|>"
while sleep 60; do
  ps aux |grep geth |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep nginx |grep -q -v grep
  PROCESS_2_STATUS=$?
  ps aux |grep node |grep -q -v grep
  PROCESS_3_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_3_STATUS -ne 0]; then
    echo "One of the processes has already exited."
    exit -1
  fi
  echo "Status Check : Blockchain and Admin Interface are up and running."
done
