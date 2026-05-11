#!/usr/bin/env perl
# Replace each <span class="num">[ NN ]</span> on the homepage with an
# inline SVG icon that matches the section's purpose. Same iconography
# as the bottom tab bar, so users learn the visual vocabulary once.
use strict;
use warnings;

my $fp = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/index.html';

# Map section section-num text -> SVG path content
my $stroke_attrs = 'viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true"';

my %icons = (
  '00'      => '<circle cx="12" cy="12" r="9"/><path d="M12 8 V8.01" stroke-width="2.5"/><path d="M12 11 V17"/>',
  '01'      => '<rect x="4" y="4" width="7" height="7"/><rect x="13" y="4" width="7" height="7"/><rect x="4" y="13" width="7" height="7"/><rect x="13" y="13" width="7" height="7"/>',
  '01b'     => '<rect x="3" y="8" width="18" height="8"/><path d="M7 8 V12"/><path d="M11 8 V12"/><path d="M15 8 V12"/><path d="M19 8 V12"/>',
  '01c'     => '<path d="M12 3 L3 8 L12 13 L21 8 L12 3 Z"/><path d="M3 12 L12 17 L21 12"/><path d="M3 16 L12 21 L21 16"/>',
  '02'      => '<path d="M12 3 V21"/><path d="M6 8 H18"/><path d="M3 14 L6 8 L9 14 Z"/><path d="M15 14 L18 8 L21 14 Z"/>',
  '03'      => '<path d="M13 2 L4 14 H11 L11 22 L20 10 H13 L13 2 Z"/>',
  '05'      => '<rect x="3" y="5" width="18" height="14"/><path d="M3 16 L8 11 L13 16 L17 12 L21 16"/><circle cx="8" cy="9" r="1.5" fill="currentColor"/>',
  '06'      => '<circle cx="12" cy="8" r="4"/><path d="M4 21 V19 C4 16 7 14 12 14 C17 14 20 16 20 19 V21"/>',
  '07'      => '<rect x="3" y="6" width="18" height="13"/><path d="M3 7 L12 14 L21 7"/>',
  'Gallery' => '<rect x="3" y="5" width="18" height="14"/><path d="M3 16 L8 11 L13 16 L17 12 L21 16"/><circle cx="8" cy="9" r="1.5" fill="currentColor"/>',
);

open(my $in, '<', $fp) or die "open: $!";
my $html = do { local $/; <$in> };
close $in;

my $changed = 0;
for my $key (keys %icons) {
  my $svg = qq{<span class="secmark__icon"><svg $stroke_attrs>$icons{$key}</svg></span>};
  my $old = qq{<span class="num">[ $key ]</span>};
  if (index($html, $old) >= 0) {
    $html =~ s/\Q$old\E/$svg/g;
    $changed++;
    print "OK   $key\n";
  } else {
    print "SKIP $key (not found)\n";
  }
}

# Now the MSE explainer pic captions: <b>01</b> · etc.
# These keep their number (small, in-card numbering), but use a dot
# icon to feel intentional rather than ad-hoc. Skip these for now;
# the user only asked about the [ NN ] eyebrows.

# Lean process step numbers: <span class="lean-step__num">01</span>
my %lean_icons = (
  '01' => '<rect x="3" y="9" width="18" height="12"/><path d="M3 9 L7 4 H17 L21 9"/><rect x="9" y="13" width="6" height="8"/>',  # factory
  '02' => '<rect x="2" y="9" width="13" height="9"/><path d="M15 12 H19 L22 15 V18 H15"/><circle cx="6" cy="20" r="2"/><circle cx="18" cy="20" r="2"/>',  # truck
  '03' => '<circle cx="9" cy="8" r="3"/><circle cx="16" cy="9" r="2.5"/><path d="M3 20 V18 C3 15 6 13 9 13 C12 13 15 15 15 18 V20"/><path d="M16 20 V18 C16 16 17 15 19 15 C20.5 15 21 16 21 18 V20"/>',  # team
);
for my $key (keys %lean_icons) {
  my $svg = qq{<span class="lean-step__icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true">$lean_icons{$key}</svg></span>};
  my $old = qq{<span class="lean-step__num">$key</span>};
  if (index($html, $old) >= 0) {
    $html =~ s/\Q$old\E/$svg/g;
    $changed++;
    print "OK   lean step $key\n";
  }
}

open(my $out, '>', $fp) or die "write: $!";
print $out $html;
close $out;
print "\nDone. $changed substitutions.\n";
