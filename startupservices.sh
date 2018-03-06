#!/bin/bash
# Start the geth
echo "Attempting to start Geth"
geth --networkid="007" --datadir=./node --rpc --rpccorsdomain "*" --rpcaddr 0.0.0.0 --unlock "0" --password /home/eth_runner/myeth/password --mine 2>> eth.log &
echo "Started Geth waiting for the endpoints to open"
sleep 5;
echo "Starting PROXY server"
#REPLACE ENV variable in nginx.conf
sed -i "s/HEROKU_PORT/$PORT/g" /etc/nginx/nginx.conf
nginx &
echo "Installing Admin App"
#touch ~/.bashrc
#apt-get  update
#apt-get  -y autoclean
#echo $PATH
#curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
#chmod -R 700 $NVM_DIR
#source /usr/local/nvm/nvm.sh
#$NVM_DIR/nvm.sh && nvm install $NODE_VERSION  && nvm alias default $NODE_VERSION  && nvm use default

cd /home/eth_runner/myeth/admin

echo "Installing your Blockchain Admin DApp"
echo "Patience is a virtue"
npm install
node app.js &
echo "Started the Admin DApp"
sleep 5;

echo "Your Private Blockchain Instance Started.Wait atlest 5 mins before deploying your first contract. Rock On /|>"
while sleep 600; do
  ps aux |grep geth |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep nginx |grep -q -v grep
  PROCESS_2_STATUS=$?
  ps aux |grep node |grep -q -v grep
  PROCESS_3_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_3_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit -1
  fi
  echo "Status Check : Blockchain and Admin Interface are up and running."
done
