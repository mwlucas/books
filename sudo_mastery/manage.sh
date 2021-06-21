#!/bin/sh

cd /etc/sudoers.d.tmp/
sudodigest.pl > 00-digests
digest-everything.pl 00-digests > 10-everything
backup-alias.pl 00-digests > 10-backup
helpdesk-alias.pl 00-digests > 10-helpdesk
exec-alias.pl 00-digests > 10-exec
#...
