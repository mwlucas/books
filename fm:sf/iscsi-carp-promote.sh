#!/bin/sh

pools="data1 data2"

#logging
log="local0.debug"
name="iscsi-carp-promote.sh"

#main script

logger -p $log -t $name "Becoming main storage, waiting for completed export"

while $( pgrep -lf "hastd: failover \(secondary\)" > /dev/null 2>&1 ); do
    sleep 1
done

hastctl role primary failover

logger -p $log -t $name "Clear to become main storage, importing ${pools}."

for pool in ${pools}; do
    zpool import -f ${pool}
    if [ $? -ne 0 ]; then
        logger -p $log -t $name "Unable to import ${pool}."
	exit 1
    fi
done

logger -p $log -t $name "Pools ${pools} imported."

#start your services here

service httpd start
