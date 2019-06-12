This is a server side script that is used to call 
remote BMCs via ipmitool

For each host that has a onboard BMC (iLo, iDrac, RMM, etc),
add ipmihost, ipmiuser, and ipmipass tags to define IP, username,
and password used to poll

Example:
10.0.0.1	host.example.com	# ipmihost:10.128.128.1 ipmiuser:admin ipmipass:adminpass

Place this file in $XYMONHOME/ext
Then, to activate simply append the following to
the $XYMONHOME/etc/tasks.cfg file:

[ipmi]
	      ENVFILE /usr/lib/xymon/server/etc/xymonserver.cfg
        CMD $XYMONHOME/ext/ipmi.sh
        LOGFILE $XYMONSERVERLOGS/ipmi.log
        INTERVAL 5m
