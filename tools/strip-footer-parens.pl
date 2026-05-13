#!/usr/bin/env perl
# Strip the parenthetical counters from footer link labels across all pages.
use strict;
use warnings;
use File::Find;

my $root = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site';

my @files;
find(sub { push @files, $File::Find::name if /\.html$/ }, $root);

my %subs = (
  'Applications (12 use cases)'   => 'Applications',
  'Locations (16 states)'         => 'Locations',
  'All projects (500+)'           => 'All projects',
  'Knowledge Base (10 guides)'    => 'Knowledge Base',
);

my $touched = 0;
for my $fp (@files) {
  open my $in, '<:utf8', $fp or die "read $fp: $!";
  my $html = do { local $/; <$in> };
  close $in;
  my $orig = $html;

  for my $find (keys %subs) {
    my $rep = $subs{$find};
    $html =~ s/\Q$find\E/$rep/g;
  }

  if ($html ne $orig) {
    open my $out, '>:utf8', $fp or die "write $fp: $!";
    print $out $html;
    close $out;
    $touched++;
    my $rel = $fp; $rel =~ s{^.*?/site/}{site/};
    print "OK    $rel\n";
  }
}
print "\nDone. $touched files updated.\n";
