#!/usr/bin/python
import socket
import platform, os, subprocess, sys

CHOST = "172.31.28.175"  # The Cloud docker container IP
CPORT = 62331  # The Cloud docker Port
EDHOST = "192.168.0.38"  # The Edge Device's IP
EDPORT = 62332  # The Edge Device's Port
EHOST = "192.168.0.39"  # The Edge Device's IP
EPORT = 62333  # The Edge Device's Port

filename=sys.argv[1]
CLIENT_HOST = sys.argv[2]
CLIENT_PORT = sys.argv[3]

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((EDHOST, EDPORT))

#print("Listening on  ", CLIENT_HOST, ":", CLIENT_PORT)   
print("Listening on  ", EDHOST, ":", EDPORT)   
s.listen()
conn, addr = s.accept()
print("Connection successful")   

# Main Functionality		
with open(filename,'wb') as file:
	while True:
		line = conn.recv(1024)
		if not line: break
		file.write(line)
print("Received ", filename)
		
print("Closing client socket")
s.close


	
