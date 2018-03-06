FROM kunstmaan/ethereum-geth

#Ethereum setup

LABEL version="1.0"
LABEL maintainer="ganeshram.ramamurthy@objectfrontier.com"

RUN adduser --disabled-login --gecos "" eth_runner
RUN mkdir -p /home/eth_runner/myeth/node

RUN apt-get update && apt-get install -y curl less bash
ADD ./.bash_profile ~/

COPY genesis.json /home/eth_runner/myeth
COPY password /home/eth_runner/myeth

#RUN chown -R eth_runner:eth_runner /home/eth_runner/myeth
#USER eth_runner


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

WORKDIR /home/eth_runner/myeth
RUN geth --datadir=./node init genesis.json
COPY UTC--2018-02-27T20-51-38.597613000Z--79fb532c7949ee7157c6817beaccf3230cea2865 /home/eth_runner/myeth/node/keystore
COPY startupservices.sh /home/eth_runner/myeth

#ADMIN APP STUFFS
RUN mkdir -p /home/eth_runner/myeth/admin
COPY admin-app /home/eth_runner/myeth/admin

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get -y autoclean && apt-get  install -y git
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 8.9.1
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
RUN node -v
RUN npm -v

CMD /home/eth_runner/myeth/startupservices.sh
