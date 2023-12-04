#!/bin/bash

OUTPUT="/tmp/sysinfo.log"

exec 3> "$OUTPUT"

echo "---------------------------------------------------" >&3
echo "System Info run for $(hostname)" >&3
echo "---------------------------------------------------" >&3

echo "****************************" >&3
echo "*** Installed Hard Disks ***" >&3
if ! fdisk -l | egrep "^Disk /dev" >&3; then
    echo "Error: Failed to retrieve disk information." >&3
    exit 1
fi

echo "************************************" >&3
echo "*** File System Disk Space Usage ***" >&3
df -H >&3

echo "***********************" >&3
echo "*** CPU Information ***" >&3
grep 'model name' /proc/cpuinfo | uniq | awk -F: '{ print $2}' >&3

echo "*****************************" >&3
echo "*** Operating System Info ***" >&3
uname -a >&3
[ -x /usr/bin/lsb_release ] && /usr/bin/lsb_release -a >&3 || echo "/usr/bin/lsb_release not found." >&3

echo "**************************************" >&3
echo "*** Amount Of Free And Used Memory ***" >&3
free -m >&3

echo "************************************" >&3
echo "*** Top 10 Memory Eating Process ***" >&3
ps -auxf | sort -nr -k 4 | head -10 >&3

echo "**********************************" >&3
echo "*** Top 10 CPU Eating Process  ***" >&3
ps -auxf | sort -nr -k 3 | head -10 >&3

echo "******************************************" >&3
echo "*** Network Device Information [enp0s]  ***" >&3
netstat -i | grep -q enp0s31f6 && /sbin/ifconfig enp0s >&3 || echo "enp0s is not installed" >&3

echo "******************************************" >&3
echo "*** Network Device Information [eth1]  ***" >&3
netstat -i | grep -q eth1 && /sbin/ifconfig eth1 >&3 || echo "eth1 is not installed" >&3

echo "********************************" >&3
echo "*** Wireless Device [wlan0]  ***" >&3
netstat -i | grep -q wlp58s0 && /sbin/ifconfig wlan0 >&3 || echo "wlan0 is not installed" >&3

echo "*************************************" >&3
echo "*** All Network Interfaces Stats ***" >&3
netstat -i >&3

echo "System info wrote to $OUTPUT file." >&3
