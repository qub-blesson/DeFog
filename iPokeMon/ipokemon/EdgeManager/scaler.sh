#!bin/bash

LXC=$1
DECISION=$2
CPU_UNIT=1000000 # represent 1 out of 8 cores
MEM_UNIT=256 # MB

OLD_CPU=$(lxc-cgroup -n $LXC cpu.cfs_quota_us)
OLD_MEM=$(($(lxc-cgroup -n $LXC memory.limit_in_bytes)/1024/1024))

case $DECISION in 
"up")
	# Abort if LXC is using the maximum resource
	if (($OLD_CPU >= $CPU_UNIT * 8)) || (($OLD_MEM >= $MEM_UNIT * 8))
	then
		echo "Scaling up aborted as maximum resource reached."
	else
		NEW_CPU=$(($OLD_CPU + $CPU_UNIT))
		NEW_MEM=$(($OLD_MEM + $MEM_UNIT))
		lxc-cgroup -n $LXC cpu.cfs_quota_us $NEW_CPU
		lxc-cgroup -n $LXC memory.limit_in_bytes $NEW_MEM"M"
		echo "$LXC scaled up. New CPU: $NEW_CPU, new memory: $NEW_MEM; old CPU:$OLD_CPU, old memory:$OLD_MEM"
	fi
		;;
"down")
	# Abort if LXC is using the minimum resource
	if (($OLD_CPU <= $CPU_UNIT )) || (($OLD_MEM <= $MEM_UNIT))
	then
		echo "Scaling down aborted as minimum resource reached."
	else
		NEW_CPU=$(($OLD_CPU - $CPU_UNIT)) 
		NEW_MEM=$(($OLD_MEM - $MEM_UNIT))
		lxc-cgroup -n $LXC cpu.cfs_quota_us $NEW_CPU
		lxc-cgroup -n $LXC memory.limit_in_bytes $NEW_MEM"M"
		echo "$LXC scaled down. New CPU: $NEW_CPU, new memory: $NEW_MEM; old CPU:$OLD_CPU, old memory:$OLD_MEM"	
	fi	
	;;
esac
