#!/usr/bin/env perl
# One-shot rewriter: swaps Inter/Space-Grotesk/Space-Mono fonts → Archivo+JetBrains Mono,
# replaces the legacy <header class="header">...</header> block with T1-navy top + nav,
# and replaces the legacy <footer class="footer">...</footer> block with T1-navy footer.
#
# Usage: perl tools/_t1navy_inner.pl  (run from project root)
#
use strict;
use warnings;

my $NEW_HEADER = <<'EOT';
<!-- TOP BAR -->
<div class="top"><div class="wrap"><div class="top__in">
  <span class="live">SHIPPING NOW · Q2 2026 · 9 walls in delivery across MY</span>
  <span>HQ · Shah Alam, Selangor · +603 7832 0197</span>
</div></div></div>

<!-- NAV -->
<header class="nav"><div class="wrap"><div class="nav__in">
  <a class="brand" href="index.html" aria-label="AnchorSOL Wall — Home">
    <img src="assets/images/logo-white.png" alt="" />
    <span class="wm"><span>ANCHORSOL<sup>®</sup></span><small>WALL SYSTEMS · EST. 1999</small></span>
  </a>
  <nav class="nav__links" aria-label="Primary">
    <a href="system.html">System</a>
    <a href="benefits.html">Why AnchorSOL</a>
    <a href="applications.html">Applications</a>
    <a href="projects.html">Projects</a>
    <a href="about.html">About</a>
    <a href="contact.html">Contact</a>
  </nav>
  <a class="nav__cta" href="contact.html">Get a Quote →</a>
  <button class="nav-toggle" aria-expanded="false" aria-controls="mobile-nav" aria-label="Toggle navigation">
    <span class="nav-toggle__bar"></span>
  </button>
</div></div>
<div class="mobile-nav" id="mobile-nav">
  <a href="index.html">Home</a>
  <a href="system.html">System</a>
  <a href="benefits.html">Why AnchorSOL</a>
  <a href="applications.html">Applications</a>
  <a href="projects.html">Projects</a>
  <a href="about.html">About</a>
  <a href="contact.html">Contact</a>
  <a href="contact.html" class="btn btn--p">Get a Quote →</a>
</div></header>
EOT

my $NEW_FOOTER = <<'EOT';
<footer><div class="wrap">
  <div class="grid">
    <div>
      <h4>AnchorSOL® Wall</h4>
      <p>Malaysia's most-specified anchored MSE wall system. 25 years. 300+ walls.</p>
    </div>
    <div>
      <h4>System</h4>
      <ul>
        <li><a href="system.html">The System</a></li>
        <li><a href="benefits.html">Why AnchorSOL</a></li>
        <li><a href="applications.html">Applications</a></li>
        <li><a href="help-resources.html">Spec sheets (PDF)</a></li>
      </ul>
    </div>
    <div>
      <h4>Company</h4>
      <ul>
        <li><a href="about.html">About</a></li>
        <li><a href="projects.html">Projects</a></li>
        <li><a href="help-resources.html">Engineering Notes</a></li>
        <li><a href="contact.html">Contact</a></li>
      </ul>
    </div>
    <div>
      <h4>HQ · Malaysia</h4>
      <p class="b">AnchorSOL® Wall Sdn. Bhd.<br />C27-1 Plaza Jelutong, Bukit Jelutong<br />Shah Alam, Selangor 40150</p>
      <p>Tel · <a href="tel:+60378320197">+603-7832 0197</a><br />
      Mobile · <a href="tel:+60122362159">+6012-236 2159</a><br />
      <a href="mailto:enquiry@anchorsolwall.com">enquiry@anchorsolwall.com</a></p>
      <p style="margin-top:14px; font-size:11px; opacity:.55;">Bangladesh agent · <a href="https://anchorsoilbd.com">anchorsoilbd.com</a></p>
    </div>
  </div>
  <div class="bottom">
    <span>© 2026 AnchorSOL® Wall Sdn. Bhd. · 199901015121 (490021-M)</span>
    <span>ENGINEERED TO RETAIN — EARTH, SCHEDULE, SCOPE.</span>
  </div>
</div></footer>
EOT

my @files = qw(
  about.html focus.html system.html benefits.html
  applications.html projects.html help-resources.html contact.html
);

my $base = "site/";
for my $f (@files) {
  my $path = $base . $f;
  open(my $fh, '<', $path) or die "open $path: $!";
  local $/;
  my $html = <$fh>;
  close($fh);
  my $orig = $html;

  # 1. Swap Google Fonts URL — Inter + Space Grotesk + Space Mono → Archivo + JetBrains Mono
  $html =~ s|family=Inter:wght\@400;500;600;700&family=Space\+Grotesk:wght\@500;600;700&family=Space\+Mono:wght\@400;700&display=swap|family=Archivo:wght\@400;500;600;700;800;900\&family=JetBrains+Mono:wght\@400;500;700\&display=swap|g;

  # 2. Replace legacy <header class="header"> ... </header> with T1-navy top + nav
  $html =~ s{<header class="header">.*?</header>}{$NEW_HEADER}s;

  # 3. Replace legacy <footer class="footer"> ... </footer> with T1-navy footer
  $html =~ s{<footer class="footer">.*?</footer>}{$NEW_FOOTER}s;

  if ($html ne $orig) {
    open(my $out, '>', $path) or die "write $path: $!";
    print $out $html;
    close($out);
    print "  UPDATED  $f\n";
  } else {
    print "  unchanged $f\n";
  }
}
