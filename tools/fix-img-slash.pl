#!/usr/bin/env perl
# Fix the stray "/" left behind when we appended decoding="async" / loading="lazy"
# to self-closing <img ... /> tags. The bad pattern looks like:
#   <img src="..." data-no-picture / decoding="async">
# We want:
#   <img src="..." data-no-picture decoding="async">
use strict;
use warnings;
use File::Find;

my $root = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site';

my @files;
find(sub { push @files, $File::Find::name if /\.html$/ }, $root);

my $touched = 0;
for my $fp_path (@files) {
  open(my $in, '<:utf8', $fp_path) or die "read $fp_path: $!";
  my $html = do { local $/; <$in> };
  close($in);
  my $orig = $html;

  # Inside an <img ...> tag, kill any " /" that appears before an attribute.
  # We match <img ... > greedily and rewrite the inside.
  $html =~ s{<img\s([^>]*?)>}{
    my $inside = $1;
    # Repeatedly remove " /" when it's followed by whitespace and another attribute
    $inside =~ s{\s+/\s+(?=\w)}{ }g;
    # Also handle trailing " /" right before the closing >
    $inside =~ s{\s+/\s*$}{};
    "<img $inside>";
  }gex;

  if ($html ne $orig) {
    open(my $out, '>:utf8', $fp_path) or die "write $fp_path: $!";
    print $out $html;
    close($out);
    $touched++;
    my $rel = $fp_path; $rel =~ s{^.*?/site/}{site/};
    print "OK    $rel\n";
  }
}

print "\nDone. $touched files fixed.\n";
