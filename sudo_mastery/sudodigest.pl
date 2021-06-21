#!/usr/bin/env perl
#Generate sudo checksums and aliases for all programs in a directory

#Put lists of directories here
@directories = ("/bin", "/sbin", "/usr/bin", "/usr/sbin", "/usr/local/bin", "/usr/local/sbin");

#figure out OS & patchlevel to put in front of our commands, to make
#aliases unique, and add that to top of output for use by Future Me
chomp($os=`uname -s`); #what OS are we running
chomp($patchlevel=`uname -r`); #current release

print "#Generated for $os $patchlevel\n#\n\n";

foreach $directory (@directories) {
  #we need a label for the directory
  $pathlabel=$directory;
  $pathlabel=~s#/##g;

  #assemble prefix for command name
  $prefix="$os-$patchlevel-$pathlabel-";

  #aliases can only contain [A-Z0-9_], sanitize to that
  $prefix = uc $prefix;
  $prefix =~ s/[^A-Z0-9_]/_/g;

  #We can now process individual directory entries and produce
  #sudoers digest lines
  opendir (DIRECTORY, $directory);
  while ( $file = readdir (DIRECTORY)) {
    if ($file eq "." || $file eq "..") {
      next;
    }

    my $literalpath = "$directory/$file";

    #/usr/bin/mail and /usr/bin/Mail both exist, because life
    #hates me. Can't share alias names, so put a _ in front of every
    #captial letter in the filename.
    $file =~ s#([A-Z])#_\1#g;

    #Build & sanitize command alias
    my $file = uc $file;
    my $CmndAlias = "${prefix}$file";
    $CmndAlias =~ s#[.]#DOT#g;
    $CmndAlias =~ s#[+]#PLUS#g;
    $CmndAlias =~ s#[-]#DASH#g;
    $CmndAlias =~ s#[[]#LBRACKET#g;

    print "Cmnd_Alias $CmndAlias = sha512:";

    if ($os =~ /BSD/) {
      #we use sha512(1)
      chomp($digest=`/sbin/sha512 -q $literalpath`);
      print "$digest ";
      print "$literalpath";
      print "\n";
    }

    if ($os =~ /Linux/) {
      #we use sha512sum(1)
      $digest=`/usr/bin/sha512sum $literalpath`;
      print "$digest";
    }
  }
}

#Now use ids-sudoers.pl to build sample policies
