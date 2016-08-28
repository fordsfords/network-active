# network-active
network-active.sh is a C.H.I.P. systemd "one-shot" unit which waits until
the network is usable (can ping the default route IP) and exits.  Intended
to be a dependency for other systemd units/services.

## License

I want there to be NO barriers to using this code, so I am releasing it to the public domain.  But "public domain" does not have an internationally agreed upon definition, so I use CC0:

Copyright 2016 Steven Ford http://geeky-boy.com and licensed
"public domain" style under
[CC0](http://creativecommons.org/publicdomain/zero/1.0/): 
![CC0](https://licensebuttons.net/p/zero/1.0/88x31.png "CC0")

To the extent possible under law, the contributors to this project have
waived all copyright and related or neighboring rights to this work.
In other words, you can use this code for any purpose without any
restrictions.  This work is published from: United States.  The project home
is https://github.com/fordsfords/blink/tree/gh-pages

To contact me, Steve Ford, project owner, you can find my email address
at http://geeky-boy.com.  Can't see it?  Keep looking.

## Introduction

The [C.H.I.P.](http://getchip.com/) single-board computer runs Debian-derived
Linux.  The "proper" way to start programs at system startup is using the "systemd"
facility.  It allows different "units" to specify dependencies so that they run
in the right order.

The purpose
of the "network-active" unit is to allow other units/services to list it as
a dependency so that they are started *after* the network can be used.  It
is defined as a "one-shot" unit, which means that dependent units wait until
it exits.  "metwork-active.sh" loops on trying to discover the default
route, issue a ping to the router, and get back a response.  Once all three
are successful, it exits, allowing dependent systemd units to start.

Note that it is possible to devise a network architecture that does not use
default routes.  Hosts with no default route cannot use "network-active".
However, such networks are rare.

Finally, note that "network-active" does not itself actaully accomplish
anything useful.  It is a synchronization tool for use by other systemd
units/serices.

You can find "network-active" on github.  See:

* User documentation (this README): https://github.com/fordsfords/network-active/tree/gh-pages

Note: the "gh-pages" branch is considered to be the current stable release.  The "master" branch is the development cutting edge.

## Quick Start

These instructions assume you are in a shell prompt on CHIP.

1. Get the project files onto CHIP:

        sudo wget -O /usr/local/bin/network-active.sh http://fordsfords.github.io/network-active/network-active.sh
        sudo chmod +x /usr/local/bin/network-active.sh
        sudo wget -O /etc/systemd/system/network-active.service http://fordsfords.github.io/blink/network-active.service
        sudo systemctl enable /etc/systemd/system/network-active.service

2. Configure a service of your choice to depend on network-active.  For
   example, download and install the blink service from
   https://github.com/fordsfords/blink/tree/gh-pages
   Edit the "/etc/systemd/system/blink.service" file (using sudo)
   and replace the line "After=default.target" with the lines:
        Requires=network-active.service
        After=network-active.service
        DefaultDependencies=false

3. Test by turning off your router and rebooting CHIP.  Wait 2 or 3 mintues and
   verify that blink does not start flashing the LED.  Then turn on your router
   and wait a few minutes.  Once CHIP is able to ping the router, the blink
   service should start and the LED will start flashing.

## Release Notes

* 28-Aug-2016
    Initial release.
