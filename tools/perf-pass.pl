#!/usr/bin/env perl
# Performance pass across every site/**.html
# 1. Add decoding="async" to every <img> tag that doesn't already have it
# 2. Add loading="lazy" to every <img> that doesn't already have it (skip hero image)
# 3. Add fetchpriority="high" to the hero poster image
use strict;
use warnings;
use File::Find;

my $root = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site';

my @files;
find(sub { push @files, $File::Find::name if /\.html$/ }, $root);

my ($touched, $img_total, $dec, $laz, $fp) = (0, 0, 0, 0, 0);

for my $fp_path (@files) {
  open(my $in, '<:utf8', $fp_path) or die "read $fp_path: $!";
  my $html = do { local $/; <$in> };
  close($in);
  my $orig = $html;

  # Count current <img tags
  my @imgs = ($html =~ /<img\s[^>]*>/g);
  $img_total += scalar @imgs;

  # Add decoding="async" to <img> tags that don't have decoding=
  my $count_dec = 0;
  $html =~ s{(<img\s+(?:(?!decoding=)[^>])*?)>}{
    my $tag = $1;
    $count_dec++;
    "$tag decoding=\"async\">";
  }gex;
  $dec += $count_dec;

  # Add loading="lazy" to <img> tags that don't have loading=
  # EXCEPT the hero poster (wall-linear-poster.jpg as src of fallback <img>)
  # and the logo (data-no-picture marker)
  my $count_laz = 0;
  $html =~ s{(<img\s+(?:(?!loading=)[^>])*?)>}{
    my $tag = $1;
    if ($tag =~ /wall-linear-poster\.jpg/ || $tag =~ /data-no-picture/ || $tag =~ /logo-white\.png/) {
      "$tag>";  # leave it alone — hero or logo
    } else {
      $count_laz++;
      "$tag loading=\"lazy\">";
    }
  }gex;
  $laz += $count_laz;

  # Add fetchpriority="high" to the hero fallback img
  if ($html =~ m{<img src="assets/videos/wall-linear-poster\.jpg"[^>]*?>}) {
    unless ($html =~ m{<img src="assets/videos/wall-linear-poster\.jpg"[^>]*?fetchpriority=}) {
      $html =~ s{(<img src="assets/videos/wall-linear-poster\.jpg")}{$1 fetchpriority="high"}g;
      $fp++;
    }
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

print "\nDone.\n";
print "  Files touched     : $touched / ", scalar(@files), "\n";
print "  Total <img> seen  : $img_total\n";
print "  decoding=async    : +$dec\n";
print "  loading=lazy      : +$laz\n";
print "  fetchpriority=high: +$fp (hero poster)\n";
