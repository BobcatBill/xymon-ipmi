This is a server side script that is used to call <br>
remote BMCs via ipmitool<br>
<br>
For each host that has a onboard BMC (iLo, iDrac, RMM, etc),<br>
add ipmihost, ipmiuser, and ipmipass tags to define IP, username,<br>
and password used to poll<br>
<br>
Example:<br>
10.0.0.1	host.example.com	# ipmihost:10.128.128.1 ipmiuser:admin ipmipass:adminpass<br>
<br>
Place this file in $XYMONHOME/ext<br>
Then, to activate simply append the following to<br>
the $XYMONHOME/etc/tasks.cfg file:<br>
<br>
[ipmi]<br>
	      ENVFILE /usr/lib/xymon/server/etc/xymonserver.cfg<br>
        CMD $XYMONHOME/ext/ipmi.sh<br>
        LOGFILE $XYMONSERVERLOGS/ipmi.log<br>
        INTERVAL 5m<br>
<br>
