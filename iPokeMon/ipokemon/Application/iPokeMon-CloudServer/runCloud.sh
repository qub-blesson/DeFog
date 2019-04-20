#!bin/bash
redis-server --protected-mode no > logs/redisSysLog &
# Init DB with wpm data
if [ ! -f dump.rdb ]; then
	echo "Init DB with wpm data"
	nohup python scripts/updateDB.py > logs/updateLog &
fi
echo "Starting server.py..."
nohup python server.py > logs/cloudServerLog &