#!/usr/bin/env perl
# v2: explicit file list (Perl glob splits on spaces in Windows paths)
use strict;
use warnings;

my $root = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site';

# Read state directories manually
opendir(my $dh, "$root/locations") or die "open dir: $!";
my @state_dirs = grep { -d "$root/locations/$_" && !/^\./ } readdir($dh);
closedir($dh);

my @targets = map { "$root/locations/$_/index.html" } @state_dirs;
# Contractor page already done by v1, skip

my $touched = 0;
for my $fp (@targets) {
  next unless -f $fp;
  open my $in, '<:raw', $fp or die "read $fp: $!";
  my $html = do { local $/; <$in> };
  close $in;
  my $orig = $html;

  # Strip the italicised Dr. Lai quote
  $html =~ s{
    \s*<p\s+class="article__lai-quote"[^>]*>.*?</p>\s*
  }{\n}gxs;

  # Replace visible Dr. Lai byline with neutral AnchorSOL byline
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

print "\nDone. $touched state pages updated.\n";
