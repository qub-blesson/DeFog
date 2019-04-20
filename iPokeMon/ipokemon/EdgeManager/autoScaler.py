import pickle
import time
import os
from terminater import terminate
from edgeManager import check_resource
from operator import itemgetter

scaleInterval=600
lxcRootPath="/var/lib/lxc/"
networkLatency=5.689 # Average ping time measured beforehand
# Define one unit of resource to scale: (1 core out of 8 cores CPU, 256mb out of 2gb memory). This is sepcific to ODroidXU3 board
unitCPU = 1.0/8
unitMemory = 256.0/2048
 


def check_activeness(app):
	path = lxcRootPath + "%s/rootfs/root/%s-edgeserver/serverLog" % (app,app.lower())
	diff = time.time() - os.path.getmtime(path)
	if diff <= 0.4 * scale_interval:
		print "Activity check passed."
		return True 


def scale_up(app, appList):
	if check_resource():
		# add one unit resource to the app container
		os.system('. scaleLXC.sh %s up' % app)
	else:
		# terminate other containers from the one with lowest priority
		while not check_resource() and len(appList) > 1:
			no_containers = len(appList)
			terminate(appList[no_containers - 1])
			# remove from list
			appList[:] = [d for d in appList if d.get('App') != app]
		if check_resource():	
			# add one unit resource to the app container
               		os.system('. scaleLXC.sh %s up' % app)
		else:
			print "Scaling up aborted, lack of resources."	

def scale_down(app):
	os.system('. scaleLXC.sh %s down' % app)


def auto_scale():
	lxcList=[]
	if os.path.exists("lxcList.txt"):
		with open("lxcList.txt", "rb") as f:
	     		lxcList = pickle.load(f)
	if len(lxcList) > 0:
		print "%d LXCs to scale" % len(lxcList)
		sortedLXC = sorted(lxcList, key=itemgetter('Priority'), reverse=True)
		for lxc in sortedLXC:
			print "Scaling %s" % lxc['App']
			if(check_activeness(lxc['App'][0]) and networkLatency < lxc['Objective'][0]):
				appLatency = networkLatency + lxc['computeLatency']
				if appLatency > lxc['Objective']:
					scale_up(lxc['App'], sortedLXC)
				else:
					scale_down(lxc['App'], sortedLXC)
			else:
				print "App %s will be terminated due to inactivity or long network delay." % lxc['App']
				terminate(lxc)
				# remove from list
				lxcList[:] = [d for d in lxcList if d.get('App') != lxc['App']]
	else:
		print "No running LXCs to scale."

while True:
    auto_scale()
    time.sleep(scaleInterval)
