#!/usr/bin/python
import socket
import sys

CHOST = "172.31.28.175"  # The Cloud docker container IP
CPORT = 62331  # The Cloud docker Port
EDHOST = "192.168.0.38"  # The Edge Device's IP
EDPORT = 62332  # The Edge Device's Port
EHOST = "192.168.0.39"  # The Edge Device's IP
EPORT = 62333  # The Edge Device's Port

filename = sys.argv[1]
SERVER_HOST = sys.argv[2]
SERVER_PORT = sys.argv[3]

s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
print("Waiting for connection...")

connected = False
while not connected:
    try:
		print("Attempting to connect to  ",EDHOST,":",EDPORT)
	    s.connect((EDHOST,EDPORT))
		#print("Attempting to connect to  ",SERVER_HOST,":",SERVER_PORT)
	    #s.connect((SERVER_HOST,SERVER_PORT))
	    print("Connection successful")        
	    connected = True
    except Exception as e:	
        pass #Loop
	
# Main		
with open(filename, 'rb') as file:
    for line in file: s.sendall(line)
print("Sent ", filename)

print("Closing server socket")  
s.close
