#!/usr/bin/env perl
#Takes a digest list of command aliases and builds am alias
#named BACKUP containing select commands
die unless (open(DIGESTS, $ARGV[0]));

print "Cmnd_Alias BACKUP = ";
while (<DIGESTS>) {
  chomp;
  next unless /^Cmnd_Alias/;
  my ($discard, $CmndAlias, $equal, $hash, $command) = split;
  next unless ($command =~ m'^/sbin/dump$|^/sbin/restore$|^/usr/bin/mt$');
  print "$CmndAlias, ";
}

#An alias cannot end with a comma, so list a non-runnable non-existent
#thing at the end
print "/nonexistent\n\n";

