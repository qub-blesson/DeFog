# ENORM - A Framework for Edge NOde Resource Management 
The vision of Edge computing is to bring computing towards the edge of the network. This facilitates the hosting of services closer to user devices that frequently interact with the Cloud so that communication latencies can be reduced. Resource management is an important challenge in Edge Computing in a multi-tier hierachy (e.g. mobile devices - Edge - Cloud). ENORM provides a prototoype for managing Edge services on single board computers, such as Odroid boards, which can be placed at the network edge. ENORM dynamically allocates resources in a multi-tenant environment for an application that needs to be hosted at the Edge.

This is a developing research project and some features might not be stable yet.

# License
All source code, documentation, and related artifacts associated with the ENORM open source project are licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).

# How to Use
We provide the use case of iPokeMon, a location-based mobile game (similar to PokeMon Go), to test ENORM. You will need the code provided in folder *Application* to use the ENORM prototype:
1. Follow instructions of iPokeMon Cloud Server in folder *iPokeMon-CloudServer* to set up the Cloud Server
2. Follow instructions of iPokeMon Client in folder *iPokeMon-Client* to set up the game client.
3. Follow instructions of Edge Manager in folder *EdgeManager* to set up the Edge node.
4. Follow instructions of Cloud Manager in folder *CloudManager* to request (and terminate) Edge service for iPokeMon.

# Citation
Please cite [ENORM - A Framework for Edge NOde Resource Management](https://arxiv.org/pdf/1709.04061.pdf) when using this project as follows:

N. Wang, B. Varghese, M. Matthaiou, and D. S. Nikolopoulos, "ENORM: A Framework for Edge NOde Resource Management," IEEE Transactions on Services Computing, 2017.  
