FROM kunstmaan/ethereum-geth

#Ethereum setup

LABEL version="1.0"
LABEL maintainer="ganeshram.ramamurthy@objectfrontier.com"

RUN adduser --disabled-login --gecos "" eth_runner
RUN mkdir -p /home/eth_runner/myeth/node

RUN apt-get update && apt-get install -y curl less bash openssh-client openssh-server python
#ADD ./.profile.d /app/.profile.d

COPY genesis.json /home/eth_runner/myeth
COPY password /home/eth_runner/myeth

# Install Nginx.
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

COPY nginx.conf /etc/nginx/

#back to eth
#RUN chown -R eth_runner:eth_runner /home/eth_runner/myeth
#USER eth_runner

WORKDIR /home/eth_runner/myeth

RUN geth --datadir=./node init genesis.json
RUN geth --datadir=./node account new --password /home/eth_runner/myeth/password
COPY startupservices.sh /home/eth_runner/myeth
CMD /home/eth_runner/myeth/startupservices.sh
