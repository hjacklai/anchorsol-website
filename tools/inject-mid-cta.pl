#!/usr/bin/env perl
# Inject a mid-page CTA block after the middle </section> tag in
# article-style pages (learn/*, applications/, locations/*, contractor/).
use strict;
use warnings;
use File::Find;

my $CTA = <<'HTML';

<div class="article-cta">
  <p class="article-cta__lead">Building a wall? Talk to us.</p>
  <p>500+ named projects since 1999. Anchored MSE, RE, RS, RC retaining walls. Specified by JKR, PLUS, KTMB, LLM.</p>
  <div class="article-cta__btns">
    <a href="https://wa.me/60122362159?text=Hi%20AnchorSOL%2C%20I%27d%20like%20to%20discuss%20a%20wall%20project." class="btn btn--p" target="_blank" rel="noopener">WhatsApp →</a>
    <a href="https://anchorsolwall.com/#contact" class="btn btn--g">Discuss your project →</a>
  </div>
</div>

HTML

my @files;
find(sub {
  return unless /\.html$/i;
  my $p = $File::Find::name;
  # Target only article-style pages
  return unless $p =~ m{site/(learn|applications|locations|contractor)/};
  return if $p =~ m{site/learn/index\.html$};   # hub page, has card grid not article body
  push @files, $p;
}, 'site');

my $injected = 0;
for my $file (@files) {
  open my $in, '<:raw', $file or die "open $file: $!";
  my $content = do { local $/; <$in> };
  close $in;

  # Skip if already has the CTA
  if ($content =~ /class="article-cta"/) {
    print "SKIP (already injected): $file\n";
    next;
  }

  # Find article body region: between <header class="article__head"> end and
  # <aside class="article__related"> start (or end of <article>)
  my @section_close_positions;
  while ($content =~ m{</section>}g) {
    push @section_close_positions, pos($content);
  }
  unless (@section_close_positions >= 2) {
    print "SKIP (too few sections): $file (" . scalar(@section_close_positions) . ")\n";
    next;
  }

  # Pick the middle </section> close position
  my $mid_idx = int($#section_close_positions / 2);
  my $insert_at = $section_close_positions[$mid_idx];

  # Insert CTA right after that </section>
  my $new = substr($content, 0, $insert_at) . $CTA . substr($content, $insert_at);

  open my $out, '>:raw', $file or die "write $file: $!";
  print $out $new;
  close $out;
  $injected++;
  print "OK: $file (after section #" . ($mid_idx + 1) . " of " . scalar(@section_close_positions) . ")\n";
}

print "\nInjected CTA into $injected files\n";
