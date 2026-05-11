#!/usr/bin/env perl
# Inject (or replace) bottom-tabbar HTML in all /learn/*.html pages.
# Order matches the landing page sections top-to-bottom:
# Home -> Basics -> System -> Spec (capabilities) -> Apps -> Compare (why)
# -> Lean -> Projects -> About -> Contact -> Learn (active) -> Chat
use strict;
use warnings;

my $dir = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/learn';
my $anchor = '<script src="../js/site.js" defer></script>';

my $tabbar = <<'EOF';

<!-- Bottom tab bar, order matches landing-page sections top to bottom -->
<nav class="tabbar" aria-label="Section navigation">
  <div class="tabbar__scroll">
    <a class="tabbar__tab" href="../#hero">
      <svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true">
        <path d="M3 11 L12 3 L21 11"/><path d="M5 10 V21 H19 V10"/>
      </svg>
      <span class="tabbar__lbl">Home</span>
    </a>
    <a class="tabbar__tab" href="../#mse">
      <svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true">
        <circle cx="12" cy="12" r="9"/><path d="M12 8 V8.01" stroke-width="2.5"/><path d="M12 11 V17"/>
      </svg>
      <span class="tabbar__lbl">Basics</span>
    </a>
    <a class="tabbar__tab" href="../#system">
      <svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true">
        <rect x="4" y="4" width="7" height="7"/><rect x="13" y="4" width="7" height="7"/>
        <rect x="4" y="13" width="7" height="7"/><rect x="13" y="13" width="7" height="7"/>
      </svg>
      <span class="tabbar__lbl">System</span>
    </a>
    <a class="tabbar__tab" href="../#applications">
      <svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true">
        <path d="M12 3 L3 8 L12 13 L21 8 L12 3 Z"/>
        <path d="M3 12 L12 17 L21 12"/><path d="M3 16 L12 21 L21 16"/>
      </svg>
      <span class="tabbar__lbl">Apps</span>
    </a>
    <a class="tabbar__tab" href="../#why">
      <svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true">
        <path d="M12 3 V21"/><path d="M6 8 H18"/>
        <path d="M3 14 L6 8 L9 14 Z"/><path d="M15 14 L18 8 L21 14 Z"/>
      </svg>
      <span class="tabbar__lbl">Compare</span>
    </a>
    <a class="tabbar__tab" href="../#lean">
      <svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true">
        <path d="M13 2 L4 14 H11 L11 22 L20 10 H13 L13 2 Z"/>
      </svg>
      <span class="tabbar__lbl">Lean</span>
    </a>
    <a class="tabbar__tab" href="../#projects">
      <svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true">
        <rect x="3" y="5" width="18" height="14"/>
        <path d="M3 16 L8 11 L13 16 L17 12 L21 16"/>
        <circle cx="8" cy="9" r="1.5" fill="currentColor"/>
      </svg>
      <span class="tabbar__lbl">Projects</span>
    </a>
    <a class="tabbar__tab" href="../#about">
      <svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true">
        <circle cx="12" cy="8" r="4"/>
        <path d="M4 21 V19 C4 16 7 14 12 14 C17 14 20 16 20 19 V21"/>
      </svg>
      <span class="tabbar__lbl">About</span>
    </a>
    <a class="tabbar__tab" href="../#contact">
      <svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true">
        <rect x="3" y="6" width="18" height="13"/>
        <path d="M3 7 L12 14 L21 7"/>
      </svg>
      <span class="tabbar__lbl">Contact</span>
    </a>
    <a class="tabbar__tab is-active" href="./">
      <svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true">
        <path d="M4 4 H12 V20 H4 Z"/><path d="M12 4 H20 V20 H12 Z"/>
        <path d="M4 8 L20 8" stroke-dasharray="2 2"/>
      </svg>
      <span class="tabbar__lbl">Learn</span>
    </a>
    <a class="tabbar__tab tabbar__tab--whatsapp" href="https://wa.me/60122362159?text=Hi%20AnchorSOL%2C%20project%20enquiry%20from%20your%20website." target="_blank" rel="noopener">
      <span class="tabbar__icon-wrap">
        <span class="tabbar__pulse" aria-hidden="true"></span>
        <svg class="tabbar__icon" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
          <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413"/>
        </svg>
      </span>
      <span class="tabbar__lbl">Chat</span>
    </a>
  </div>
</nav>

EOF

opendir(my $dh, $dir) or die "cannot open $dir: $!";
my @files = sort grep { /\.html$/ } readdir($dh);
closedir($dh);

my ($touched, $missing) = (0, 0);
for my $f (@files) {
  my $fp = "$dir/$f";
  open(my $in, '<', $fp) or die "cannot read $fp: $!";
  my $html = do { local $/; <$in> };
  close($in);

  # Strip any existing tabbar block (including the leading comment line)
  $html =~ s{
    \s*<!--\s*Bottom\s*tab\s*bar[^>]*-->\s*
    <nav\s+class="tabbar".*?</nav>\s*
  }{\n}xsi;

  if (index($html, $anchor) < 0) {
    $missing++;
    print "WARN  $f (anchor not found)\n";
    next;
  }
  $html =~ s/\Q$anchor\E/$tabbar$anchor/;
  open(my $out, '>', $fp) or die "cannot write $fp: $!";
  print $out $html;
  close($out);
  $touched++;
  print "OK    $f\n";
}
print "\nDone. $touched updated, $missing missing anchor.\n";
