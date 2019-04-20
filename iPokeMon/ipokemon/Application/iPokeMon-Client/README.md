# iPokeMon Client
This is the iOS client of iPokeMon, modified from [iPokeMon](https://github.com/Kjuly/iPokeMon). Added functionality: remote configuration of server IP.

## Tested Platform
We have tested iPokeMon Client with macOS High Sierra version 10.13.6 and XCode v9.0.
We have generated virtual workloads with Apache JMeter v3.1.

## Requirement
- [XCode](https://developer.apple.com/xcode/)
- [Apache JMeter](https://jmeter.apache.org/)

## How to use
1. Uncomment *NW_REMOTE_CONFIG_ON 1* in Master/Config.h
2. Update *kServerAPIRoot* in Master/Config.m with the public IP of your server machine.
3. Make sure iPokeMon Cloud Server is running.
4. To run iPokeMon Client in Xcode's iOS simulator, refer to full instructions of [iPokeMon](https://github.com/Kjuly/iPokeMon).
    To run virtualised workloads, the HTTP requests in a session of single user playing iPokeMon is recorded in iPokeMon.jmx. Use this template file to set up Apache JMeter.
