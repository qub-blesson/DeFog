import socket
import sys
import os

def send_request():
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.connect((EDGE_IP, PORT))
    
    s.send("terminate %s" % App)
    response = s.recv(1024)
    if response.split()[0] == "Terminated":
	# redirect user to cloud
	os.system('. redirectUsers.sh %s' % CLOUD_IP)
    else:
	print response
    s.close()


if __name__ == "__main__":
	PORT = 2221
	EDGE_IP = '34.245.11.31'
	CLOUD_IP = '34.245.11.31'
	App = sys.argv[1]
	send_request()
