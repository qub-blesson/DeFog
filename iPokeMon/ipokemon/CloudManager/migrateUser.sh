#!bin/bash

EDGE_IP=$1
EDGE_REDIS_PORT=$2 # This is the first port in request.txt, which is updated when Edge service is setup.

USER_ID_TO_OFFLOAD=1
echo "User with ID $USER_ID_TO_OFFLOAD will be offloaded to Edge"

KEY_PATTERNS="*:${USER_ID_TO_OFFLOAD}*
$(expr ${USER_ID_TO_OFFLOAD} - 1):*
wpm:*"
echo "This is the key patterns: "$KEY_PATTERNS

# Generate KEY string
KEYS="usernames"
for pattern in $KEY_PATTERNS
do
	str=$(echo -e "SELECT 8\n KEYS $pattern" | redis-cli)
	KEYS+=$(echo $str | sed -e "s/OK//")
done 
    
# Migrate user data
echo -e "SELECT 8\n MIGRATE $EDGE_IP $EDGE_REDIS_PORT \"\" 8 100000 COPY REPLACE KEYS $KEYS" | redis-cli
# Point to edge server
. redirectServer.sh $EDGE_IP
