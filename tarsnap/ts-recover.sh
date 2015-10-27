#!/bin/sh -x

#Sample script for restoring multiple Tarsnap archives in parallel.
#from "Tarsnap Mastery: 

#copy Tarsnap key to new host
tarsnap --fsck

#do everything from the root directory
cd /

#These archives we will want to extract directly.

tarsnap -xvf www-daily-2015-01-20_05:30:08-varwww > /tmp/varwww.log 2>&1  &
tarsnap -xvf www-daily-2015-01-20_05:30:08-varlog > /tmp/varlog.log 2>&1  &
tarsnap -xvf www-daily-2015-01-20_05:30:08-vardbbk-mysql > /tmp/vardbbk-mysql.log 2>&1  &
tarsnap -xvf www-daily-2015-01-20_05:30:08-usrlocalscripts > /tmp/scripts.log 2>&1  &
tarsnap -xvf www-daily-2015-01-20_05:30:08-home > /tmp/home.log 2>&1  &

#these we don't want to overwrite
tarsnap -xvf www-daily-2015-01-20_05:30:08-usrlocaletc -s /etc/oldetc/ > /tmp/usrlocaletc.log 2>&1  &
tarsnap -xvf www-daily-2015-01-20_05:30:08-etc -s /etc/oldetc/ > /tmp/etc.log 2>&1 &
