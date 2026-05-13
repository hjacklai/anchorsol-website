#!/usr/bin/env perl
# Rename the "Lean" tab to "Compare" in the tabbar across every page,
# AND swap the lightning-bolt icon for the bar-chart icon that better
# fits the meaning. The tab keeps its existing href (#lean / ../#lean)
# because the section's underlying anchor is unchanged.
use strict;
use warnings;
use File::Find;

my $root = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site';

my @files;
find(sub { push @files, $File::Find::name if /\.html$/ }, $root);

# The old Lean tab block has:
#   - svg path "M13 2 L4 14 H11 L11 22 L20 10 H13 L13 2 Z"   (lightning)
#   - label "Lean"
# We rewrite the inner svg paths AND change the label to "Compare".

my $touched = 0;
for my $fp (@files) {
  open my $in, '<:utf8', $fp or die "read $fp: $!";
  my $html = do { local $/; <$in> };
  close $in;
  my $orig = $html;

  # Match the Lean tab on either index (#lean) or inner pages (../#lean).
  # Replace svg paths AND label.
  $html =~ s{
    (<a\s+class="tabbar__tab"\s+href="(?:\.\./)?\#lean">\s*
     <svg\s+class="tabbar__icon"[^>]*>\s*)
    <path\s+d="M13\s+2\s+L4\s+14\s+H11\s+L11\s+22\s+L20\s+10\s+H13\s+L13\s+2\s+Z"\s*/>\s*
    (</svg>\s*)
    <span\s+class="tabbar__lbl">Lean</span>
  }{$1<path d="M12 3 V21"/><path d="M6 8 H18"/><path d="M3 14 L6 8 L9 14 Z"/><path d="M15 14 L18 8 L21 14 Z"/>$2<span class="tabbar__lbl">Compare</span>}gxs;

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
