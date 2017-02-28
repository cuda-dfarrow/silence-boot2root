#!/usr/bin/perl

if (@ARGV != 1) {
  print "Usage: $0 <arg-to-ls>\n";
} else {
  print "I'm about to do the ls\n";
  system("/bin/ls", "-la", @ARGV[0]);
  print "I've finished doing the ls\n";
}
