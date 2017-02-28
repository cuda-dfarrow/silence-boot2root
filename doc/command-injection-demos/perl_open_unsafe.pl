#!/usr/bin/perl

if (@ARGV != 1) {
  print "Usage: $0 <file-to-open>\n";
} else {
  print "I'm about to open the file\n";
  open(FD, @ARGV[0]);
  print "I've finished opening the file\n";
  while (my $line=<FD>) {
    chomp $line;
    print "I read line [$line]\n";
  }
  close(FD);
}
