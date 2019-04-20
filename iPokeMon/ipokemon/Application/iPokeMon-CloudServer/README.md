# iPokeMon Cloud Server
This is the Cloud server of iPokeMon, modified from [iPokeMon-Server](https://github.com/Kjuly/iPokeMon-Server). Added functionality: remote configuration of server IP.

## Tested Platform
We have tested the iPokeMon Cloud server on AWS EC2 t2.micro with Ubuntu Server 16.04 LTS.

## Dependencies
- [Redis](https://redis.io/)
- [Python](https://www.python.org/), [python-pip](https://packages.ubuntu.com/search?keywords=python-pip), [redis-py](https://github.com/andymccurdy/redis-py)

## How to use
1. To start iPokeMon Cloud Server
```
mkdir logs
. runCloud.sh
```
2. To shutdown iPokeMon Cloud Server
```
redis-cli
> shutdown
> exit
ps aux | grep server
kill -9 <server.py's pid>
```
