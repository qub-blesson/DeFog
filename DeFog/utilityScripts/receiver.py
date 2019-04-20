#!/usr/bin/python
import socket # socket stream/connections
import platform, os, subprocess, sys # provides the system and subprocess utilities to run bash and receive data

#########################################################################################################################
# CSC4006 - Research And Development Project
# Developed by: Jonathan McChesney (MEng Computer Games Development)
# Queen's University Belfast
#
# Component: receiver.py
#
# Purpose: This component opens a socket and expects to receive a data asset from the client (sender.py).
#
#########################################################################################################################

# initialise input paramaters: filename, localhost and port
filename=sys.argv[1] # 1st param - filename to create and write the input stream data to
CLIENT_HOST = sys.argv[2] # 2nd param - localhost
CLIENT_PORT = sys.argv[3] # 3rd param - port

# initialise a socket stream
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# bind the provided host address and port to the socket
s.bind((CLIENT_HOST, CLIENT_PORT))

# listen for a socket connection attempt
print("Listening on  ", CLIENT_HOST, ":", CLIENT_PORT)   
s.listen()
conn, addr = s.accept()
print("Connection successful")   

# Main Functionality - executes when socket connection is successful. Will open/create a filename and write to the buffer. Each line is populated with 
# a data block.		
with open(filename,'wb') as file:
	while True:
		line = conn.recv(1024)
		if not line: break
		file.write(line)
print("Received ", filename)
	
# close the socket connection	
print("Closing client socket")
s.close


	
