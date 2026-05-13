#!/usr/bin/env perl
# v2, handles both the single-line and multi-line Article JSON-LD formats.
use strict;
use warnings;
use File::Find;

my $root = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site';

my @files;
find(sub { push @files, $File::Find::name if /\.html$/ }, $root);

my $audience = q|{"@type": "Audience", "name": "Civil engineers, geotechnical engineers, quantity surveyors, contractors, developers, and approving authorities (JKR, LLM, KTMB, JPS) involved in retaining wall design and procurement", "audienceType": "professional"}|;

my $speakable = q|{"@type": "SpeakableSpecification", "cssSelector": [".article__lede", ".article__head h1"]}|;

my $touched = 0;
my $skipped = 0;

for my $fp (@files) {
  open my $in, '<:utf8', $fp or die "read $fp: $!";
  my $html = do { local $/; <$in> };
  close $in;

  next if $html =~ /isAccessibleForFree/;  # already enhanced

  my $orig = $html;

  # Find the "inLanguage": "en-MY" line and insert 3 extra properties after it.
  # Handles both forms:
  #   "inLanguage": "en-MY"},          (single-line, no comma before })
  #   "inLanguage": "en-MY"\n    },    (multi-line)
  $html =~ s{
    ("inLanguage":\s*"en-MY")(\s*\},)
  }{$1,\n      "isAccessibleForFree": true,\n      "audience": $audience,\n      "speakable": $speakable$2}gxs;

  $html =~ s{
    ("inLanguage":\s*"en-MY")(\s*\n\s*\},)
  }{$1,\n      "isAccessibleForFree": true,\n      "audience": $audience,\n      "speakable": $speakable$2}gxs;

  # If the Article block doesn't have "inLanguage" at all (unlikely for our
  # articles), skip it; we don't want to blindly inject into wrong places.

  if ($html ne $orig) {
    open my $out, '>:utf8', $fp or die "write $fp: $!";
    print $out $html;
    close $out;
    $touched++;
    my $rel = $fp; $rel =~ s{^.*?/site/}{site/};
    print "OK    $rel\n";
  } else {
    $skipped++;
  }
}

print "\nDone. $touched enhanced, $skipped already done or no match.\n";
