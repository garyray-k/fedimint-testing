#!/bin/bash
if docker ps -a | grep fedimint0; then
	docker container stop fedimint0
	docker rm fedimint0
else
	echo "fedimint0 not found"
fi
if docker ps -a | grep fedimint1; then
	docker container stop fedimint1
	docker rm fedimint1
else
	echo "fedimint1 not found"
fi

docker run \
	-e RUST_LOG=debug \
	-e FM_PASSWORD=test123 \
	-e FM_LISTEN_UI=0.0.0.0:18173 \
	-p 18173:18173 \
	-e FM_ELECTRUM_RPC=mempool.space:60002 \
	-e FM_BIND_P2P=172.18.0.2:18174 \
	-p 18174:18174 \
	-e FM_P2P_URL=fedimint://172.18.0.2:18174 \
	-e FM_BIND_API=172.18.0.2:18175  \
	-e FM_API_URL=ws://172.18.0.2:18175 \
	-p 18175:18175 \
	-e FM_FEDIMINT_DATA_DIR=/fedimint-config0/server \
    -v /home/gary-fedimint/fedimint-testing/config/0:/fedimint-config0 \
	-e FM_CFG_DIR=/fedimint-config0 \
	-d \
	--network fedinet \
	--ip 172.18.0.2 \
	--name fedimint0 \
	fedimint/fedimintd:master 


docker run \
	-e RUST_LOG=debug \
	-e FM_PASSWORD=test123 \
	-e FM_LISTEN_UI=0.0.0.0:18183 \
	-p 18183:18183 \
	-e FM_ELECTRUM_RPC=mempool.space:60002 \
	-e FM_BIND_P2P=172.18.0.3:18184  \
	-p 18184:18184 \
	-e FM_P2P_URL=fedimint://172.18.0.3:18184 \
	-e FM_BIND_API=172.18.0.3:18185  \
	-e FM_API_URL=ws://172.18.0.3:18185 \
	-p 18185:18185 \
	-e FM_FEDIMINT_DATA_DIR=/fedimint-config1/server \
    -v /home/gary-fedimint/fedimint-testing/config/1:/fedimint-config1 \
	-e FM_CFG_DIR=/fedimint-config1 \
	-d \
	--network fedinet \
	--ip 172.18.0.3 \
	--name fedimint1 \
	fedimint/fedimintd:master

