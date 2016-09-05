#!/bin/sh
# network-active, version 5-Sep-2016
# systemd unit which waits until the network is usable (can ping router)
#   before exiting.  Intended to be used as a dependency by other
#   systemd units.
# See https://github.com/fordsfords/network-active/tree/gh-pages

STATUS=1  # 0 means success (network ready); non-zero means fail (not ready).

echo "network-active starting"
while [ $STATUS -ne 0 ]; do :
  # The "sed" command extracts the IP address of the default route.
  DEF_ROUTE=`route -n | sed -n 's/^0.0.0.0 *\([0-9.]*\) .*$/\1/p'`
  if [ -n "$DEF_ROUTE" ]; then :  # if have a default route
    ping -c 1 $DEF_ROUTE >/dev/null 2>&1
    STATUS=$?
  fi
done

echo "network-active done"
