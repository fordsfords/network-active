#!/bin/sh
# network-active, version 28-Aug-2016

STATUS=1  # 1 means "failed"; 0 means "success"

echo "network-active starting" `date` >/tmp/network-active.log
while [ $STATUS -ne 0 ]; do :
  # The "sed" command extracts the IP address of the default route.
  DEF_ROUTE=`route -n | sed -n 's/^0.0.0.0 *\([0-9.]*\) .*$/\1/p'`
  if [ -n "$DEF_ROUTE" ]; then :  # if have a default route
    ping -c 1 $DEF_ROUTE >/dev/null 2>&1
    STATUS=$?
  fi
done

echo "network-active done" `date` >>/tmp/network-active.log
