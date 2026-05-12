#!/usr/bin/env perl
# Parse the extracted PDF text into structured JSON. Each project ends up
# as {item, title, client, contractor, qty}. We then classify each project
# into a category based on keywords in the title -> category drives the
# challenge/solution copy on the projects page.
use strict;
use warnings;
use utf8;
binmode(STDOUT, ':encoding(UTF-8)');

my $txt = do {
  local $/;
  open(my $f, '<:encoding(UTF-8)', '/tmp/anchorsol-projects.txt') or die $!;
  <$f>;
};

# Pre-process: strip page headers + repeated table headers + page numbers
$txt =~ s/AnchorSOL Wall Sdn\. Bhd\.//g;
$txt =~ s/List of Selected JKR, Authorities Government Department Projects \(With Wall Area > 3000m2\)//g;
$txt =~ s/Item\s+Project Description\s+Client\s+Main Contractor\s+Qty \(m2\)//gi;
$txt =~ s/Page \d+//g;

# Find every numbered project start: e.g. "  1 Project description..." or "117 ..."
# We capture: item number, then everything until the NEXT numbered project
my @items;
while ($txt =~ /
  (?:^|\n)\s*(\d{1,3})\s+        # item number
  (.+?)                           # block content
  (?=(?:\n\s*\d{1,3}\s+)|\z)      # until next numbered line OR end
/sxg) {
  my ($num, $block) = ($1, $2);
  next if $num > 200; # safety: PDF max is 161

  # Crude split: split on multiple spaces to detect column transitions
  # Real format is: description (multiple lines) ... client_name ... contractor_name ... qty
  my $clean = $block;
  $clean =~ s/\s+/ /g;
  $clean =~ s/^\s+|\s+$//g;

  push @items, { num => $num, raw => $clean };
}

# Output as a perl-parseable Data::Dumper-ish list for the next step to consume
for my $it (@items) {
  printf "ITEM\t%s\t%s\n", $it->{num}, $it->{raw};
}
print STDERR "Parsed " . scalar(@items) . " items.\n";
