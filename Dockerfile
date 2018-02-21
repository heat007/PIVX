FROM debian:jessie
MAINTAINER heat007 - https://github.com/heat007

ENV COLX_VERSION=1.0.0 \
 COLX_USER=colx

ENV COLX_URL=https://github.com/ColossusCoinXT/ColossusCoinXT/releases/download/v$COLX_VERSION/ColossusCoinXT-$COLX_VERSION-x86_64-linux-gnu.tar.gz \
 COLX_CONF=/home/$COLX_USER/.colx/ColossusCoinXT.conf

RUN apt-get -qq update && \
apt-get install -yq wget ca-certificates pwgen && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
wget $COLX_URL -O /tmp/colx.tar.gz && \
mkdir -p /opt && \
cd /opt && \
tar xvzf /tmp/colx.tar.gz && \
rm /tmp/colx.tar.gz && \
ln -sf colx-$COLX_VERSION colx && \
ln -sf /opt/colx/bin/colxd /usr/local/bin/colxxd && \
ln -sf /opt/colx/bin/colx-cli /usr/local/bin/colx-cli && \
ln -sf /opt/colx/bin/colx-tx /usr/local/bin/colx-tx && \
adduser --uid 1000 --system ${COLX_USER} && \
mkdir -p /home/${COLX_USER}/.colx/ && \
chown -R ${COLX_USER} /home/${COLX_USER} && \
echo "success: $COLX_CONF"

USER pivx
RUN echo "rpcuser=colx" > ${COLX_CONF} && \
	echo "rpcpassword=`pwgen 32 1`" >> ${COLX_CONF} && \
	echo "Success"

EXPOSE 51472
VOLUME ["/home/colx/.colx"]
WORKDIR /home/colx

ENTRYPOINT ["/usr/local/bin/colxd"]


