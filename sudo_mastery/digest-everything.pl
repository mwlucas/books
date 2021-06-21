#!/usr/bin/env perl
#Takes a digest list of command aliases and builds a couple of
#sample sudoers policies from them. Takes one argument, a file
#containing digest aliases.
die unless (open(DIGESTS, $ARGV[0]));

print "Cmnd_Alias EVERYTHING = ";
while (<DIGESTS>) {
  chomp;
  next unless /^Cmnd_Alias/;
  my ($discard, $CmndAlias, $equal, $hash, $command) = split;
  print "$CmndAlias, ";
}

#An alias cannot end with a comma, so list a non-runnable non-existent
#thing at the end
print "/nonexistent\n\n";

#support both wheel and sudo groups for cross-platform
print "%wheel ALL= EVERYTHING\n";
print "%sudo ALL= EVERYTHING\n";
