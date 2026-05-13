#!/usr/bin/env perl
# Update the Compare tab href from #lean to #compare across all pages.
# The Compare tab was renamed from Lean; the section was just split out
# into its own #compare section, so the tab href needs to match.
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

  # Match the Compare tab block specifically (label is "Compare") and
  # rewrite ONLY this tab's href (not any other #lean references like
  # the See-the-difference link).
  $html =~ s{
    (<a\s+class="tabbar__tab"\s+href=")(?:\.\./)?\#lean(">\s*
     <svg[^>]*>.*?</svg>\s*
     <span\s+class="tabbar__lbl">Compare</span>\s*</a>)
  }{
    my $prefix = $1;
    my $suffix = $2;
    # Restore the ../ prefix if it was there originally
    my $is_inner = $fp !~ m{site/index\.html$};
    my $href = $is_inner ? '../#compare' : '#compare';
    "$prefix$href$suffix";
  }gexs;

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
