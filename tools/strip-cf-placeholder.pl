#!/usr/bin/env perl
# Strip the Cloudflare Web Analytics placeholder script tag.
# Pattern: <script defer src="https://static.cloudflareinsights.com/beacon.min.js"
#             data-cf-beacon='{"token": "REPLACE_WITH_CF_ANALYTICS_TOKEN"}'></script>
# This sends a token=REPLACE_WITH_CF_ANALYTICS_TOKEN beacon every page load,
# which is wasted requests until a real CF token is wired in.
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

  # Strip the CF beacon script with its surrounding whitespace
  $html =~ s{
    \s*<script\s+defer\s+src="https://static\.cloudflareinsights\.com/beacon\.min\.js"[^>]*REPLACE_WITH_CF_ANALYTICS_TOKEN[^>]*></script>\s*
  }{\n}gxs;

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
