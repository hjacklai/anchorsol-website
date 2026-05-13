#!/usr/bin/env perl
# Remove the visible Dr. Lai mentions from state pages and the contractor
# landing page. Keep the JSON-LD Person author intact (invisible to readers,
# valuable for LLM/SEO authority signal).
#
# Two mentions to strip per page:
#   1. Visible byline: <p class="article__meta">By <b>Dr. Ir. Lai Yip Poon</b>...</p>
#   2. Italicised state-specific quote: <p class="article__lai-quote">...</p>
use strict;
use warnings;
use File::Path;

my @targets = (
  glob("G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/locations/*/index.html"),
  "G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/contractor/index.html",
);

my $touched = 0;
for my $fp (@targets) {
  next unless -f $fp;
  open my $in, '<:raw', $fp or die "read $fp: $!";
  my $html = do { local $/; <$in> };
  close $in;
  my $orig = $html;

  # Strip the italicised Dr. Lai quote block (state pages only).
  # Matches <p class="article__lai-quote" ...>...— Dr. Ir. Lai Yip Poon...</span></p>
  $html =~ s{
    \s*<p\s+class="article__lai-quote"[^>]*>.*?</p>\s*
  }{\n}gxs;

  # Replace visible Dr. Lai byline with a neutral AnchorSOL byline.
  $html =~ s{
    <p\s+class="article__meta">By\s+<b>Dr\.\s+Ir\.\s+Lai\s+Yip\s+Poon</b>[^<]*</p>
  }{<p class="article__meta">By <b>AnchorSOL\xC2\xAE Wall Sdn. Bhd.</b> &middot; Engineering reference &middot; ~10 min read</p>}gxs;

  if ($html ne $orig) {
    open my $out, '>:raw', $fp or die "write $fp: $!";
    print $out $html;
    close $out;
    $touched++;
    my $rel = $fp; $rel =~ s{^.*?/site/}{site/};
    print "OK    $rel\n";
  }
}

print "\nDone. $touched files updated. JSON-LD Person author preserved.\n";
