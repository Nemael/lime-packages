#!/usr/bin/lua

local hardware_detection = require("lime.hardware_detection")
local config = require("lime.config")
local utils = require("lime.utils")



function cable_purpose_autodetection.generate_auto_detection_file()
    --This method will generate a file in the /etc/hotplug.d/iface folder
    --File will be called auto_detection_script.sh
    --The file generated in the hotplug.d folder will be executed when an interface goes up or down
    local auto_configuration_script, err = io.open("auto_detection_script.sh", "w")
    local configuration = '' ..
    '#!/bin/sh\n'..
    '#This document contains automatically generated code that runs every time an interface goes up, down, or is modified.\n'..
    '#Do not modify this document, you changes will be overwritten when calbe_purpose_autodetection.lua is executed.\n'..
    '\n'


    -- Get all interfaces
    local interface_status = conn:call("network.interface.*", "status", {})
    for index,interface in pairs(interface_status) do
        --ACTION_TO_DETECT can be ifup, ifdown, ifup-failed, ifupdate, and more, but these options seems the most useful
        local ACTION_TO_DETECT = 'ifup'
        --DEVICE is the name of the interface that should have its configuration edited. I think this part should be edited to fit the list of interfaces an interface has
            --One way to do the editing is to dynamically generate this file from cable_purpose_autodetection.lua, and have one section of the file dedicated to each interface.
        local DEVICE = interface.device

        configuration = configuration..
        'if [ "${ACTION}" == "' .. ACTION_TO_DETECT .. '"] && [ "${DEVICE}" == "' .. DEVICE .. '"]\n'..
        'then\n'..
        '   echo "Interface ' .. DEVICE .. ' is up"\n'..
        '   #Here run a script that would try to detect what is on the other side of the interface\n'..
        '   #This script could work by searching for a dedicated libremesh ipv6 multicast address such as ff12::face\n'..
        '   #Alternatives to that have been discussed in the mailing list, check the mail chain "[lime] GSoC - Cable purpose autodetection"\n'..
        '   ping ff12::face%' .. DEVICE .. '\n'..
        '   #Then edit the configuration of the interface to fit what kind of device the previous script found\n'..
        '   #For example, if the previous ping command is succesful, we know that a libremesh device is on the other side of the connection\n'..
        'fi\n'..
        '\n'
    end
    auto_configuration_script:write(configuration)
    auto_configuration_script:close()
    print("File written successfully.")


function cable_purpose_autodetection.listen_ipv6()
    --Ping the libremesh specific ipv6 address to know if we are talking to a Libremesh node
    --This command should be executed on all available interfaces

    local interface_status = conn:call("network.interface.*", "status", {})
    for index,interface in pairs(interface_status) do
        local pvCommand = "ping ff12::face%" .. interface_status.device
	    local handlePv = io.popen(pvCommand, 'r')
    end
    --The configuration to apply will be different depending on the type of connection linking the two devices
    --(Ethernet, Wi-Fi, WAN...)

function cable_purpose_autodetection.broadcast_ipv6()
    --Here we should configure an interface to broadcast an ipv6 multicast address, such as ff12:face
    --It is posible to do by registering a multicast broadcast
    --From @Ilario, it is possible to do using socat
    --It is possible to put a broadcaster on each interface, but it might be overkill, there might be a simpler way
    local interface_status = conn:call("network.interface.*", "status", {})
    for index,interface in pairs(interface_status) do
        local pvCommand = "socat STIO UDP6-DATAGRAM:[ff12::face]:8889,ipv6-join-group=[ff12::face]" .. interface_status.device
        local handlePv = io.popen(pvCommand, 'r')
    end

function cable_purpose_autodetection.apply_configuration
    --This method should be called from the auto_detection_script.sh file
    --It should apply configuration to an interface, according to parameters collected by the previously mentioned script
    --Such as the type of connection (ehternet, wan, etc) or the interface it is working with