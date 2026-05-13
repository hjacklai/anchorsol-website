#!/usr/bin/env perl
# Generate 16 dedicated state pages, one per Malaysian state + federal territory.
# Each page targets all wall-type variant queries:
#   - "MSE wall [state]"
#   - "Mechanically Stabilized Earth wall [state]"
#   - "Anchored MSE wall [state]"
#   - "RE wall [state]" / "Reinforced Earth wall [state]"
#   - "RS wall [state]" / "Reinforced Soil wall [state]"
#   - "RC retaining wall [state]" / "Reinforced Concrete retaining wall [state]"
#   - "Retaining wall contractor [state]"
#   - "Retaining wall [state]"
#   - Plus all major cities within that state
#
# Output: site/locations/{slug}/index.html
use strict;
use warnings;
use File::Path qw(make_path);

my $out_dir = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/locations';

# State data: slug, name, type, major cities, marquee projects, content notes
my @states = (
  {
    slug => 'selangor',
    name => 'Selangor',
    type => 'state',
    cities => 'Shah Alam, Petaling Jaya, Subang Jaya, Klang, Cheras, Kajang, Semenyih, Sungai Buloh, Bukit Jelutong, Damansara, Rawang, Selayang, Hulu Selangor, Bukit Antarabangsa, Bandar Saujana Putra, Bandar Utama, Sepang, Ulu Klang',
    capital => 'Shah Alam',
    context => "Selangor is the densest infrastructure market in Malaysia and the centre of AnchorSOL's delivered portfolio. The company's headquarters sit in Bukit Jelutong, Shah Alam, with precast manufacturing on-site. Major project categories: Klang Valley expressways (NKVE, DUKE, SUKE, EKVE), township developments across Cheras, Kajang, Semenyih, Subang and Sungai Buloh, hillside stabilization across Templer Hills and Bukit Antarabangsa, federal government compounds, industrial business parks.",
    projects => '<li><b>East Klang Valley Expressway (EKVE)</b>, LLM concession, 25,000 m² of anchored MSE wall</li><li><b>NKVE Jalan Meru Link</b>, PLUS Expressways, 11,000 m²</li><li><b>Elmina Business Park 2 Phase 4B</b>, Sime Darby Property, 12,452 m²</li><li><b>Mixed Development Semenyih</b>, Duta Villa, 12,000 m²</li><li><b>Templer Hills</b> hillside stabilization, residential platform</li><li><b>Bukit Antarabangsa</b> hillside retention, post-landslide context</li>',
    notes => 'Selangor is also home to the highest density of JKR federal-road retaining works in the country. Every major expressway interchange in the Klang Valley has AnchorSOL® walls somewhere in its alignment.',
  },
  {
    slug => 'kuala-lumpur',
    name => 'Kuala Lumpur',
    type => 'federal territory',
    cities => 'Cheras, Wangsa Maju, Ampang, Bangsar, Damansara Heights, Mont Kiara, Setiawangsa, KL Sentral, Pantai, Jalan Duta, Sungai Besi, Brickfields, Sentul, Titiwangsa, Bukit Bintang',
    capital => 'Kuala Lumpur',
    context => "Kuala Lumpur is the densest infrastructure market in Malaysia by project value. Federal Territory walls span urban expressway interchanges (DUKE, SUKE, Setiawangsa-Pantai), sub-track rail embankments on KTMB corridors, national-monument compounds (Istana Negara), drainage and flood works on the Klang and Gombak river systems, plus mixed-development boundary walls in high-rise corridors.",
    projects => '<li><b>Duta-Ulu Klang Expressway (DUKE) Phase 2</b>, Ekovest / LLM, 22,000 m²</li><li><b>Sungai Besi-Ulu Kelang Expressway (SUKE) Package CA1</b>, Prolintas, 22,000 m²</li><li><b>Setiawangsa-Pantai Expressway (DUKE Phase 3)</b>, LLM / Ekovest, 8,200 m²</li><li><b>Istana Negara Jalan Duta</b>, the National Palace, JKR, 8,000 m²</li><li><b>KL-Putrajaya Highway Packages 3 & 4</b>, LLM / Maju Holdings, 8,000 m²</li>',
    notes => 'KL projects often have the most demanding architectural requirements. Multiple AnchorSOL® walls in the city feature cast-in textures, custom logos, and project-specific finishes for prestige and heritage contexts.',
  },
  {
    slug => 'putrajaya',
    name => 'Putrajaya',
    type => 'federal territory',
    cities => 'Precinct 1, Precinct 11, Precinct 14, Precinct 18, Precinct 9, Putrajaya Sentral area, Government Quarters, Diplomatic enclave',
    capital => 'Putrajaya',
    context => "Putrajaya is Malaysia's federal administrative capital, a planned city built from the 1990s onwards. AnchorSOL® has delivered MSE walls across multiple Putrajaya Holdings precincts including the boundary and retention pond walls on Precinct 11, plus the highway connections feeding the city (KL-Putrajaya Highway Packages 3 & 4).",
    projects => '<li><b>Putrajaya Holdings Precinct 11</b>, Putrajaya Holdings, 10,000 m²</li><li><b>KL-Putrajaya Highway approaches</b>, LLM / Maju Holdings, 8,000 m² across Packages 3 and 4</li><li>Precinct boundary and retention pond walls across central Putrajaya</li>',
    notes => 'Putrajaya walls typically combine engineered retention with architectural finish to suit the city\'s civic-monumental aesthetic.',
  },
  {
    slug => 'johor',
    name => 'Johor',
    type => 'state',
    cities => 'Johor Bahru, Iskandar Puteri, Nusajaya, Pasir Gudang, Senai, Kulai, Batu Pahat, Pontian, Kluang, Muar, Mersing, Segamat, Tangkak, Kota Tinggi',
    capital => 'Johor Bahru',
    context => "Johor's marquee programme on the AnchorSOL® book is the Iskandar Regional Development Authority coastal corridor between Johor Bahru and Nusajaya. Marine retention, reclamation walls, township boundary walls, and federal-road retaining works across southern Johor.",
    projects => '<li><b>Lebuhraya Pesisiran Pantai JB-Nusajaya, Section 3</b>, Iskandar Regional Development Authority, 23,000 m²</li><li>Coastal reclamation walls along the JB-Nusajaya corridor</li><li>Township boundary walls in Iskandar Puteri, Pasir Gudang, Senai, Kulai approach roads</li><li>Federal-road retaining works in Batu Pahat, Pontian, Kluang corridors</li>',
    notes => 'Johor coastal projects require marine-grade durability spec including thicker galvanizing on tendons and Grade 40 concrete on facing panels for splash-zone exposure.',
  },
  {
    slug => 'pahang',
    name => 'Pahang',
    type => 'state',
    cities => 'Kuantan, Pekan, Temerloh, Bentong, Raub, Maran, Jerantut, Rompin, Bera, Lipis, Cameron Highlands',
    capital => 'Kuantan',
    context => "Pahang is Malaysia's largest state on the Peninsular and AnchorSOL®'s marquee Pahang programme is Kuantan Port City reclamation and waterfront retention. Port retaining structures, marine-spec walls, East Coast Economic Region Development (ECERD) infrastructure across the Kuantan corridor, plus federal-road retaining walls on the East Coast Highway and Karak Highway approaches.",
    projects => '<li><b>Kuantan Port City</b>, East Coast Economic Region Development (ECERD), 14,500 m²</li><li>Sungai Pahang flood-mitigation walls (JPS)</li><li>Federal-road retaining walls on the East Coast Highway and Karak Highway approaches</li>',
    notes => 'Pahang coastal works at Kuantan use marine-spec durability. Inland projects on the Karak Highway use standard inland spec.',
  },
  {
    slug => 'perak',
    name => 'Perak',
    type => 'state',
    cities => 'Ipoh, Taiping, Manjung (Lumut), Kampar, Bidor, Tapah, Sungai Siput, Kuala Kangsar, Bagan Datuk, Pangkor, Teluk Intan, Parit Buntar',
    capital => 'Ipoh',
    context => "Perak hosts federal-road and JKR retaining works on the North-South Expressway corridor, plus state-road and township developments across Ipoh, Taiping and Manjung. The Sultan Iskandar interchange in Ipoh is one of several Ipoh-area projects on the AnchorSOL® book.",
    projects => '<li><b>Sultan Iskandar interchange</b>, Ipoh</li><li><b>JKR Bandar Sri Iskandar</b> federal-road retaining wall</li><li>State-road retaining works across Taiping, Manjung and Kampar approach roads</li>',
    notes => 'Perak limestone and granite quarries supply much of the crusher run used on Klang Valley AnchorSOL® projects.',
  },
  {
    slug => 'penang',
    name => 'Penang',
    type => 'state',
    cities => 'George Town, Bayan Lepas, Butterworth, Bukit Mertajam, Air Itam, Tanjung Bungah, Tanjung Tokong, Nibong Tebal, Sungai Petani approach roads, Balik Pulau',
    capital => 'George Town',
    context => "Penang's hilly terrain makes the state a natural fit for anchored MSE walls. Hillside stabilization across the Penang Island ridge, township retaining walls on the mainland Seberang Perai, and federal-road approaches on the North-South Expressway corridor.",
    projects => '<li>Penang Island hill stabilisation around George Town, Air Itam and Tanjung Bungah</li><li>Seberang Perai township boundary walls around Bukit Mertajam and Butterworth</li><li>Federal road retaining works in Nibong Tebal and Balik Pulau corridor</li>',
    notes => 'Penang hillside projects often face the most challenging access constraints, where the 3-4 person AnchorSOL® crew + modular precast components win against heavier alternatives.',
  },
  {
    slug => 'kedah',
    name => 'Kedah',
    type => 'state',
    cities => 'Alor Setar, Sungai Petani, Kulim, Pendang, Langkawi, Anak Bukit, Baling, Sik, Yan, Pokok Sena, Padang Terap',
    capital => 'Alor Setar',
    context => "Kedah hosts AnchorSOL®'s flagship JPS flood-mitigation programme: the Sungai Kedah / Anak Bukit works, 15,000 m² of riverine retention completed for the Department of Drainage and Irrigation. Plus federal-road retaining works across Alor Setar, Sungai Petani and Pendang.",
    projects => '<li><b>Sungai Kedah / Anak Bukit Flood Mitigation</b>, JPS Malaysia, 15,000 m²</li><li>Federal-road retaining works across Alor Setar, Sungai Petani and Pendang</li><li>State-road retention in Baling and Pendang district</li>',
    notes => 'Kedah riverine works require submergence-tolerant durability spec on tendons and concrete panels.',
  },
  {
    slug => 'negeri-sembilan',
    name => 'Negeri Sembilan',
    type => 'state',
    cities => 'Seremban, Port Dickson, Nilai, Senawang, Bahau, Tampin, Rembau, Kuala Pilah, Jelebu',
    capital => 'Seremban',
    context => "Negeri Sembilan hosts JKR federal-road retaining works on the Seremban corridor. The Jalan Lingkaran Tengah Seremban programme, Phase 2A, contributes 15,000 m² to the AnchorSOL® book in this state. Industrial estate walls in Senawang and Nilai, plus township developments around Port Dickson.",
    projects => '<li><b>Jalan Lingkaran Tengah Seremban, Phase 2A</b>, JKR, 15,000 m²</li><li>Industrial estate retaining walls in Senawang and Nilai</li><li>Township developments around Port Dickson and Seremban</li>',
    notes => 'Negeri Sembilan is a logistics + manufacturing corridor; many walls support industrial-platform creation on cut-and-fill geometry.',
  },
  {
    slug => 'melaka',
    name => 'Melaka',
    type => 'state',
    cities => 'Melaka Tengah, Alor Gajah, Jasin, Ayer Keroh, Bandar Hilir, Klebang, Pulau Sebang',
    capital => 'Melaka',
    context => "Melaka projects include federal-road retaining works on the North-South Expressway corridor, heritage-context retention near the city centre, and township boundary walls on Melaka Tengah and Alor Gajah approach roads.",
    projects => '<li>Federal-road retaining works on the NSE Melaka section</li><li>Township boundary walls on Melaka Tengah and Alor Gajah approach roads</li><li>Heritage-context retention near the George Town UNESCO buffer zone</li>',
    notes => 'Melaka heritage sites occasionally call for crib walls or gravity walls in stone masonry for architectural conservation; we specify these where appropriate.',
  },
  {
    slug => 'terengganu',
    name => 'Terengganu',
    type => 'state',
    cities => 'Kuala Terengganu, Kemaman, Dungun, Marang, Kuala Berang, Hulu Terengganu, Setiu, Besut',
    capital => 'Kuala Terengganu',
    context => "Terengganu projects include East Coast Highway federal-road retaining works, coastal retention walls along the Kuala Terengganu and Kuala Berang approach roads, and Sungai Terengganu flood-mitigation works in collaboration with JPS.",
    projects => '<li>East Coast Highway federal-road retaining works</li><li>Coastal retention walls along Kuala Terengganu and Kuala Berang approach roads</li><li>Sungai Terengganu flood-mitigation works in collaboration with JPS</li>',
    notes => 'Terengganu coastal projects use marine durability spec; inland walls use standard JKR spec.',
  },
  {
    slug => 'kelantan',
    name => 'Kelantan',
    type => 'state',
    cities => 'Kota Bharu, Pasir Mas, Tumpat, Tanah Merah, Gua Musang, Bachok, Pasir Puteh, Kuala Krai',
    capital => 'Kota Bharu',
    context => "Kelantan projects include federal-road retaining works on the East-West Highway corridor (Gerik to Jeli to Kota Bharu), Sungai Kelantan flood-mitigation walls, and JKR state-road retaining works around Kota Bharu and Pasir Mas.",
    projects => '<li>East-West Highway federal-road retaining works (Gerik to Jeli to Kota Bharu)</li><li>Sungai Kelantan flood-mitigation walls (JPS)</li><li>JKR state-road retaining works around Kota Bharu and Pasir Mas</li>',
    notes => 'Kelantan flood-mitigation works are critical given the recurring monsoon flooding; durability and drainage design are project-critical.',
  },
  {
    slug => 'perlis',
    name => 'Perlis',
    type => 'state',
    cities => 'Kangar, Padang Besar, Arau, Beseri, Simpang Ampat, Sanglang',
    capital => 'Kangar',
    context => "Perlis is Malaysia's smallest state by area. AnchorSOL®'s footprint here is concentrated on federal-road retaining works around Kangar, the state capital, plus drainage and irrigation works for JPS Perlis on the Sungai Perlis and Sungai Korok systems.",
    projects => '<li>Federal-road retaining works around Kangar</li><li>JPS Perlis drainage and irrigation works on Sungai Perlis and Sungai Korok systems</li>',
    notes => 'Small state but well-connected to Klang Valley manufacturing; precast deliveries by road are straightforward.',
  },
  {
    slug => 'sabah',
    name => 'Sabah',
    type => 'state',
    cities => 'Kota Kinabalu, Sandakan, Tawau, Lahad Datu, Keningau, Tenom, Beaufort, Papar, Kudat, Semporna, Kinabatangan, Kunak',
    capital => 'Kota Kinabalu',
    context => "Sabah's challenging terrain, fault-influenced geology, and high-rainfall regime make anchored MSE the right call for hill stabilisation, riverbank retention, and federal-road retaining works. AnchorSOL® delivers Sabah projects via container freight to Kota Kinabalu, Sandakan and Tawau, with the local crew trained for East Malaysia mobilisation.",
    projects => '<li>Kota Kinabalu hill stabilisation projects</li><li>Sandakan federal-road retention works</li><li>JKR Sabah road network retaining structures</li><li>Tawau coastal and port infrastructure walls</li>',
    notes => 'Sabah seismic design uses elevated horizontal coefficient (0.10 to 0.15) versus peninsular Malaysia. The composite soil-steel mass of anchored MSE yields elastically through seismic events, recovering with no permanent damage, where rigid RC cantilever would crack.',
  },
  {
    slug => 'sarawak',
    name => 'Sarawak',
    type => 'state',
    cities => 'Kuching, Sibu, Miri, Bintulu, Sri Aman, Sarikei, Limbang, Mukah, Lawas, Kota Samarahan, Serian',
    capital => 'Kuching',
    context => "Sarawak is Malaysia's largest state by area. AnchorSOL® projects here run on the Pan Borneo Highway corridor and on state-government and federal-road retaining works around Kuching, Sibu, Miri and Bintulu. Container delivery from Selangor to East Malaysia ports puts Sarawak within the AnchorSOL® mobilisation footprint.",
    projects => '<li><b>Pan Borneo Highway (Sarawak section)</b> retaining works</li><li>Kuching, Sibu, Miri and Bintulu federal-road retention</li><li>JKR Sarawak state-network retaining structures</li><li>Petronas LNG and oil-and-gas infrastructure walls in Bintulu</li>',
    notes => 'Sarawak\'s long road network and challenging riverine geography (Rajang, Lupar, Saribas, Limbang river systems) make MSE walls the cost-effective choice over RC at the heights involved.',
  },
  {
    slug => 'labuan',
    name => 'Labuan',
    type => 'federal territory',
    cities => 'Victoria, Labuan town, Patau-Patau, Kerupang',
    capital => 'Victoria',
    context => "Labuan, the federal island territory off the Sabah coast, hosts coastal infrastructure and federal-territory road retaining works. AnchorSOL® delivers Labuan projects via container freight from Selangor.",
    projects => '<li>Coastal infrastructure retention walls</li><li>Federal-territory road retaining works</li>',
    notes => 'Labuan projects use marine durability spec given the island location.',
  },
);

# Standard footer + tabbar HTML (used for all state pages)
sub footer_and_tabbar {
  return <<'FOOTER';

<footer><div class="wrap">
  <div class="grid">
    <div>
      <a class="footer-logo" href="../../">
        <img src="../../assets/images/logo-white.png" alt="" data-no-picture decoding="async">
        <span class="footer-logo__wm"><span>ANCHORSOL<sup>®</sup></span><small>WALL SYSTEMS · EST. 1999</small></span>
      </a>
      <p style="color:var(--mut); font-size:14px; line-height:1.6; max-width:48ch;">Malaysia's most-specified anchored MSE wall contractor. Modular precast, factory-built, mobilised lean. Since 1999.</p>
    </div>
    <div>
      <h4>System</h4>
      <ul>
        <li><a href="../../#system">The System</a></li>
        <li><a href="../../applications/">Applications</a></li>
        <li><a href="../../projects/">All projects</a></li>
        <li><a href="../">All locations</a></li>
      </ul>
    </div>
    <div>
      <h4>Company</h4>
      <ul>
        <li><a href="../../#about">About</a></li>
        <li><a href="../../contractor/">Contractor reference</a></li>
        <li><a href="../../learn/">Knowledge Base</a></li>
        <li><a href="../../#contact">Contact</a></li>
      </ul>
    </div>
  </div>
  <div class="bottom">
    <span>© 2026 AnchorSOL® Wall Sdn. Bhd. · 199901015121 (490021-M)</span>
    <span>ENGINEERED TO RETAIN EARTH.</span>
  </div>
</div></footer>

<nav class="tabbar" aria-label="Section navigation">
  <div class="tabbar__scroll">
    <a class="tabbar__tab" href="../../#hero"><svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true"><path d="M3 11 L12 3 L21 11"/><path d="M5 10 V21 H19 V10"/></svg><span class="tabbar__lbl">Home</span></a>
    <a class="tabbar__tab" href="../../#mse"><svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 8 V8.01" stroke-width="2.5"/><path d="M12 11 V17"/></svg><span class="tabbar__lbl">Basics</span></a>
    <a class="tabbar__tab" href="../../#system"><svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true"><rect x="4" y="4" width="7" height="7"/><rect x="13" y="4" width="7" height="7"/><rect x="4" y="13" width="7" height="7"/><rect x="13" y="13" width="7" height="7"/></svg><span class="tabbar__lbl">System</span></a>
    <a class="tabbar__tab" href="../../applications/"><svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true"><path d="M12 3 L3 8 L12 13 L21 8 L12 3 Z"/><path d="M3 12 L12 17 L21 12"/><path d="M3 16 L12 21 L21 16"/></svg><span class="tabbar__lbl">Apps</span></a>
    <a class="tabbar__tab" href="../../#compare"><svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true"><path d="M12 3 V21"/><path d="M6 8 H18"/><path d="M3 14 L6 8 L9 14 Z"/><path d="M15 14 L18 8 L21 14 Z"/></svg><span class="tabbar__lbl">Compare</span></a>
    <a class="tabbar__tab" href="../../projects/"><svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true"><rect x="3" y="5" width="18" height="14"/><path d="M3 16 L8 11 L13 16 L17 12 L21 16"/><circle cx="8" cy="9" r="1.5" fill="currentColor"/></svg><span class="tabbar__lbl">Projects</span></a>
    <a class="tabbar__tab" href="../../#about"><svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true"><circle cx="12" cy="8" r="4"/><path d="M4 21 V19 C4 16 7 14 12 14 C17 14 20 16 20 19 V21"/></svg><span class="tabbar__lbl">About</span></a>
    <a class="tabbar__tab" href="../../#contact"><svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true"><rect x="3" y="6" width="18" height="13"/><path d="M3 7 L12 14 L21 7"/></svg><span class="tabbar__lbl">Contact</span></a>
    <a class="tabbar__tab" href="../../learn/"><svg class="tabbar__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="square" stroke-linejoin="miter" aria-hidden="true"><path d="M4 4 H12 V20 H4 Z"/><path d="M12 4 H20 V20 H12 Z"/><path d="M4 8 L20 8" stroke-dasharray="2 2"/></svg><span class="tabbar__lbl">Learn</span></a>
    <a class="tabbar__tab tabbar__tab--whatsapp" href="https://wa.me/60122362159?text=Hi%20AnchorSOL%2C%20enquiry%20from%20your%20location%20page." target="_blank" rel="noopener"><span class="tabbar__icon-wrap"><span class="tabbar__pulse" aria-hidden="true"></span><svg class="tabbar__icon" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413"/></svg></span><span class="tabbar__lbl">Chat</span></a>
  </div>
</nav>

<script src="../../js/site.js" defer></script>
</body>
</html>
FOOTER
}

# Generate one HTML page for one state
sub generate_page {
  my ($s) = @_;
  my $url = "https://anchorsolwall.com/locations/$s->{slug}/";
  my $name = $s->{name};
  my $type = $s->{type};
  my $cap = $s->{capital};
  my $is_ft = ($type eq 'federal territory');

  # Title: "MSE Wall {state} | RE / RS / RC Retaining Wall Contractor {state} | AnchorSOL"
  my $title = "MSE Wall $name | RE / RS / RC Retaining Wall Contractor $name | AnchorSOL®";
  my $desc = "MSE wall in $name. Anchored MSE, Reinforced Earth (RE) wall, Reinforced Soil (RS) wall, RC retaining wall contractor serving $name. 500+ projects since 1999. JKR, PLUS, LLM, KTMB specified.";

  # Keywords (many variants)
  my $kw = join(', ',
    "MSE wall $name",
    "MSE wall contractor $name",
    "Mechanically Stabilized Earth wall $name",
    "Anchored MSE wall $name",
    "RE wall $name",
    "Reinforced Earth wall $name",
    "RS wall $name",
    "Reinforced Soil wall $name",
    "RC wall $name",
    "RC retaining wall $name",
    "Reinforced concrete retaining wall $name",
    "Retaining wall $name",
    "Retaining wall contractor $name",
    "Hillside retaining wall $name",
    "Slope retaining wall $name",
    "Bridge abutment $name",
    "$name retaining wall",
    "AnchorSOL $name",
    "MSE wall $cap",
    "Retaining wall $cap",
  );

  my $h1 = "MSE wall in $name: every retaining wall type, every major city.";

  my $lede = qq|<p class="article__lede">If you need a retaining wall in <b>$name</b>, this page is the brief. AnchorSOL\xC2\xAE has delivered MSE walls, Reinforced Earth (RE) walls, Reinforced Soil (RS) walls, and consulted on RC retaining walls across this $type for over two decades. $s->{context}</p>|;

  # FAQs
  my $faq1q = "Does AnchorSOL serve $name?";
  my $faq1a = "Yes. AnchorSOL\xC2\xAE has delivered MSE walls, RE walls, RS walls, and RC retaining wall consultation projects across $name for over two decades, including " . substr($s->{context}, 0, 250) . "...";
  $faq1a =~ s/"/\\"/g;
  $faq1a =~ s/\\/\\\\/g;

  my $faq2q = "Which wall types do you build in $name?";
  my $faq2a = "All standard retaining wall systems: anchored MSE walls (our specialty, AnchorSOL system), Reinforced Earth walls (RE), Reinforced Soil walls (RS) including geogrid-reinforced variants, RC retaining walls (cantilever, gravity, counterfort) for short walls, plus crib walls and gabion walls where the application suits. For $name specifically, the dominant application is " . ($is_ft ? "urban infrastructure and architectural retention" : "federal-road and infrastructure retention") . ".";

  my $faq3q = "How do I procure MSE wall services for a project in $name?";
  my $faq3a = "Send the project brief (location within $name, wall height range, application, soil report if available) via WhatsApp +60 12-236 2159 or email lai\@anchorsolwall.com. Same-day response with indicative scope, programme, and cost band. Delivery from our Selangor manufacturing facility " . ($s->{slug} =~ /^(sabah|sarawak|labuan)$/ ? "via container freight to East Malaysia ports" : "by road on the Peninsular network") . ".";

  # Pre-compute conditional content before the qq string (avoid nesting interpolation hacks)
  my $is_east_my = ($s->{slug} =~ /^(sabah|sarawak|labuan)$/);
  my $is_quarry_state = ($name eq "Pahang" || $name eq "Perak");
  my $seismic_note = $is_east_my ? "Sabah and Sarawak seismic provisions apply" : "standard peninsular seismic coefficient kh = 0.05 to 0.10";
  my $quarry_origin = $is_quarry_state ? "$name" : "Malaysian";
  my $delivery_note = $is_east_my ? "by container freight to East Malaysia ports" : "by road on the Peninsular network";

  # Render body
  my $body = qq|
<section>
<h2>What we build in $name</h2>
<p>The retaining wall families we deliver in $name, and when each fits:</p>

<h3>Anchored MSE wall (our specialty)</h3>
<p>The AnchorSOL\xC2\xAE Wall System is the cost-efficient default for most retaining walls in $name above 5 metres. The anchored mechanism (pullout resistance at a discrete deadman block) lets the wall run on locally-sourced crusher run at &ge;34&deg; friction angle, saving 30 to 50% on backfill cost versus friction-based MSE systems that require premium granular fill. <a href="../../learn/what-is-mse-wall.html">Read the MSE wall pillar guide \xE2\x86\x92</a></p>

<h3>Reinforced Earth wall (RE wall)</h3>
<p>The original Vidal Reinforced Earth system (Terre Arm\xC3\xA9e, 1963) and modern friction-based variants. Steel-strip or geogrid reinforcement, granular sand backfill, cruciform or rectangular precast facing. Suitable for $name projects where premium granular fill is committed in the project budget. <a href="../../learn/reinforced-earth-wall.html">Read the RE wall guide \xE2\x86\x92</a></p>

<h3>Reinforced Soil wall (RS wall)</h3>
<p>Geogrid-reinforced systems (HDPE punched-and-drawn or PET woven), welded steel wire mesh, polymeric strip composites. Often paired with modular block (SRW) facing for residential and amenity walls in $name. <a href="../../learn/reinforced-soil-wall.html">Read the RS wall guide \xE2\x86\x92</a></p>

<h3>RC retaining wall (cantilever, gravity, counterfort)</h3>
<p>For short walls (below 3 metres), basement integration with building structures, water-retaining walls, and architectural cantilever walls where RC is the right answer in $name, we provide design consultation. Above 5 metres of wall height, MSE almost always beats RC on cost. <a href="../../learn/rc-retaining-wall-design.html">Read the RC retaining wall design guide \xE2\x86\x92</a></p>

<h3>Crib walls and gabion walls (selected applications)</h3>
<p>For short walls in landscape, riverbank protection, slope toe walls, or remote-access sites in $name, we also specify and supply crib walls and gabion walls. Less than 5% of our portfolio but the right answer for the right project.</p>
</section>

<section>
<h2>Cities in $name where AnchorSOL\xC2\xAE has delivered</h2>
<p>From the state capital $cap to outlying districts, AnchorSOL\xC2\xAE 's project footprint in $name spans:</p>
<p>$s->{cities}.</p>
<p>Each project carries the same design and construction standard: full BS 8006 / FHWA / JKR compliance, modular precast facing, hand-or-mini-compactor backfill, drainage layer with collection pipe, monitoring instrumentation on critical walls.</p>
</section>

<section>
<h2>Marquee projects in $name</h2>
<ul>
$s->{projects}
</ul>
<p>$s->{notes}</p>
<p><a href="../../projects/">Browse the full portfolio \xE2\x86\x92</a></p>
</section>

<section>
<h2>Specifying retaining walls for $name projects</h2>
<p>For specifiers, QSs, and approving authorities writing tenders for $name retaining-wall projects:</p>
<ul>
<li><b>Design standards</b>: BS 8006-1:2010 (primary), FHWA NHI-10-024 (parametric reference), JKR Standard Specification (materials and workmanship). For $name, $seismic_note.</li>
<li><b>Backfill spec</b>: anchored MSE allows crusher run at &ge;34&deg; friction angle. Friction-based MSE requires premium granular at &ge;36&deg;. Crusher run from local $quarry_origin quarries typically meets the anchored spec.</li>
<li><b>Concrete grade</b>: Grade 30 minimum for inland walls, Grade 35 to 40 for coastal or aggressive environments (relevant for $name coastal projects).</li>
<li><b>Reinforcement</b>: hot-dip galvanized carbon steel deformed bar with BS 8006 Annex B sacrificial-thickness allowance for the 75 to 120 year design life.</li>
<li><b>Pre-qualification</b>: CIDB G7 minimum, &ge;10 named MSE wall projects, professional engineer leading design, ISO 9001 quality system, in-house manufacturing.</li>
</ul>
<p><a href="../../learn/mse-wall-specification-template.html">See our 8-section tender specification template \xE2\x86\x92</a></p>
</section>

<section>
<h2>Procuring AnchorSOL\xC2\xAE for $name</h2>
<p><b>Step 1</b>: Send your project brief (location in $name, wall height range, application type, soil report if available) via WhatsApp <a href="https://wa.me/60122362159?text=Hi%20AnchorSOL%2C%20project%20enquiry%20in%20$s->{slug}.">+60 12-236 2159</a> or email <a href="mailto:lai\@anchorsolwall.com">lai\@anchorsolwall.com</a>.</p>
<p><b>Step 2</b>: Same-day response with indicative scope, programme, and cost band from the engineering team.</p>
<p><b>Step 3</b>: Once awarded, full design submission (calculations, drawings, method statement, materials specifications, quality plan) within 2 to 4 weeks.</p>
<p><b>Step 4</b>: Precast manufacture at our Selangor facility, delivery to $name $delivery_note.</p>
<p><b>Step 5</b>: Installation by our 3-4 person trained erection crew, with monitoring instrumentation handed to the asset owner at completion.</p>
<p><a class="btn btn--p" href="https://wa.me/60122362159?text=Hi%20AnchorSOL%2C%20project%20enquiry%20in%20$s->{slug}." target="_blank" rel="noopener">WhatsApp brief from $name \xE2\x86\x92</a>  <a class="btn btn--g" href="../../#contact">All contact details</a></p>
</section>
|;

  # Schema and HTML head
  my $html = <<HTML;
<!DOCTYPE html>
<html lang="en" class="no-js">
<head>
<meta charset="UTF-8" />
<title>$title</title>
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
<meta name="description" content="$desc" />
<meta name="keywords" content="$kw" />
<meta name="theme-color" content="#0a1426" />
<link rel="canonical" href="$url" />
<meta property="og:type" content="website" />
<meta property="og:site_name" content="AnchorSOL\xC2\xAE Wall" />
<meta property="og:locale" content="en_MY" />
<meta property="og:title" content="$title" />
<meta property="og:description" content="$desc" />
<meta property="og:image" content="https://anchorsolwall.com/assets/videos/wall-linear-poster.jpg" />
<meta property="og:url" content="$url" />
<meta name="twitter:card" content="summary_large_image" />
<link rel="icon" type="image/png" href="../../favicon.png" sizes="any" />
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Archivo:wght\@400;500;600;700;800;900&family=JetBrains+Mono:wght\@400;500;700&display=swap" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Archivo:wght\@400;500;600;700;800;900&family=JetBrains+Mono:wght\@400;500;700&display=swap" media="print" onload="this.media='all'" />
<noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Archivo:wght\@400;500;600;700;800;900&family=JetBrains+Mono:wght\@400;500;700&display=swap" /></noscript>
<link rel="stylesheet" href="../../css/style.css" />
<script type="application/ld+json">
{
  "\@context": "https://schema.org",
  "\@graph": [
    {"\@type": "BreadcrumbList", "itemListElement": [
      {"\@type": "ListItem", "position": 1, "name": "Home", "item": "https://anchorsolwall.com/"},
      {"\@type": "ListItem", "position": 2, "name": "Locations", "item": "https://anchorsolwall.com/locations/"},
      {"\@type": "ListItem", "position": 3, "name": "$name", "item": "$url"}
    ]},
    {"\@type": ["WebPage", "AboutPage"], "\@id": "$url#page",
     "name": "$title",
     "url": "$url",
     "description": "$desc",
     "isPartOf": {"\@id": "https://anchorsolwall.com/#website"},
     "about": {"\@type": "Place", "name": "$name, Malaysia"},
     "mainEntity": {"\@id": "https://anchorsolwall.com/#organization"},
     "inLanguage": "en-MY",
     "isAccessibleForFree": true,
     "speakable": {"\@type": "SpeakableSpecification", "cssSelector": [".article__lede", ".article__head h1"]},
     "audience": {"\@type": "Audience", "name": "Civil engineers, geotechnical engineers, quantity surveyors, contractors, developers, and approving authorities in $name involved in retaining wall procurement", "audienceType": "professional"}
    },
    {"\@type": "Service",
     "name": "MSE wall contractor in $name",
     "alternateName": ["Anchored MSE wall $name", "Mechanically Stabilized Earth wall $name", "RE wall contractor $name", "RS wall contractor $name", "RC retaining wall consultation $name", "Retaining wall contractor $name"],
     "provider": {"\@id": "https://anchorsolwall.com/#organization"},
     "areaServed": {"\@type": "AdministrativeArea", "name": "$name, Malaysia"},
     "serviceType": "Retaining wall design and build",
     "description": "$desc"
    },
    {"\@type": "FAQPage", "mainEntity": [
      {"\@type": "Question", "name": "$faq1q", "acceptedAnswer": {"\@type": "Answer", "text": "$faq1a"}},
      {"\@type": "Question", "name": "$faq2q", "acceptedAnswer": {"\@type": "Answer", "text": "$faq2a"}},
      {"\@type": "Question", "name": "$faq3q", "acceptedAnswer": {"\@type": "Answer", "text": "$faq3a"}}
    ]}
  ]
}
</script>
<meta name="msvalidate.01" content="REPLACE_WITH_BING_CODE" />
<script async src="https://www.googletagmanager.com/gtag/js?id=G-DBPBK6RL1G"></script>
<script>window.dataLayer = window.dataLayer || [];function gtag(){dataLayer.push(arguments);}gtag('js', new Date());gtag('config', 'G-DBPBK6RL1G', { anonymize_ip: true });</script>
<script>document.documentElement.classList.remove('no-js');</script>
</head>
<body>
<a href="#main" class="skip">Skip to content</a>

<header class="nav"><div class="wrap"><div class="nav__in">
  <a class="brand" href="../../" aria-label="AnchorSOL Wall, Home">
    <img src="../../assets/images/logo-white.png" alt="" data-no-picture decoding="async">
    <span class="wm"><span>ANCHORSOL<sup>\xC2\xAE</sup></span><small>WALL SYSTEMS \xC2\xB7 EST. 1999</small></span>
  </a>
</div></div></header>

<main id="main" class="article">
<div class="wrap article__wrap">

<nav class="breadcrumb" aria-label="Breadcrumb">
  <a href="../../">Home</a> <span>\xC2\xB7</span> <a href="../">Locations</a> <span>\xC2\xB7</span> <span>$name</span>
</nav>

<article>
<header class="article__head">
  <span class="article__tag">Location reference</span>
  <h1>$h1</h1>
  $lede
  <p class="article__meta">By <b>Dr. Ir. Lai Yip Poon</b>, Founder & Chief Designer \xC2\xB7 AnchorSOL\xC2\xAE Wall Sdn. Bhd. \xC2\xB7 ~9 min read</p>
</header>

$body

</article>

<aside class="article__related">
  <span class="tech-label">Read next</span>
  <div class="article__related-grid">
    <a class="kb-card" href="../">
      <span class="kb-card__tag">All locations</span>
      <h3>MSE wall in Malaysia, by state</h3>
      <p>All 13 states and 3 federal territories with named cities, marquee projects, agencies.</p>
      <span class="kb-card__cta">See locations index \xE2\x86\x92</span>
    </a>
    <a class="kb-card" href="../../contractor/">
      <span class="kb-card__tag">Contractor</span>
      <h3>MSE wall contractor reference</h3>
      <p>Malaysia's No.1 MSE wall contractor. Anchored MSE, RE wall, RS wall, RC wall design and build.</p>
      <span class="kb-card__cta">Read contractor reference \xE2\x86\x92</span>
    </a>
    <a class="kb-card" href="../../projects/">
      <span class="kb-card__tag">Portfolio</span>
      <h3>500+ named projects</h3>
      <p>Every wall in the delivered portfolio. JKR, PLUS, LLM, KTMB, Putrajaya, Iskandar, Padma Bridge.</p>
      <span class="kb-card__cta">Browse portfolio \xE2\x86\x92</span>
    </a>
  </div>
</aside>

</div>
</main>
HTML

  $html .= footer_and_tabbar();
  return $html;
}

# Generate all 16 pages
for my $s (@states) {
  my $dir = "$out_dir/$s->{slug}";
  make_path($dir) unless -d $dir;
  my $path = "$dir/index.html";
  open my $out, '>:utf8', $path or die "write $path: $!";
  print $out generate_page($s);
  close $out;
  print "OK    locations/$s->{slug}/index.html\n";
}

print "\nDone. " . scalar(@states) . " state pages generated.\n";
