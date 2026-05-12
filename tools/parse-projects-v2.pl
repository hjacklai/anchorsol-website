#!/usr/bin/env perl
# Better parser: uses column-aligned table-mode pdftotext output to extract
# each project as { item, title, client, contractor, qty } using fixed
# column slicing + multi-line joining for wrapped fields.
use strict;
use warnings;
use utf8;
binmode(STDOUT, ':encoding(UTF-8)');

# Column positions observed from /tmp/projects-table.txt
my $C_ITEM   = 0;   # 0-5
my $C_DESC   = 6;   # 6-58 (~52 chars)
my $C_CLIENT = 60;  # 60-83 (~24 chars)
my $C_CONTR  = 85;  # 85-110 (~25 chars)
my $C_QTY    = 110; # 110+

open(my $f, '<:encoding(UTF-8)', '/tmp/projects-table.txt') or die $!;
my @lines = <$f>;
close $f;

# Trim trailing newlines but keep leading spaces
chomp @lines;

# Strip page headers / table headers / repeated boilerplate lines
@lines = grep {
  $_ !~ /^AnchorSOL Wall Sdn/ &&
  $_ !~ /^List of Selected JKR/ &&
  $_ !~ /^Item\s+Project Description/i &&
  $_ !~ /^Page \d+/
} @lines;

# Walk through lines; a project starts when col0 has a number
my @projects;
my $current;
for my $line (@lines) {
  next if $line =~ /^\s*$/;

  # Pad to full width for safe substring extraction
  $line .= ' ' x 130 if length($line) < 130;

  my $item_field = substr($line, $C_ITEM, $C_DESC - $C_ITEM);
  $item_field =~ s/^\s+|\s+$//g;

  if ($item_field =~ /^(\d+)$/) {
    # Push the previous project (if any)
    push @projects, $current if $current;
    $current = {
      item     => $1,
      title    => '',
      client   => '',
      contractor => '',
      qty      => '',
    };
  }
  next unless $current;

  my $desc   = substr($line, $C_DESC,   $C_CLIENT - $C_DESC);
  my $client = substr($line, $C_CLIENT, $C_CONTR  - $C_CLIENT);
  my $contr  = substr($line, $C_CONTR,  $C_QTY    - $C_CONTR);
  my $qty    = substr($line, $C_QTY);

  for ($desc, $client, $contr, $qty) { $_ //= ''; s/^\s+|\s+$//g; }

  $current->{title}      .= ($current->{title}      && $desc   ? ' ' : '') . $desc   if length $desc;
  $current->{client}     .= ($current->{client}     && $client ? ' ' : '') . $client if length $client;
  $current->{contractor} .= ($current->{contractor} && $contr  ? ' ' : '') . $contr  if length $contr;
  $current->{qty}         = $qty if length $qty;
}
push @projects, $current if $current;

# Clean: dedupe whitespace and trim trailing punctuation noise
for my $p (@projects) {
  for my $k (qw(title client contractor qty)) {
    $p->{$k} =~ s/\s+/ /g;
    $p->{$k} =~ s/^\s+|\s+$//g;
  }
}

# Output as a single JS array literal
print "// Auto-generated from AnchorSOL-Project List(2025).pdf - DO NOT EDIT BY HAND\n";
print "// Re-generate via: perl tools/parse-projects-v2.pl > site/projects/projects-data.js\n";
print "window.ANCHORSOL_PROJECTS = [\n";
for my $p (@projects) {
  next unless $p->{title} || $p->{client};
  my $title = $p->{title};   $title =~ s/"/\\"/g; $title =~ s/'/\\'/g;
  my $client = $p->{client}; $client =~ s/"/\\"/g; $client =~ s/'/\\'/g;
  my $contr = $p->{contractor}; $contr =~ s/"/\\"/g; $contr =~ s/'/\\'/g;
  my $qty = $p->{qty} || '';
  print qq{  { item: $p->{item}, title: "$title", client: "$client", contractor: "$contr", qty: "$qty" },\n};
}
print "];\n";
print STDERR "Parsed " . scalar(@projects) . " projects.\n";
