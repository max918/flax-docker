FROM ubuntu:latest

EXPOSE 6755
EXPOSE 6888

ENV FLAX_ROOT=/root/.flax/mainnet
ENV keys="generate"
ENV harvester="false"
ENV farmer="false"
ENV plots_dir="/plots"
ENV farmer_address=
ENV farmer_port=
ENV testnet="false"
ENV TZ="UTC"
ENV upnp="true"
ENV log_to_file="true"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y bc curl lsb-release python3 tar bash ca-certificates git openssl unzip wget python3-pip sudo acl build-essential python3-dev python3.8-venv python3.8-distutils python-is-python3 vim tzdata && \
    rm -rf /var/lib/apt/lists/* && \
    ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

ARG BRANCH=latest

RUN echo "cloning ${BRANCH}" && \
    git clone --branch ${BRANCH} https://github.com/Flax-Network/flax-blockchain.git && \
    cd flax-blockchain && \
    git submodule update --init mozilla-ca && \
    /usr/bin/sh ./install.sh

ENV PATH=/flax-blockchain/venv/bin:$PATH
WORKDIR /flax-blockchain

COPY docker-start.sh /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["docker-start.sh"]
