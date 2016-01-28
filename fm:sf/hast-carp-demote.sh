#!/bin/sh

# The names of the HAST resources, as listed in hast.conf
# Use the same name for your pool or mount point

resources="hast1 hast2"

#logging
log="local0.debug"
name="hast-carp-demote.sh"

#terminate processes here

service named stop

#end of user configurable stuff
#do not go beyond this point

for disk in ${resources}; do

    #forcibly unmount the filesystem

    zpool export -f ${disk} 2>&1
    if [ $? -ne 0 ]; then
        logger -p $log -t $name "Unable to export the pool ${disk}."
        exit 1
    fi

    # Switch roles for the HAST resources
    hastctl role secondary ${disk} 2>&1
    if [ $? -ne 0 ]; then
        logger -p $log -t $name "Unable to switch role to secondary for resource ${disk}."
        exit 1
    fi
    
    logger -p $log -t $name "Role switched to secondary for resource ${disk}."
done
