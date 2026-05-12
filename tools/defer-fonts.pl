#!/usr/bin/env perl
# Convert the render-blocking Google Fonts <link rel="stylesheet"> to a deferred
# load using the media="print" onload trick. This unblocks first paint.
#
# Pattern we rewrite:
#   <link rel="stylesheet" href="https://fonts.googleapis.com/css2?...display=swap" />
# becomes:
#   <link rel="preload" as="style" href="..." />
#   <link rel="stylesheet" href="..." media="print" onload="this.media='all'" />
#   <noscript><link rel="stylesheet" href="..." /></noscript>
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

  # Find a <link rel="stylesheet" href="https://fonts.googleapis.com/..." /> tag
  if ($html =~ m{<link\s+rel="stylesheet"\s+href="(https://fonts\.googleapis\.com/css2\?[^"]+)"\s*/?>}) {
    my $href = $1;
    my $replacement = qq(<link rel="preload" as="style" href="$href" />\n<link rel="stylesheet" href="$href" media="print" onload="this.media='all'" />\n<noscript><link rel="stylesheet" href="$href" /></noscript>);
    $html =~ s{<link\s+rel="stylesheet"\s+href="\Q$href\E"\s*/?>}{$replacement};
  }

  if ($html ne $orig) {
    open(my $out, '>:utf8', $fp_path) or die "write $fp_path: $!";
    print $out $html;
    close($out);
    $touched++;
    my $rel = $fp_path; $rel =~ s{^.*?/site/}{site/};
    print "OK    $rel\n";
  }
}

print "\nDone. $touched files updated.\n";
