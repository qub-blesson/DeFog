import socket, pickle
import time

PORT = 2221
EDGE_IP = '34.245.11.31'


# Request from args to use edge service.
# e.g.
# {'App':'iPokeMon' , 'Ports':[6379,8000], 'Premium': '1', 'Objective': '80'}


def read_request(inFile):
	""" Read request from file into a dictionary"""
	req = {}
	with open(inFile) as f:
    		for line in f:
			kv = line.split()			
        		k, v = kv[0], kv[1:]
       			req[k] = v
	return req

def parse_response(data):
    data_arr = pickle.loads(data)
    return data_arr

def greeting(server):
	server.send("hello")
	print "Hello to Edge..."

def request_edge_service(requestFile, server):
	request = read_request(requestFile)
	request_str = pickle.dumps(request)
	server.send(request_str)
	print "Request sent."
	
def recv_key(server):
	f = open('edge.key','wb')
	print "Receiving access key..."
	l = server.recv(1024)
	while (l):
        	f.write(l)
        	l = server.recv(1024)
	f.close()
	print "Access key received."

def send_request():
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.connect((EDGE_IP, PORT))
    greeting(s)
    greeting_response = s.recv(1024)
    if greeting_response == "hello":
        request_edge_service("request.txt",s)
	decision = s.recv(1024)
	if decision == "Reject":
		print "Request is rejected. Try again later."
	else: 
		print "Edge ports config: %s" % decision
		recv_key(s)
		print "Edge service container setup. Start deploying App..."
		s.close()
		os.system('. deployApp.sh %s %s %s' % (EDGE_IP, decision[len(decision)], decision[0]))
    else:
        print "This Edge node is not available. Try again later."
	s.close()


if __name__ == "__main__":
	send_request()
