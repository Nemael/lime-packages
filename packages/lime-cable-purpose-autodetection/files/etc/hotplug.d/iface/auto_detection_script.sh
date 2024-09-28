#!/bin/sh
#This document contains automatically generated code that runs every time an interface goes up, down, or is modified.
#Do not modify this document, you changes will be overwritten when calbe_purpose_autodetection.lua is executed.

if [ "${ACTION}" == "ifup"] && [ "${DEVICE}" == "eth0"]
then
   echo "Interface eth0 is up"
   #Here run a script that would try to detect what is on the other side of the interface
   #This script could work by searching for a dedicated libremesh ipv6 multicast address such as ff12::face
   #Alternatives to that have been discussed in the mailing list, check the mail chain "[lime] GSoC - Cable purpose autodetection"
   ping ff12::face%eth0
   #Then edit the configuration of the interface to fit what kind of device the previous script found
   #For example, if the previous ping command is succesful, we know that a libremesh device is on the other side of the connection
fi

cat << "EOF" << /etc/hotplug.d/iface/00-logger
logger -t hotplug $(env)
EOF