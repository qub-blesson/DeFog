import socket, threading, pickle
import os
from datetime import datetime
import subprocess
import psutil
from random import sample
from terminater import terminate

PORT = 2221
unitCPU = 12.5 # percent
unitMemory = 256 # MB

# A list of running LXC (dict)
# e.g. [{'App': ['test1'], 'Ports': ['1234', '5678'], 'Priority': ['1']}, {...}]
lxcList=[]
if os.path.exists("lxcList.txt"):
	with open("lxcList.txt", "rb") as f:
	     	lxcList = pickle.load(f)

portsPool = range(20001,29999)
service_available = 1


def parse_request(data):
    data_arr = pickle.loads(data)
    return data_arr

def check_free_port(request):
    ports_used = list(set([p for sublist in [item['Ports'] for item in lxcList] for p in sublist]))
    if not set(request['Ports']).intersection(ports_used) :
        print 'Free ports: OK'
        access_port = generate_new_port(1)
        print 'Access port generated.'
        request['Ports'].extend(access_port)
    else:
        ports = generate_new_port(len(request['Ports'])+1)
        request['Ports'] = ports
        print 'New ports allocated.'

def forward_ports(app, ports,ip):
    """
    Forward ports from LXC to Edge node
    """
    for p in ports[0:(len(ports)-1)]:
	print p
        os.system('iptables -t nat -A PREROUTING -i eth0 -p tcp --dport %d -j DNAT --to %s:%d' % (p, ip, p))
    # the last port in ports is for remote access on 22 of LXC
    os.system('iptables -t nat -A PREROUTING -i eth0 -p tcp --dport %d -j DNAT --to %s:22' % (ports[len(ports)-1], ip))
    print "Done port forwarding."

def install_ssh(app):
    """
    Install ssh to enable remote access in alpine LXC.
    """
    os.system('lxc-attach -n %s -- apk update' % app)
    os.system('lxc-attach -n %s -- apk add openssh' % app)
    # Config sshd
    config = '/var/lib/lxc/%s/rootfs/etc/ssh/sshd_config' % app
    with open(config, "a") as myfile:
        myfile.write("RSAAuthentication yes\nPubkeyAuthentication yes\nPermitRootLogin yes\nPermitEmptyPasswords yes")
    os.system('lxc-attach -n %s -- /etc/init.d/sshd start' % app)

def check_ip_status(app):
    while True:
        ip = subprocess.check_output('lxc-info -n %s -iH' % app, shell=True)[0:10]
        if len(ip) > 0:
                break
    print 'IP allocated: %s' % ip
    return ip

def gen_key(app):
	""" Generate private key inside container
	"""
	os.system('lxc-attach -n %s -- ssh-keygen -t rsa -N "" -f key' % app)

def launch_lxc(app, ports):
    """
    Launch an idle LXC with basic packages required
    """
    print 'Launching blank LXC for: ', app
    tstart = datetime.now()
    os.system('lxc-create -t alpine -f lxcConfig -n %s' % (app))
    tend = datetime.now()
    os.system('lxc-start -n %s' % app)
    ip = check_ip_status(app)
    install_ssh(app)
    forward_ports(app, ports, ip)
    gen_key(app)
    print 'Time elapsed for launch_lxc:', tend - tstart
    return ip

def generate_new_port(n):
    """
    Generate n free ports for new accepted request
    """
    ports = sample(portsPool,n)
    for p in ports:
        ind = portsPool.index(p)
        del portsPool[ind]
    return ports

def lxc_give_access(client, ports, app):
    """
    Give access of LXC to client, so he can deploy edge server
    """
    # send edge config to user
    response = pickle.dumps(ports)
    client.send(response)
	# send key to user      
    f = open('/var/lib/lxc/%s/rootfs/key' % app,'rb')
    print 'Sending access key to user...'
    l = f.read(1024)
    while (l):
        client.send(l)
        l = f.read(1024)
    f.close()
    print "Access given."

def check_resource():
	# measure current system usage
	print "Checking resource availability..."
	availableCPU = 100 - psutil.cpu_percent()
	availableMemory = psutil.virtual_memory()[1]/1024/1024
	print "Free CPU: %s, free memory: %s" % (availableCPU, availableMemory)
	if availableCPU >= unitCPU and availableMemory >= unitMemory:
        	return True

def handshake(client):
    """
    Check if request can be accepted
    """
    print 'Handshaking...'
    data = client.recv(1024)
    request = parse_request(data)
    print 'Got request:', request
    
    if check_resource():
	print "Resource check passed."
    	if lxcList:
		check_free_port(request)
    	else:
		access_port = generate_new_port(1)
		print 'Access port generated.'
        	request['Ports'].extend(access_port)
    	return 'Accepted', request
    else:
	return 'Rejected', request

def handle(client,addr):
    data = client.recv(1024)
    # greeting
    if data == "hello":
        client.send("hello")
        decision, request = handshake(client)
        if decision == 'Rejected':
        	print 'Request is being rejected due to no resources available'
	    	# notify Cloud Manager about the rejection
		client.send("Reject")
	if decision == 'Accepted':        	
		app = ''.join(request['App'])
            	ports = [int(x) for x in request['Ports']]
            	request['lxcIP'] = launch_lxc(app, ports)
		request['cloudIP'] = addr
	    	lxc_give_access(client, ports, app)
            	print 'Edge server running, ready for scaling.'
		with open("lxcList.txt",'wb') as wfp:
                	pickle.dump(lxcList, wfp)	    	
	client.close()
	print 'Connection to %s closed.' % addr[0]
    elif data.split()[0] == "terminate":
        app = data.split()[1]
	lxc = next((item for item in lxcList if item['App'] == app), None)
	if lxc:
	    terminate(lxc)
	    # remove from list
	    lxcList[:] = [d for d in lxcList if d.get('App') != lxc['App']]
	    client.send("Terminated %s" % app)	
    	else:
	    client.send("Request ignored, %s not existed." % app)
    else:
        print 'Invalid greeting'


def start_server():
    s = socket.socket()
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind(('', PORT))
    s.listen(5)
    print 'Waiting for a connection on port', PORT
    while service_available:
        conn, addr = s.accept()
        print 'Connection from:', addr
        threading.Thread(target=handle, args=(conn,addr)).start()


if __name__ == "__main__":
    start_server()
