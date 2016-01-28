#!/bin/sh

HOSTNAME=$(hostname)

case $1 in

    role)
	case $4 in
	    primary)
		sleep 3
		zpool import -f $2
		logger "importing pool $2"
		;;
	    *)
		;;
	esac
	;;
    
		  
    syncstart)
	mail -s "sync started for $2 on $HOSTNAME" root <<EOF
HAST sync started, what happened?
EOF
	;;
    
    *)
;;

esac

logger hastd event: $1 $2 $3 $4
