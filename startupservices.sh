#!/bin/bash
# Start the geth
geth --networkid="007" --datadir=./node --rpc --rpccorsdomain "*" --rpcaddr 0.0.0.0 --unlock "0" --password "password" --mine 2>> eth.log &
sleep 30;

#REPLACE ENV variable in nginx.conf
echo "PORT is" $PORT
sed -i "s/HEROKU_PORT/$PORT/g" /etc/nginx/nginx.conf
nginx &

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
done
