#!/bin/bash -e
(
if [ "x$START_WAIT_FILE" != "x" ]; then
	while true; do
		[ -f "$START_WAIT_FILE" ] && break
		sleep 1
	done
fi
. /etc/sysconfig/condor
exec condor_master -f
) & pid=$!
trap "kill $pid" TERM
echo $pid > /var/run/condor_master.pid
if [ "x$START_WAIT_DONE_FILE" != "x" ]; then
	touch "$START_WAIT_DONE_FILE"
fi
wait $pid
[ -f /etc/shutdown.sh ] && bash /etc/shutdown.sh
