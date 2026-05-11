#!/usr/bin/env perl
# One-time cleanup: strip the hamburger button, the nav__cta link, and
# the legacy mobile-nav overlay from every learn page. Bottom tab bar
# handles all navigation now.
use strict;
use warnings;

my $dir = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/learn';
opendir(my $dh, $dir) or die "cannot open $dir: $!";
my @files = map { "$dir/$_" } sort grep { /\.html$/ } readdir($dh);
closedir($dh);

for my $fp (@files) {
  open(my $in, '<', $fp) or die "cannot read $fp: $!";
  my $html = do { local $/; <$in> };
  close($in);
  my $orig = $html;

  # Remove the nav__cta line (CTA button right after </nav>)
  $html =~ s|^\s*<a class="nav__cta"[^<]*</a>\s*\n||mig;

  # Remove the hamburger button (3 lines)
  $html =~ s|^\s*<button class="nav-toggle"[^>]*>\s*\n\s*<span class="nav-toggle__bar"></span>\s*\n\s*</button>\s*\n||mig;

  # Remove the entire <div class="mobile-nav">...</div> block (multiline)
  $html =~ s|<div class="mobile-nav"\b.*?</div>\s*</header>|</header>|si;

  if ($html ne $orig) {
    open(my $out, '>', $fp) or die "cannot write $fp: $!";
    print $out $html;
    close($out);
    my $name = $fp; $name =~ s|.*/||;
    print "OK    $name\n";
  } else {
    my $name = $fp; $name =~ s|.*/||;
    print "SKIP  $name (no changes)\n";
  }
}
