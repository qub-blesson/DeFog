# DeFog: 
## Demystifying Fog System Interactions Using Container-based Benchmarking

### How to Run
navigate to the DeFog folder:
```$ sh defog .```

### How to View Help
navigate to the DeFog folder:
```$ sh defog -?```

### User Device Dependencies
* Install 'bc'
* Ensure the latest version of bash is installed
* Update the configuration file (DeFog/configs/config.sh) is updated to the relevant values
* Use putty to create a .pem file and update the awsemptykey.pem

### Cloud Platform
* DeFog has been tested using an AWS EC2 ubuntu 18.04 instance, located in Dublin, Ireland. As well as an AWS S3 bucket.
* Create an AWS account and create an IAM user with the necessary privileges.
* Create an EC2 instance and S3 bucket. Update the sender.py application files to the new S3 bucket name.
* Update the local .ssh and .aws with the IAM users credentials (secret access keys) on the user device and Edge Nodes.

### Edge Platform
* DeFog has been tested using an Odroid XU 4 board with ubuntu 14.04 and a Raspberry Pi 3 running NOOBS Raspbian.
* Update the local .ssh and .aws with the IAM users credentials on the edge Edge Nodes.