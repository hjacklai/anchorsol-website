#!/usr/bin/env perl
# Strip competitor brand names from KB articles + replace with generic
# technical equivalents. Keeps Henri Vidal + Terre Armée historical
# references intact (those are educational, not competitive).
use strict;
use warnings;

my $root = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site';

# Map of brand-name phrases to generic replacements
my @swaps = (
  # Nehemiah specific phrases
  ['(AnchorSOL®, Nehemiah Wall, and others in the "anchored earth" family)' => '(AnchorSOL® and other anchored MSE systems)'],
  ['Anchored MSE (AnchorSOL®, Nehemiah)' => 'Anchored MSE (AnchorSOL®)'],
  ['Reinforced Earth, AnchorSOL®, Nehemiah Wall, T-Wall, and similar are specific systems within the category' => 'Reinforced Earth, AnchorSOL®, T-Wall, and similar are specific systems within the category'],
  ['anchored soil</b> walls (AnchorSOL®, Nehemiah, similar)' => 'anchored soil</b> walls (AnchorSOL® and similar anchored MSE systems)'],
  ['The anchored variant has 30+ years of field history (Nehemiah, AnchorSOL, and related systems in Malaysia and globally)' => 'The anchored variant has 30+ years of field history (AnchorSOL® and related anchored MSE systems in Malaysia and globally)'],
  ['<h2>3. Anchored MSE wall (AnchorSOL®, Nehemiah, similar)</h2>' => '<h2>3. Anchored MSE wall (AnchorSOL® and similar systems)</h2>'],
  ['AnchorSOL® is one of two anchored MSE specialists in Malaysia (the other being Nehemiah Reinforced Soil). The differentiation against Nehemiah and against friction-based MSE comes down to' => 'AnchorSOL® is the Malaysian-developed anchored MSE specialist with 27 years of in-service track record. The differentiation against friction-based MSE comes down to'],
  ['Reinforced Earth, T-Wall, Nehemiah, AnchorSOL®' => 'Reinforced Earth, T-Wall, AnchorSOL®, and similar named systems'],

  # Tensar / Maccaferri / Polyfelt / Hilfiker / VSL / Terramesh
  ['<h3>HDPE punched-and-drawn geogrids (Tensar SR / TX series, similar)</h3>' => '<h3>HDPE punched-and-drawn geogrids</h3>'],
  ['<h3>PET woven geogrids (Maccaferri ParaLink, similar)</h3>' => '<h3>PET woven geogrids</h3>'],
  ['<b>Welded steel wire mesh variants</b> (Hilfiker, VSL, Mechanically Stabilized Embankment): substituting welded grid for flat strip, with higher interaction coefficient and competitive cost' => '<b>Welded steel wire mesh variants</b>: substituting welded grid for flat strip, with higher interaction coefficient and competitive cost'],
  ['<b>Geogrid systems</b> (Tensar SR series, Polyfelt): polymer reinforcement in lieu of steel, with different durability profile and design code path' => '<b>Geogrid systems</b>: polymer reinforcement in lieu of steel, with different durability profile and design code path'],
  ['<li><b>Maccaferri / Nehemiah Wall / Terramesh</b>: various geogrid and welded-mesh systems, particularly on township and residential walls</li>' => '<li><b>Geogrid + welded-mesh systems</b>: various geogrid and welded-mesh products from international and local suppliers, particularly on township and residential walls</li>'],
  ['<li><b>Reinforced Earth Company Malaysia</b>: friction-based Vidal system, selected federal road projects</li>' => '<li><b>The original Reinforced Earth system</b>: friction-based Vidal system, available on selected federal road projects through licensed local supply</li>'],
  ['<li>North American practice (Hilfiker, VSL Retained Earth systems)</li>' => '<li>North American welded-wire-mesh MSE practice</li>'],

  # RECo / Reinforced Earth Company / corporate references
  ['Reinforced Earth Company (later RECo, now Reinforced Earth / Terre Armée Internationale) commercialised the system worldwide.' => 'The original Reinforced Earth system was commercialised globally from the 1960s onwards.'],
  ['Reinforced Earth Company (RECo) was established to commercialise the system.' => 'The system was commercialised globally through licensed suppliers.'],

  # Keywords meta cleanup
  ['Reinforced Earth Company, RECo, ' => ''],
  [', Maccaferri gabion' => ''],
);

# Apply to all HTML files under site/
my @files;
sub recurse {
  my $dir = shift;
  opendir(my $dh, $dir) or return;
  while (my $e = readdir($dh)) {
    next if $e =~ /^\./;
    my $p = "$dir/$e";
    if (-d $p) { recurse($p); }
    elsif (-f $p && $p =~ /\.html$/) { push @files, $p; }
  }
  closedir($dh);
}
recurse($root);

my $touched = 0;
for my $fp (@files) {
  open my $in, '<:raw', $fp or die "read $fp: $!";
  my $html = do { local $/; <$in> };
  close $in;
  my $orig = $html;

  for my $sw (@swaps) {
    my ($find, $repl) = @$sw;
    # Plain substring replace (not regex), to avoid escaping issues
    my $idx = 0;
    while (($idx = index($html, $find, $idx)) >= 0) {
      substr($html, $idx, length($find)) = $repl;
      $idx += length($repl);
    }
  }

  if ($html ne $orig) {
    open my $out, '>:raw', $fp or die "write $fp: $!";
    print $out $html;
    close $out;
    $touched++;
    my $rel = $fp; $rel =~ s{^.*?/site/}{site/};
    print "OK    $rel\n";
  }
}

print "\nDone. $touched files updated.\n";
