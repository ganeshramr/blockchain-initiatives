#!/bin/bash
# Start the geth
echo "Attempting to start Geth"
geth --networkid="007" --datadir=./node --rpc --rpccorsdomain "*" --rpcaddr 0.0.0.0 --unlock "0" --password /home/eth_runner/myeth/password --mine 2>> eth.log &
echo "Started Geth waiting for the endpoints to open"
sleep 30;
echo "Started Proxy"
#REPLACE ENV variable in nginx.conf
echo "PORT is" $PORT
sed -i "s/HEROKU_PORT/$PORT/g" /etc/nginx/nginx.conf
nginx &
echo "Private Blockchain Instance Started. Rock On /|>"
while sleep 60; do
  ps aux |grep geth |grep -q -v grep
  PROCESS_1_STATUS=$?
  ps aux |grep nginx |grep -q -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit -1
  fi
  echo "Status Check : Blockchain up and running."
done
