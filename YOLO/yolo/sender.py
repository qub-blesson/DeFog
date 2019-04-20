#!/usr/bin/python
import socket # importation for socket connections
import sys # system utility functionality

#########################################################################################################################
# CSC4006 - Research And Development Project
# Developed by: Jonathan McChesney (MEng Computer Games Development)
# Queen's University Belfast
#
# Component: sender.py
#
# Purpose: This component opens a socket and sends a data asset to the server (receiver.py).
#
#########################################################################################################################

filename = sys.argv[1] # 1st param = asset to be transferred
SERVER_HOST = sys.argv[2] # 2nd param = destination host address
SERVER_PORT = sys.argv[3] # 3rd param = destination port

# create the socket connection
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
print("Waiting for connection...")

# initiate the connection loop
connected = False
while not connected:
    try:
		# continously attempt to connect to the provided host and port, if a connection is not made then continue looping
		print("Attempting to connect to  ",SERVER_HOST,":",SERVER_PORT)
	    s.connect((SERVER_HOST,SERVER_PORT))
	    print("Connection successful")        
	    connected = True
    except Exception as e:	
        pass # Loop until a connection is made
	
# Main functionality - open the specified file, iterate over all lines, segment and send the data in parallel using the socket connection
with open(filename, 'rb') as file:
    for line in file: s.sendall(line)
print("Sent ", filename)

# close the socket connection
print("Closing server socket")  
s.close
