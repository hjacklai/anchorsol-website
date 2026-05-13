#!/usr/bin/env perl
# Adds three high-impact JSON-LD properties to every Article schema block
# in site/learn/*.html, site/applications/index.html, site/locations/index.html:
#
#   isAccessibleForFree: true   (Google rich-result signal for free content)
#   audience: {...}             (target reader signal: engineers, QSs, contractors)
#   speakable: {...}            (voice-search signal for Google Assistant / Siri)
#
# Idempotent: skips files that already have isAccessibleForFree.
use strict;
use warnings;
use File::Find;

my $root = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site';

my @files;
find(sub { push @files, $File::Find::name if /\.html$/ }, $root);

my $audience_json = q|"audience": {"@type": "Audience", "name": "Civil engineers, geotechnical engineers, quantity surveyors, contractors, developers, and approving authorities (JKR, LLM, KTMB, JPS) involved in retaining wall design and procurement", "audienceType": "professional"}|;

my $speakable_json = q|"speakable": {"@type": "SpeakableSpecification", "cssSelector": [".article__lede", ".article__head h1"]}|;

my $extras = qq|     "isAccessibleForFree": true,\n     $audience_json,\n     $speakable_json,\n|;

my $touched = 0;
for my $fp (@files) {
  open my $in, '<:utf8', $fp or die "read $fp: $!";
  my $html = do { local $/; <$in> };
  close $in;
  my $orig = $html;

  # Skip if already enhanced
  next if $html =~ /isAccessibleForFree/;

  # Match the Article schema object and insert extras before the closing brace.
  # Pattern: {"@type": "Article", "@id": "...", ... "inLanguage": "en-MY"},
  # We insert just before "publisher" or "mainEntityOfPage" or "inLanguage" line.
  # Safest: insert right after the "@type": "Article" line opener, before headline.
  # Even safer: insert right before the closing brace of the Article object.

  # Match the Article object (allowing multiple lines), insert extras before
  # the closing "}" that ends the Article object's properties.
  if ($html =~ s{
    (\{"\@type":\s*"Article",.*?"inLanguage":\s*"en-MY"\},)
  }{my $obj = $1; $obj =~ s/("inLanguage":\s*"en-MY")(\},)$/$1,\n     "isAccessibleForFree": true,\n     $audience_json,\n     $speakable_json$2/s; $obj}exs) {
    # OK
  }

  if ($html ne $orig) {
    open my $out, '>:utf8', $fp or die "write $fp: $!";
    print $out $html;
    close $out;
    $touched++;
    my $rel = $fp; $rel =~ s{^.*?/site/}{site/};
    print "OK    $rel\n";
  }
}

print "\nDone. $touched files enhanced.\n";
