import os
import time
import subprocess


lxcPath="/var/lib/lxc/"
updateInterval=300


def update_compute_latency(app):
	logPath = lxcPath + "%s/rootfs/root/%s-edgeserver/serverLog" % (app, app.lower())
	cmd = "grep 'startTime\|endTime' %s | grep --no-group-separator -B1 ^'endTime' | awk '{s=$2;getline;print $2-s;next}'" % logPath
	latency = subprocess.check_output(cmd, shell=True).rstrip('\n').split('\n')
	computeLatency = sum(map(float, latency)) / len(map(float, latency))
	return computeLatency

if __name__ == "__main__":
	while True:
		if os.path.exists("lxcList.txt"):
			with open("lxcList.txt", "rb") as new_filename:
        			lxcList = pickle.load(new_filename)
			if len(lxcList) > 0:
				for lxc in lxcList:
					lxc['computeLatency'] = update_compute_latency(lxc['App'])
			with open("lxcList.txt",'wb') as wfp:
                		pickle.dump(lxcList, wfp)		
		time.sleep(updateInterval)
