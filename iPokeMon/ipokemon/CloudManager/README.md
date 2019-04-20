# Cloud Manager 
This is the Cloud manager that communicates with the Edge Manager when requesting and deploying Edge services.

## Tested Platform
We have tested the Cloud manager on AWS EC2 t2.micro with Ubuntu Server 16.04 LTS.

## Requirement
  - [Python](https://www.python.org/)

## How to use
1. Update:
- *EDGE_IP* in requestEdgeService.py
- *CONFIG_FILE* in redirectServer.sh
- *EDGE_IP*, *CLOUD_IP* in terminateEdgeService.py
2. Make sure Edge Manager and iPokeMon Cloud Server is up running
3. Request Edge service:
```
python requestEdgeService.py
```
4. Terminate Edge service:
```
python terminateEdgeService.py
```
