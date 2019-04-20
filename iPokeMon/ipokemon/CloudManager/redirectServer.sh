#!bin/bash

TARGET_IP=$1
CONFIG_FILE='/home/ubuntu/ENORM/Application/iPokeMon-CloudServer/serverIP.xml' # This is the configuration of server IP in Cloud server.

sed -i "6s/.*/<string>http:\/\/$TARGET_IP:8000\/<\/string>/" $CONFIG_FILE
