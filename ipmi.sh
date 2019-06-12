#!/bin/sh
#
# This is a server side script that is used to call 
# remote BMCs via ipmitool
#
# For each host that has a onboard BMC (iLo, iDrac, RMM, etc),
# add ipmihost, ipmiuser, and ipmipass tags to define IP, username,
# and password used to poll
#
# Example:
# 10.0.0.1	host.example.com	# ipmihost:10.128.128.1 ipmiuser:admin ipmipass:adminpass
#
# Place this file in $XYMONHOME/ext
# Then, to activate simply append the following to
# the $XYMONHOME/etc/tasks.cfg file:
#
#[ipmi]
#	ENVFILE /usr/lib/xymon/server/etc/xymonserver.cfg
#        CMD $XYMONHOME/ext/ipmi.sh
#        LOGFILE $XYMONSERVERLOGS/ipmi.log
#        INTERVAL 5m
#

for MACHINE in `grep ipmi /etc/xymon/hosts.cfg | awk '{print $2}'`; do
	TESTHOST=$(grep $MACHINE /etc/xymon/hosts.cfg | awk -Fipmihost: '{print $2}' | awk '{print $1}')
	USERNAME=$(grep $MACHINE /etc/xymon/hosts.cfg | awk -Fipmiuser: '{print $2}' | awk '{print $1}')
	PASSWORD=$(grep $MACHINE /etc/xymon/hosts.cfg | awk -Fipmipass: '{print $2}' | awk '{print $1}')
	PATH=${PATH}:/usr/local/bin:/usr/local/sbin

	COLUMN=ipmi
	IFS="
"
	MSG=$(for i in $(ipmitool -I lanplus -H $TESTHOST -U $USERNAME -P $PASSWORD sdr | grep "|"); do
        	case "${i}" in
                	*ok)
                        	echo "&green ${i}"
                        	;;
                	*ns)
                        	echo "&clear ${i}"
                        	;;
                	*)
                        	echo "&red ${i}"
                        	;;
        	esac
	done)

	STATUS="$(hostname) IPMI health status"

	case "${MSG}" in
        	*'&red'*)
                	COLOR=red
                	;;
        	*'&yellow'*)
                	COLOR=yellow
                	;;
        	*)
                	COLOR=green
                	;;
	esac

	${XYMON} ${XYMSRV} "status ${MACHINE}.${COLUMN} ${COLOR} $(date)
${STATUS}

${MSG}

Last 50 Events:
$(ipmitool -I lanplus -H $TESTHOST -U $USERNAME -P $PASSWORD sel list | tail -50)
"

done
