######Shell script for monitoring the slave machine for Cpu utilization  and send alerts to master if it reaches 80%################
#!/bin/bash

CRITICAL=80
CRITICALMAIL="aniket@ip-172-31-60-191.ec2.internal"     ###mail of  master
LOGFILE=/home/aniket/cpu_util-`date +%h%d%y`.log
for i in `cat /home/aniket/hostlist`;
do
HOSTNAME=$(hostname)
DATE=$(date "+%Y-%m-%d %H:%M:%S")
CPULOAD=$(top -b -n 1 -d1 | grep "Cpu(s)" |awk '{print $2}' |awk -F. '{print $1}')
MEMUSAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
DISKUSAGE=$(df -P |column -t |awk '{print $5}' | tail -n 1 | sed 's/%//g')

echo "Hostname,       Date&Time,       CPUi(%),Mem(%),Disk(%)">> $LOGFILE
echo "$HOSTNAME, $DATE, $CPULOAD, $MEMUSAGE, $DISKUSAGE">> $LOGFILE

if [ "$CPULOAD" -ge "$CRITICAL" ]; then
echo "$DATE CRITICAL - $CPULOAD on host $HOSTNAME" >> $LOGFILE
echo "CRITICAL Cpuload $CPULOAD Host is $HOSTNAME" | mail -s "Cpu load is CRITICAL" $CRITICALMAIL

exit
else
echo "$DATE OK - Cpuload: $CPULOAD on $HOSTNAME" >> $LOGFILE
exit
fi

done
