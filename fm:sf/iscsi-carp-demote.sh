#!/bin/sh

# The names of the ZFS pools available on iSCSI

pools="data1 data2"

#logging
log="local0.debug"
name="iscsi-carp-demote.sh"

#terminate processes here, forcibly if needed

service httpd stop

#end of user configurable stuff

for pool in ${pools}; do

    #forcibly unmount the filesystem

    zpool export -f ${pool} 2>&1
    if [ $? -ne 0 ]; then
        logger -p $log -t $name "Unable to export ${pool}."
        exit 1
    fi

    logger -p $log -t $name "Pools ${pool} exported."
done

#if we get this far, we signal HAST that the other host can import.

hastctl role secondary failover
logger -p $log -t $name "HAST demotion triggered."
