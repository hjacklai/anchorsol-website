#!/usr/bin/env perl
# Remove the Compare tab (href="../#why" or "#why") from all tabbars,
# since the #why "Not just reinforced. Anchored." section was deleted.
use strict;
use warnings;
use File::Find;

my $root = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site';

my @files;
find(sub { push @files, $File::Find::name if /\.html$/ }, $root);

my $touched = 0;
for my $fp (@files) {
  open my $in, '<:utf8', $fp or die "read $fp: $!";
  my $html = do { local $/; <$in> };
  close $in;
  my $orig = $html;

  # Match the Compare tab block in the tabbar (with either "../#why" or "#why").
  # The tab is one <a> with svg + label "Compare".
  $html =~ s{
    \s*<a\s+class="tabbar__tab"\s+href="(?:\.\./)?\#why">\s*
    <svg[^>]*>.*?</svg>\s*
    <span\s+class="tabbar__lbl">Compare</span>\s*
    </a>\s*
  }{\n    }gxs;

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
