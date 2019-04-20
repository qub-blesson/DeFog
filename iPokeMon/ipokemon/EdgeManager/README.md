# Edge Manager
This is the Edge Manager on an Edge node that manages the provisioning, resource scaling and termination of Edge services. 

# Tested Platform
We have tested the Edge Manager on [ODroid XU3](https://www.hardkernel.com/main/products/prdt_info.php?g_code=g140448267127) with Ubuntu 14.04.5 LTS

# Requirement
- [python](https://packages.ubuntu.com/trusty/python), [python-pip](https://packages.ubuntu.com/trusty/python-pip), [psutil](https://github.com/giampaolo/psutil)
- [LXC](https://help.ubuntu.com/lts/serverguide/lxc.html)

# How to Use
```
python edgeManager.py &
python autoScaler.py &
python monitor.py &
```
