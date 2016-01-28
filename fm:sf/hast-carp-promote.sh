#!/bin/sh

# The names of the HAST resources, as listed in hast.conf
# Use the same name for your pool or mount point

resources="hast1 hast2"

#logging
log="local0.debug"


#end of user configurable stuff
#do not go beyond this point

name="hast-carp-promote.sh"

logger -p $log -t $name "Switching to primary provider for
${resources}."


# Wait for all "hastd secondary" processes to stop

for disk in ${resources}; do
    while $( pgrep -lf "hastd: ${disk} \(secondary\)" > /dev/null 2>&1 ); do
        sleep 1
    done
    
    # Switch role for each disk
    hastctl role primary ${disk}
    if [ $? -ne 0 ]; then
        logger -p $log -t $name "Unable to change role to primary for resource ${disk}."
        exit 1
    fi
done

logger -p $log -t $name "Role for HAST resources ${resources} switched
to primary."

		#Let HAST script mount the filesystem
		
