#!bin/bash

EDGE_IP=$1
EDGE_PORT=$2 # This is the last port in request.txt, which is updated when Edge service is setup
EDGE_REDIS_PORT=$3 # This is the first port in request.txt, used by redis DB

ssh -i edge.key root@$EDGE_IP -p $PORT
apk add python py-pip redis
pip install redis 
git clone https://github.com/NanWang0024/iPokeMon-EdgeServer.git ipokemon-edgeserver 
cd ipokemon-edgeserver

# Launch DB & Server on edge node
redis-server redis.conf --port $EDGE_REDIS_PORT --protected-mode no > redisLog
if [ ! -f dump.rdb ] 
then echo \"Init Edge DB with wpm data\" 
	nohup python ../scripts/updateDB.py > logs/updateLog & 
fi
nohup python server.py > serverLog &

# Migrate user
. migrateUser.sh $EDGE_IP $EDGE_REDIS_PORT
