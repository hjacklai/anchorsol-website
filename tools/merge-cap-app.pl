#!/usr/bin/env perl
# Replace the standalone Capabilities + Applications sections with a single
# unified "Use Cases" section. Each card pairs a constraint question (eyebrow)
# with an application segment (title) + photo + chip-row of key proof points.
use strict;
use warnings;

my $fp = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/index.html';

my $new_section = <<'EOF';

<!-- [01b] APPLICATIONS, merged section: constraint Q + segment + proof in one card -->
<section id="applications" class="usecases"><div class="wrap">
  <div class="secmark"><span class="secmark__icon"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true"><path d="M12 3 L3 8 L12 13 L21 8 L12 3 Z"/><path d="M3 12 L12 17 L21 12"/><path d="M3 16 L12 21 L21 16"/></svg></span><span>Applications</span><span class="rule"></span><span>Six segments, six constraints</span></div>
  <div class="sechead">
    <h2>You bring the constraint. <span class="hi">We bring the wall.</span></h2>
    <p>Six segments. Each pairs a real-world brief with the engineering AnchorSOL answers it with.</p>
  </div>

  <div class="usecases-grid">

    <article class="usecase">
      <div class="usecase__media"><img src="assets/images/RoadEmbmt-11.jpg" alt="AnchorSOL wall on a federal highway embankment" loading="lazy" width="800" height="533" /></div>
      <div class="usecase__body">
        <span class="usecase__eyebrow">Long-run linear retention at scale?</span>
        <h3 class="usecase__title">Highway Embankments</h3>
        <p>NKVE, federal &amp; state roads. Up to 30 m height. Side-hill cuts, abutments, ramp walls.</p>
        <div class="usecase__chips">
          <span class="chip">NKVE</span><span class="chip">JKR</span><span class="chip chip--accent">Up to 30 m</span>
        </div>
      </div>
    </article>

    <article class="usecase">
      <div class="usecase__media"><img src="assets/images/BridgeAbmt-04-2.jpg" alt="AnchorSOL bridge abutment wall with inverted-T precast facing" loading="lazy" width="800" height="533" /></div>
      <div class="usecase__body">
        <span class="usecase__eyebrow">Structural transition at the deck?</span>
        <h3 class="usecase__title">Bridge Abutments</h3>
        <p>Inverted-T precast with integral ground beam. Tight tolerance at the bearing line, no formwork around the bridge.</p>
        <div class="usecase__chips">
          <span class="chip">Inverted-T</span><span class="chip">Grade 30 MPa</span><span class="chip chip--accent">Galvanised tendon</span>
        </div>
      </div>
    </article>

    <article class="usecase">
      <div class="usecase__media"><img src="assets/images/HillWall-2.jpg" alt="AnchorSOL wall stabilising a sloped hillside, creating a buildable platform" loading="lazy" width="800" height="533" /></div>
      <div class="usecase__body">
        <span class="usecase__eyebrow">Sloped hillside, no flat ground?</span>
        <h3 class="usecase__title">Hill Stabilisation</h3>
        <p>Cut once, retain, build on top. Templer Hills, Cheras, Kajang. Platform creation on sloped terrain.</p>
        <div class="usecase__chips">
          <span class="chip">Platform creation</span><span class="chip">Stepped</span><span class="chip chip--accent">Soft ground OK</span>
        </div>
      </div>
    </article>

    <article class="usecase">
      <div class="usecase__media"><img src="assets/images/Submerged-04.jpg" alt="AnchorSOL wall at a riverbank with marine retention" loading="lazy" width="800" height="533" /></div>
      <div class="usecase__body">
        <span class="usecase__eyebrow">Building next to water?</span>
        <h3 class="usecase__title">Submerged &amp; Marine</h3>
        <p>Tide-line retention, riverbank, drainage and culvert headwalls. Galvanised tendon survives the wet.</p>
        <div class="usecase__chips">
          <span class="chip">Tide-line</span><span class="chip">Riverbank</span><span class="chip chip--accent">Hot-dip galvanised</span>
        </div>
      </div>
    </article>

    <article class="usecase">
      <div class="usecase__media"><img src="assets/images/proj_ktm_sungai_buaya.jpg" alt="AnchorSOL wall under KTMB rail corridor" loading="lazy" width="800" height="533" /></div>
      <div class="usecase__body">
        <span class="usecase__eyebrow">Cyclic + seismic loads to design for?</span>
        <h3 class="usecase__title">Under-Railway &amp; Heavy Civils</h3>
        <p>Composite mass yields elastically and recovers. Used under KTMB rail and ADB-financed cross-border roads.</p>
        <div class="usecase__chips">
          <span class="chip">KTMB</span><span class="chip">Cyclic load</span><span class="chip chip--accent">Seismic capable</span>
        </div>
      </div>
    </article>

    <article class="usecase">
      <div class="usecase__media"><img src="assets/images/RetainingWall-18.jpg" alt="AnchorSOL wall with architectural finish and custom logo cast into precast panel" loading="lazy" width="800" height="533" /></div>
      <div class="usecase__body">
        <span class="usecase__eyebrow">Architect needs a finish?</span>
        <h3 class="usecase__title">Architectural &amp; Custom</h3>
        <p>Custom textures, custom logos cast directly into the panel. Curved, fully circular, terraced. Any alignment.</p>
        <div class="usecase__chips">
          <span class="chip">Custom logo cast</span><span class="chip">Curved</span><span class="chip chip--accent">Any geometry</span>
        </div>
      </div>
    </article>

  </div>

  <p class="caps-cta-line">
    <span class="tech-label">[ Different constraint? ]</span>
    Probably still possible. 500+ briefs delivered since 1999.
    <a class="btn btn--p caps-cta-btn" href="https://wa.me/60122362159?text=Hi%20AnchorSOL%2C%20I%20have%20a%20wall%20brief%20with%20a%20specific%20constraint." target="_blank" rel="noopener">Send your brief &rarr;</a>
  </p>

</div></section>
EOF

open(my $in, '<', $fp) or die "open: $!";
my $html = do { local $/; <$in> };
close $in;

# Match the entire Capabilities section + the Applications section + their
# comment headers and any whitespace between them. Replace with the merged
# section.
my $pattern = qr{
  \s*<!--\s*\[\s*01b\s*\][^>]*-->\s*
  <section\s+id="capabilities".*?</section>\s*
  <!--\s*\[\s*01c\s*\][^>]*-->\s*
  <section\s+id="applications".*?</section>
}xs;

if ($html =~ $pattern) {
  $html =~ s/$pattern/$new_section/;
  open(my $out, '>', $fp) or die "write: $!";
  print $out $html;
  close $out;
  print "OK: merged Capabilities + Applications into one unified section.\n";
} else {
  print "FAIL: pattern not matched.\n";
  exit 1;
}
