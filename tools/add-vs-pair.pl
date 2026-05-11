#!/usr/bin/env perl
use strict;
use warnings;

my $fp = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/index.html';
open(my $in, '<', $fp) or die;
my $html = do { local $/; <$in> };
close $in;

# Row labels in order
my @labels = (
  'mechanism', 'construction', 'vibration', 'crew',
  'backfill', 'seismic', 'cost'
);

# Function: in a given block (the column markup), tag each vs__row in order
sub tag_block {
  my ($block) = @_;
  my $i = 0;
  $block =~ s{<div class="vs__row"([^>]*)>}{
    my $existing = $1;
    my $label = $labels[$i++] // 'extra';
    qq{<div class="vs__row" data-vs-pair="$label"}.(length $existing && $existing !~ /data-vs-pair/ ? $existing : '').qq{>}
  }ge;
  return $block;
}

# Match each column block and rewrite
$html =~ s{(<div class="vs__col vs__col--us">.*?</div>\s*</div>)}{tag_block($1)}ges;
$html =~ s{(<div class="vs__col vs__col--them">.*?</div>\s*</div>)}{tag_block($1)}ges;

open(my $out, '>', $fp) or die;
print $out $html;
close $out;
print "Done.\n";
