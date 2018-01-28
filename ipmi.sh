#!/bin/sh
#
# Place this file in $XYMONCLIENTHOME/ext
# Then, to activate simply append the following to
# the $XYMONCLIENTHOME/etc/clientlaunch.cfg file:
#
#[ipmi]
#        ENVFILE $XYMONCLIENTHOME/etc/xymonclient.cfg
#        CMD $XYMONCLIENTHOME/ext/ipmi.sh
#        LOGFILE $XYMONCLIENTLOGS/ipmi.log
#        INTERVAL 5m
#

# Xymon doesn't have /usr/local in PATH
PATH=${PATH}:/usr/local/bin:/usr/local/sbin

COLUMN=ipmi
IFS="
"
MSG=$(for i in $(ipmitool sdr | grep "|"); do
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
$(ipmitool sel list | tail -50)
"
