#!/usr/bin/env perl
# Wrap visible-body ® occurrences in <sup class="reg">®</sup> for smaller display.
# Skips JSON-LD blocks and HTML attribute values.

use strict;
use warnings;
use File::Find;

my @files;
find(sub {
  push @files, $File::Find::name if /\.html$/i;
}, 'site');

my $total_files = 0;
my $total_subs = 0;

# ASCII sentinels that will not appear in real HTML
my $SP = '\x01PLACEHOLDER_SCRIPT_';
my $TP = '\x01PLACEHOLDER_TAG_';
my $EP = '_END\x01';

# Use literal control characters as bookends
my $SP_OPEN = "\x01\x02SCRIPT_";
my $SP_CLOSE = "_END\x02";
my $TP_OPEN = "\x01\x03TAG_";
my $TP_CLOSE = "_END\x03";

for my $file (@files) {
  open my $in, '<:raw', $file or die "open $file: $!";
  my $content = do { local $/; <$in> };
  close $in;
  my $original = $content;

  # Step 1: extract <script>...</script> blocks
  my @scripts;
  $content =~ s{(<script\b[^>]*>.*?</script>)}{
    push @scripts, $1;
    "${SP_OPEN}" . $#scripts . "${SP_CLOSE}"
  }gse;

  # Step 2: extract HTML tags
  my @tags;
  $content =~ s{(<[^>]+>)}{
    push @tags, $1;
    "${TP_OPEN}" . $#tags . "${TP_CLOSE}"
  }gse;

  # Step 3: wrap AnchorSOL® in remaining text-node content
  my $subs = 0;
  $subs += ($content =~ s{AnchorSOL\xC2\xAE}{AnchorSOL<sup class="reg">\xC2\xAE</sup>}g);

  # Restore tags
  $content =~ s{\Q${TP_OPEN}\E(\d+)\Q${TP_CLOSE}\E}{$tags[$1]}g;

  # Restore scripts
  $content =~ s{\Q${SP_OPEN}\E(\d+)\Q${SP_CLOSE}\E}{$scripts[$1]}g;

  # Upgrade bare <sup>®</sup> to <sup class="reg">®</sup>
  $subs += ($content =~ s{<sup>\xC2\xAE</sup>}{<sup class="reg">\xC2\xAE</sup>}g);

  # Sanity check — control chars should not remain
  if ($content =~ /[\x01-\x03]/) {
    warn "Sentinel leaked in $file — aborting this file\n";
    next;
  }

  if ($content ne $original) {
    open my $out, '>:raw', $file or die "write $file: $!";
    print $out $content;
    close $out;
    $total_files++;
    $total_subs += $subs;
    print "$file: $subs subs\n";
  }
}

print "\nTotal: $total_subs subs across $total_files files\n";
