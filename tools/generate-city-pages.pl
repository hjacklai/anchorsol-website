#!/usr/bin/env perl
# Tier-1 city landing pages for AnchorSOL Wall.
# Generates /locations/{state}/{city}/index.html for 11 cities.
# Each page has unique geology + economic + agency + local-project content
# that the state page does NOT have, to avoid Google's near-duplicate filter.
use strict;
use warnings;
use File::Path qw(make_path);
use utf8;
binmode STDOUT, ':utf8';

my $out_base = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/locations';

# Each city has these unique fields, all different from the state page:
#   municipal_council  — e.g., MBSA, MBPP, MBI (the real local-authority NAP)
#   geology_local      — city-specific ground conditions (NOT state-level)
#   economic_specific  — local industry / development corridor
#   local_projects     — projects in or near this city specifically
#   use_cases_local    — the wall applications most common HERE
#   nearby_landmarks   — anchoring text for local relevance

my @cities = (
  # ============ SELANGOR (4 cities) ============
  {
    slug => 'shah-alam', city => 'Shah Alam', state_slug => 'selangor', state => 'Selangor',
    municipal_council => 'MBSA (Majlis Bandaraya Shah Alam)',
    geology_local => 'Shah Alam sits on the weathered granite-derived saprolite of the Klang Valley western flank. Northern Shah Alam (sections 13, U10, U12) runs into the foothills of Bukit Cherakah, where slope-retention work is the dominant geometry. Industrial estates in the south (Section 23, Hicom-Glenmarie) are on engineered fill over older alluvial flats.',
    economic_specific => 'Shah Alam is the Selangor state capital and one of the largest planned cities in Southeast Asia. Hosts Proton, MITI Selangor, and the bulk of state-government administration. Major active development: Setia Alam, Bukit Jelutong, i-City, Sungai Buloh Hospital expansion, the upcoming Petaling-Klang-Shah Alam corridor MRT3 alignment.',
    local_projects => 'AnchorSOL Wall Sdn. Bhd. HQ + precast manufacturing facility sits in <b>Bukit Jelutong, Section U8, Shah Alam</b>. Walls delivered locally include Elmina Business Park 2 Phase 4B (Sime Darby Property, 12,452 m²), Bukit Cherakah slope-retention works, and multiple Setia Alam phase wall packages.',
    use_cases_local => 'Hillside platform creation for housing development (Bukit Cherakah, Bukit Jelutong slopes). Industrial-platform retention for warehousing in Hicom-Glenmarie. Highway-embankment walls on the LATAR and KESAS interchanges serving Shah Alam.',
    nearby_landmarks => 'Stadium Shah Alam, i-City, Setia City Mall, Section 7 commercial belt, Sultan Salahuddin Abdul Aziz Shah Mosque (Blue Mosque), Shah Alam Lake Gardens.',
  },
  {
    slug => 'petaling-jaya', city => 'Petaling Jaya', state_slug => 'selangor', state => 'Selangor',
    municipal_council => 'MBPJ (Majlis Bandaraya Petaling Jaya)',
    geology_local => 'Petaling Jaya straddles the alluvial plain of the Klang River with foothill outcrops at Damansara Heights, Bukit Kiara, and SS22-SS23. The old PJ sections (Old Town, New Town, SS1-SS3) sit on soft alluvial clay 8 to 18 m thick; the newer Damansara sections climb into weathered granite hillsides. PJ wall projects therefore split sharply between soft-foundation MSE (with ground improvement) and slope-retention MSE (anchored into competent in-situ ground).',
    economic_specific => 'PJ is the densest commercial-and-residential market in Selangor outside KL itself. Hosts the bulk of the Klang Valley\'s post-merdeka first-wave new town. Active development: 1 Powerhouse Bandar Utama, PJ Sentral, Damansara Uptown 2, Mont Kiara fringe corridor, the LRT3 Bandar Utama interchange.',
    local_projects => 'Walls delivered on the LDP corridor through Damansara, KESAS embankment retention near Sunway, and various private-developer projects in Section 13 and Bukit Damansara. Damansara Heights hillside-retention work for boutique residential plots.',
    use_cases_local => 'Hillside retention for premium hillside-residential plots (Damansara Heights, Bukit Kiara). Highway-interchange walls (LDP, KESAS, NPE). Drainage corridor retention along the Klang River and Damansara River reserves. Architectural-finish walls for institutional and education campuses.',
    nearby_landmarks => '1 Utama, Sunway Pyramid, KL Gateway, Universiti Malaya, PJ Old Town, Bandar Utama, Damansara Uptown, KDU University College, Universiti Pendidikan Sultan Idris (Petaling Jaya campus).',
  },
  {
    slug => 'klang', city => 'Klang', state_slug => 'selangor', state => 'Selangor',
    municipal_council => 'MPK (Majlis Perbandaran Klang) and Klang Royal Capital authority',
    geology_local => 'Klang sits on the coastal alluvial deposits of the Klang River delta. Ground conditions are dominated by soft marine clays 5 to 25 m thick, with consolidation settlement of 200 to 600 mm typical at design loads. Almost every MSE wall in Klang needs ground improvement (PVDs + preload, stone columns, or jet grouting) before foundation can support tall walls. Westport and Northport areas have reclaimed fill over the same clays.',
    economic_specific => 'Klang is the Royal Town of Selangor and the country\'s largest port complex (Westport + Northport). Heavy industry: refining, container handling, petrochemical, logistics. The Westport expansion programme and Pulau Indah container yard generate continuous demand for port-spec retaining walls and platform-creation walls.',
    local_projects => 'KESAS, ELITE, and LATAR expressway embankments through Klang. Westport land-side container yard retention. Pulau Indah industrial-estate platform walls. Various JKR district roadworks in greater Klang.',
    use_cases_local => 'Marine-spec MSE walls for port land-side retention (Westport, Northport, Pulau Indah, Carey Island). Industrial-platform creation on reclaimed coastal land. Highway-embankment walls on KESAS and ELITE crossings. Drainage and flood-mitigation walls along the Klang River and tributaries.',
    nearby_landmarks => 'Westport, Northport, Pulau Indah, Carey Island, Kota Raja, Pandamaran, Bandar Bukit Tinggi, Sultan Abdul Aziz Royal Gallery, Klang Royal Town heritage zone.',
  },
  {
    slug => 'kajang', city => 'Kajang', state_slug => 'selangor', state => 'Selangor',
    municipal_council => 'MPKj (Majlis Perbandaran Kajang)',
    geology_local => 'Kajang and the broader Kajang-Bangi-Semenyih corridor sits on weathered granite saprolite with patches of older alluvial fill in the valley floors. The terrain steps gradually up from KL towards the Negeri Sembilan border, so retaining walls here are mostly hillside-platform creation for new township development. Granular crusher run is locally available from Bangi and Beranang quarries.',
    economic_specific => 'Kajang anchors the southern Klang Valley growth corridor along with Bangi, Semenyih, and Cyberjaya. Continuous township roll-out (Setia Eco Hill, Kajang 2, Setia Eco Glades, Eco Majestic Semenyih) drives consistent retaining-wall demand. The MRT1 Sungai Buloh-Kajang Line terminates at Kajang Station and the MRT2 Putrajaya Line crosses south of Kajang town. Education hub: UNITEN, USIM, MMU, UKM.',
    local_projects => '<b>Mixed Development Semenyih (Duta Villa)</b>, 12,000 m² of anchored MSE wall. Various Kajang 2 and Setia Eco Hill platform walls. ELITE Expressway interchange embankments. Multiple Bangi industrial-estate platform walls.',
    use_cases_local => 'Hillside platform creation for new township development across the Kajang-Semenyih corridor. Highway-interchange walls on ELITE and the SILK expressway. Education-campus boundary and slope walls (UNITEN Bangi, UKM Bangi).',
    nearby_landmarks => 'Kajang town, Bandar Baru Bangi, Semenyih, Setia Eco Hill, Kajang 2, Setia Eco Glades, Eco Majestic Semenyih, UKM, MMU Cyberjaya (adjacent), Genting Highlands road (south-east connection).',
  },

  # ============ JOHOR (2 cities) ============
  {
    slug => 'johor-bahru', city => 'Johor Bahru', state_slug => 'johor', state => 'Johor',
    municipal_council => 'MBJB (Majlis Bandaraya Johor Bahru)',
    geology_local => 'JB Central sits on the coastal alluvial belt of the Tebrau Strait, with marine clays 5 to 20 m thick. The northern foothills (Tebrau, Pasir Pelangi, Permas Jaya, Plentong) climb into weathered granite. Sites near Danga Bay and the Causeway approach require marine-spec foundation due to saline groundwater.',
    economic_specific => 'JB is the Johor state capital and a primary entry point from Singapore via the Causeway and Second Link. Hosts the Iskandar Malaysia southern flank. Heavy infrastructure underway: RTS Link (Rapid Transit System) to Singapore, JB-Singapore Causeway upgrade, ongoing Bukit Chagar redevelopment, EDL extensions.',
    local_projects => 'JB Sentral and Bukit Chagar transit-hub retaining walls. EDL (Eastern Dispersal Link) embankment walls. Permas Jaya residential township walls. JKR Johor district road embankments throughout greater JB.',
    use_cases_local => 'Causeway-approach and transit-hub walls (JB Sentral, RTS Link, Bukit Chagar). Marine-grade retention near the Tebrau Strait shoreline. Township platform walls on the Tebrau and Plentong foothills. Highway-embankment walls on the EDL and PLUS-South.',
    nearby_landmarks => 'JB Sentral, Bukit Chagar, Sultan Iskandar Building (CIQ Causeway), Danga Bay, Permas Jaya, Tebrau, Plentong, Larkin Sentral, Johor Bahru City Square, KSL City, R&F Princess Cove.',
  },
  {
    slug => 'iskandar-puteri', city => 'Iskandar Puteri', state_slug => 'johor', state => 'Johor',
    municipal_council => 'MBIP (Majlis Bandaraya Iskandar Puteri)',
    geology_local => 'Iskandar Puteri (formerly Nusajaya) is built on reclaimed and engineered fill over former oil-palm and rubber plantation land. Underlying conditions are weathered granite saprolite with marine-clay pockets near the Selat Tebrau coastline. The Medini, EduCity, and Puteri Harbour precincts all sit on substantial engineered fill, so MSE walls here are typically platform-edge walls on fill foundations.',
    economic_specific => 'Iskandar Puteri is the centrepiece of the Iskandar Malaysia masterplan and hosts the Johor state administrative centre (Kota Iskandar). EduCity hosts University of Reading Malaysia, University of Southampton Malaysia, Newcastle University Medicine Malaysia, and several other foreign-university campuses. Medini hosts the Pinewood Iskandar Malaysia film studios, Legoland Malaysia Resort, Mall of Medini, and continuing mixed-use development.',
    local_projects => 'Walls delivered along the <b>Lebuhraya Pesisiran Pantai JB-Nusajaya Section 3</b>, 23,000 m². Iskandar Puteri internal-road embankment walls. EduCity campus boundary walls. Kota Iskandar government complex retention.',
    use_cases_local => 'Platform-edge walls for new precincts on engineered fill (Medini, EduCity, Puteri Harbour). Highway-embankment walls along the Coastal Highway and PLUS-South spurs. Architectural-face walls for the EduCity foreign-university campuses. Marine-grade walls at Puteri Harbour.',
    nearby_landmarks => 'Kota Iskandar (Johor state government complex), Puteri Harbour, Legoland Malaysia Resort, EduCity, Medini, Pinewood Studios, Forest City (adjacent), Senai Airport (north).',
  },

  # ============ PERAK (1 city) ============
  {
    slug => 'ipoh', city => 'Ipoh', state_slug => 'perak', state => 'Perak',
    municipal_council => 'MBI (Majlis Bandaraya Ipoh)',
    geology_local => 'Ipoh sits in the Kinta Valley, bracketed by the Banjaran Titiwangsa main range to the east and the Banjaran Keledang to the west. The dominant local geology is karst limestone — the famous tower-karst hills that ring the city (Gunung Lang, Gunung Rapat, Gunung Cheroh) are exposed Kinta Limestone. Foundation design in Ipoh must account for solution cavities, pinnacled rockhead, and sinkhole risk in the alluvial valley floor between limestone outcrops.',
    economic_specific => 'Ipoh is the Perak state capital and historically the world\'s largest tin-mining town. Today the economy runs on manufacturing (Tasek industrial area, Meru industrial estate), food processing (white coffee, dim sum tourism), education (UTAR, Politeknik Sultan Azlan Shah, Quest International University), and tourism. Active infrastructure: ETS rail upgrade, PLUS-North widening near the Gopeng-Tapah corridor, ongoing Ipoh Sentral redevelopment.',
    local_projects => '<b>Sultan Iskandar Highway / Ipoh Sultan Iskandar Interchange</b> (Highway retention, Perak). <b>Jalan Gopeng Interchange</b> walls. <b>JKR Bandar Sri Iskandar</b> federal-road wall (Perak, JKR). Sultan Azlan Shah Airport approach retention.',
    use_cases_local => 'Highway-embankment walls on the PLUS-North corridor and on JKR federal trunk roads through the Kinta Valley. Hillside retention for foothill development near the limestone karst (Tambun, Bercham, Gunung Rapat fringe). Foundation walls over karst-prone ground requiring deep grouted-pile or jet-grouted columns. Industrial-platform walls in Tasek and Meru.',
    nearby_landmarks => 'Gunung Lang Recreational Park, Sultan Azlan Shah Airport, Ipoh Railway Station, Ipoh Padang, Old Town, New Town, Tambun, Bercham, Meru Raya, Sunway City Ipoh, Lost World of Tambun.',
  },

  # ============ PENANG (1 city) ============
  {
    slug => 'george-town', city => 'George Town', state_slug => 'penang', state => 'Penang',
    municipal_council => 'MBPP (Majlis Bandaraya Pulau Pinang)',
    geology_local => 'George Town sits on a narrow coastal strip on the north-east of Penang Island, with the central spine of Penang Hill (Bukit Bendera) rising to 833 m immediately inland. The waterfront and city centre are mostly engineered fill over marine clays; the inland transition (Air Itam, Paya Terubong, Tanjung Bungah) climbs into weathered granite hillside with rapid topography. Hillside slope-stability is critical given the dense urban development against steep terrain.',
    economic_specific => 'George Town is the Penang state capital and a UNESCO World Heritage Site. Economy: electrical and electronics (Bayan Lepas free industrial zone, just south), tourism, services. Active infrastructure: Penang LRT (Mutiara Line, planned), Penang Hill cable car (planned), Penang South Reclamation (PSR / Silicon Island), continuing port-side and reclamation works.',
    local_projects => 'Walls on the Tun Lim Chong Eu Expressway (coastal highway). Slope-retention works on the inland hillsides above Tanjung Bungah and Tanjung Tokong. Various JKR Penang district roadworks.',
    use_cases_local => 'Hillside slope-retention for residential developments climbing into the Penang Hill side (Tanjung Bungah, Batu Ferringhi, Air Itam). Highway-embankment walls on the Tun Lim Chong Eu Expressway and on Penang Bridge approaches. Architectural-face walls in the UNESCO heritage zone where finish quality is constrained by conservation. Reclamation-edge walls for PSR and other coastal projects.',
    nearby_landmarks => 'Penang Hill (Bukit Bendera), Komtar, Gurney Drive, Tanjung Bungah, Tanjung Tokong, Batu Ferringhi, Penang Bridge approach, Bayan Lepas (south, separate light-industrial centre), Air Itam.',
  },

  # ============ SABAH (1 city) ============
  {
    slug => 'kota-kinabalu', city => 'Kota Kinabalu', state_slug => 'sabah', state => 'Sabah',
    municipal_council => 'DBKK (Dewan Bandaraya Kota Kinabalu)',
    geology_local => 'Kota Kinabalu (KK) sits on the coastal alluvial plain of the South China Sea, with the Crocker Range rising sharply to the east. The city centre is built on reclaimed and engineered fill over soft marine clays and peaty soils — peat thickness can reach 8 m in some Likas Bay and Tanjung Aru sections. Crocker Range fringe (Kingfisher, Donggongon) climbs into folded sediments and serpentinite, with active landslip risk during the north-east monsoon.',
    economic_specific => 'KK is the Sabah state capital and the largest city in Borneo Malaysia. Tourism (Mount Kinabalu, Sipadan, marine parks), oil and gas (Petronas, KKIP Sepanggar), and agriculture (palm oil) anchor the economy. Active infrastructure: Pan Borneo Highway Sabah package (continuing rollout), KKIP industrial expansion, Sepanggar Port upgrade, ongoing waterfront redevelopment.',
    local_projects => 'Pan Borneo Highway Sabah package embankment walls on the inland Crocker Range crossing. KKIP industrial-platform retention. Various JKR Sabah district roadworks throughout greater KK.',
    use_cases_local => 'Highway-embankment walls on the Pan Borneo Sabah alignment through the Crocker Range foothills. Marine-grade walls on KK waterfront and Likas Bay reclamation. Industrial-platform walls in KKIP and Sepanggar. Hillside slope-retention on the Crocker Range fringe (Kingfisher, Donggongon, Penampang).',
    nearby_landmarks => 'Mount Kinabalu (national park, east), Tanjung Aru, Likas Bay, Sepanggar Bay, KKIP industrial park, Penampang, Donggongon, Inanam, Tuaran (north suburb), Putatan, Kota Kinabalu International Airport.',
  },

  # ============ SARAWAK (2 cities) ============
  {
    slug => 'kuching', city => 'Kuching', state_slug => 'sarawak', state => 'Sarawak',
    municipal_council => 'DBKU (Dewan Bandaraya Kuching Utara) and MBKS (Majlis Bandaraya Kuching Selatan), bifurcated north-south of the Sarawak River',
    geology_local => 'Kuching straddles the Sarawak River, with the city centre on alluvial deposits and the inland hills (Gunung Serapi, Bako, Santubong) rising into folded sedimentary and intrusive granite. Peat soils dominate the south-western suburbs (Mata Kuching, Petra Jaya peat domes can be 4 to 12 m thick). Foundation design in Kuching depends on whether the site is alluvial flat, peat dome, or weathered intrusive — three very different design problems.',
    economic_specific => 'Kuching is the Sarawak state capital and the largest city in East Malaysia. Economy: oil and gas administrative hub (Petronas Sarawak), tourism (cat city, Sarawak Cultural Village, Bako and Kubah National Parks), and timber. Active infrastructure: Pan Borneo Highway Sarawak (S1-S11 packages, continuing rollout), Kuching Urban Transport System (LRT-like, planned), Sarawak Coastal Road extensions.',
    local_projects => 'Pan Borneo Highway Sarawak embankment walls on multiple package alignments. JKR Sarawak federal-road walls through greater Kuching. Various private-developer township walls (BDC, Tabuan Jaya, Petra Jaya).',
    use_cases_local => 'Highway-embankment walls on the Pan Borneo Sarawak corridor and JKR federal roads. Foundation walls over peat ground requiring substantial ground improvement (PVDs + preload, stone columns, or in extreme cases mass-displacement piles). Hillside retention on the Santubong and Gunung Serapi foothills. Marine-edge walls on the Sarawak River and Kuching Waterfront.',
    nearby_landmarks => 'Sarawak State Legislative Assembly (DUN), Astana, Fort Margherita, Kuching Waterfront, Sarawak Museum, Bako National Park, Kubah National Park, Santubong, Damai Beach, Petra Jaya, BDC, Tabuan Jaya, Kuching International Airport.',
  },
  {
    slug => 'miri', city => 'Miri', state_slug => 'sarawak', state => 'Sarawak',
    municipal_council => 'MBMP (Majlis Bandaraya Miri)',
    geology_local => 'Miri sits on the north Sarawak coastal belt, with alluvial deposits inland and the Miri Hill (Bukit Tenaga) tower-karst formation marking the city centre. South of Miri, the Niah and Lambir areas climb into sedimentary uplands. Coastal sections face peaty marine clays; inland sections face landslip-prone weathered sediments on steep grades.',
    economic_specific => 'Miri is the oil and gas capital of Sarawak and Malaysia\'s second city in East Malaysia. Petronas Malaysian LNG, Shell, and various upstream operators anchor the economy. The Miri Crude Oil Terminal and Bintulu LNG (south) drive heavy goods movement on the Pan Borneo corridor. Tourism: Niah Caves, Lambir Hills, Gunung Mulu National Park (via Miri airport).',
    local_projects => 'Pan Borneo Highway Sarawak embankment walls on the northern packages serving Miri to the Bruneian border. JKR Sarawak district roadworks. Various oil-and-gas plant-side and port-side platform walls.',
    use_cases_local => 'Highway-embankment walls on the Pan Borneo Sarawak northern alignment. Oil-and-gas plant-side retention with marine-grade durability for the Miri Crude Oil Terminal and ancillary works. Coastal-edge retention along the South China Sea shoreline. Tourism-corridor walls towards Niah and Lambir.',
    nearby_landmarks => 'Bukit Tenaga (Canada Hill), Miri Crude Oil Terminal, Niah National Park (south), Lambir Hills National Park, Marina Phase 2, Tudan, Permyjaya, Bekenu (suburb), Miri Airport, Gunung Mulu National Park (inland access via Miri).',
  },
);

# ---------- HTML template ----------
sub render_city {
  my ($c) = @_;
  my $title_h1 = "Retaining Wall Contractor in $c->{city}, $c->{state}";
  my $meta_title = "MSE Wall & Retaining Wall Contractor in $c->{city}, $c->{state} | AnchorSOL Wall";
  my $meta_desc = "Anchored MSE wall, RE/RS/RC retaining wall contractor for $c->{city}, $c->{state}. JKR / PLUS / KTMB / LLM specified. 500+ projects since 1999. Hillside, highway, bridge abutment, urban infill.";

  my $faq_questions = [
    {
      q => "Do you build retaining walls in $c->{city}?",
      a => "Yes. AnchorSOL Wall Sdn. Bhd. delivers anchored MSE walls, RE walls, RS walls, and RC retaining walls in $c->{city} and the wider $c->{state} state. Local authority is $c->{municipal_council}. Our delivery is via the same precast manufacturing in Bukit Jelutong, Shah Alam, with project-managed haulage to $c->{city}.",
    },
    {
      q => "What wall type is best for $c->{city} ground conditions?",
      a => "Selection depends on the specific site. $c->{geology_local} Wall-system selection follows: hillside cuts favour anchored MSE; soft-foundation sites need ground improvement before MSE; urban-infill plots may need RC counterfort where space is constrained.",
    },
    {
      q => "Which $c->{city} agencies have you worked with?",
      a => "We deliver to federal agencies (JKR, PLUS, LLM, KTMB) operating in $c->{state}, plus the local authority $c->{municipal_council} where municipal walls are specified. Project list available on request.",
    },
    {
      q => "How does delivery to $c->{city} work?",
      a => "Precast facing panels are manufactured at our Bukit Jelutong (Shah Alam) facility, then hauled to $c->{city} on flat-bed trucks. Tendon and anchor block production is co-located. A 3 to 4 person erection crew mobilises with the panels and completes 30 to 80 m² of wall per day on site.",
    },
  ];

  my $faq_json = '';
  my $faq_html = '';
  for my $i (0..$#$faq_questions) {
    my $f = $faq_questions->[$i];
    $faq_json .= ($i == 0 ? '' : ",\n") . qq|        {"\@type": "Question", "name": "$f->{q}", "acceptedAnswer": {"\@type": "Answer", "text": "$f->{a}"}}|;
    $faq_html .= qq|<details><summary>$f->{q}</summary><p>$f->{a}</p></details>\n|;
  }

  my $url = "https://anchorsolwall.com/locations/$c->{state_slug}/$c->{slug}/";
  my $state_url = "https://anchorsolwall.com/locations/$c->{state_slug}/";
  my $city_lower = lc($c->{city});

  return <<HTML;
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
<title>$meta_title</title>
<meta name="description" content="$meta_desc" />
<meta name="theme-color" content="#0a1426" />
<link rel="canonical" href="$url" />
<meta property="og:type" content="website" />
<meta property="og:site_name" content="AnchorSOL® Wall" />
<meta property="og:locale" content="en_MY" />
<meta property="og:title" content="$meta_title" />
<meta property="og:description" content="$meta_desc" />
<meta property="og:url" content="$url" />
<meta property="og:image" content="https://anchorsolwall.com/assets/videos/wall-linear-poster.jpg" />
<meta name="twitter:card" content="summary_large_image" />
<link rel="icon" type="image/png" href="../../../favicon.png" sizes="any" />
<link rel="apple-touch-icon" href="../../../apple-touch-icon.png" />
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link rel="preload" as="style" href="https://fonts.googleapis.com/css2?family=Archivo:wght\@400;500;600;700;800;900&family=JetBrains+Mono:wght\@400;500;700&display=swap" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Archivo:wght\@400;500;600;700;800;900&family=JetBrains+Mono:wght\@400;500;700&display=swap" media="print" onload="this.media='all'" />
<noscript><link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Archivo:wght\@400;500;600;700;800;900&family=JetBrains+Mono:wght\@400;500;700&display=swap" /></noscript>
<link rel="stylesheet" href="../../../css/style.css" />
<script type="application/ld+json">
{
  "\@context": "https://schema.org",
  "\@graph": [
    {
      "\@type": "Service",
      "\@id": "$url#service",
      "name": "$title_h1",
      "serviceType": "Retaining wall contractor services",
      "url": "$url",
      "description": "$meta_desc",
      "provider": {"\@id": "https://anchorsolwall.com/#organization"},
      "areaServed": {
        "\@type": "City",
        "name": "$c->{city}",
        "containedInPlace": {"\@type": "AdministrativeArea", "name": "$c->{state}, Malaysia"}
      },
      "hasOfferCatalog": {
        "\@type": "OfferCatalog",
        "name": "Retaining wall systems offered in $c->{city}",
        "itemListElement": [
          {"\@type": "Offer", "itemOffered": {"\@type": "Service", "name": "Anchored MSE wall for $c->{city}"}},
          {"\@type": "Offer", "itemOffered": {"\@type": "Service", "name": "Reinforced Earth (RE) wall for $c->{city}"}},
          {"\@type": "Offer", "itemOffered": {"\@type": "Service", "name": "Reinforced Soil (RS) wall for $c->{city}"}},
          {"\@type": "Offer", "itemOffered": {"\@type": "Service", "name": "RC retaining wall design and consultation for $c->{city}"}}
        ]
      }
    },
    {
      "\@type": "BreadcrumbList",
      "itemListElement": [
        {"\@type": "ListItem", "position": 1, "name": "Home", "item": "https://anchorsolwall.com/"},
        {"\@type": "ListItem", "position": 2, "name": "Locations", "item": "https://anchorsolwall.com/locations/"},
        {"\@type": "ListItem", "position": 3, "name": "$c->{state}", "item": "$state_url"},
        {"\@type": "ListItem", "position": 4, "name": "$c->{city}", "item": "$url"}
      ]
    },
    {
      "\@type": "FAQPage",
      "mainEntity": [
$faq_json
      ]
    }
  ]
}
</script>
</head>
<body>

<header class="nav"><div class="wrap"><div class="nav__in">
  <a class="brand" href="../../../" aria-label="AnchorSOL Wall, Home">
    <img src="../../../assets/images/logo-white.png" alt="" data-no-picture decoding="async">
    <span class="wm"><span>ANCHORSOL<sup>®</sup></span><small>WALL SYSTEMS · EST. 1999</small></span>
  </a>
</div></div></header>

<article class="article">
<div class="wrap article__wrap">

<header class="article__head">
  <nav class="breadcrumb" aria-label="Breadcrumb">
    <a href="../../../">Home</a> · <a href="../../">Locations</a> · <a href="../">$c->{state}</a> · <span>$c->{city}</span>
  </nav>
  <span class="article__tag">Location · $c->{state}</span>
  <h1>$title_h1</h1>
  <p class="article__lede">Anchored MSE wall, RE wall, RS wall, and RC retaining wall contractor for $c->{city} and the wider $c->{state} state. JKR / PLUS / KTMB / LLM specified. 500+ projects since 1999, AnchorSOL Wall Sdn. Bhd.</p>
</header>

<section id="$c->{slug}-context">
<h2>Building walls in $c->{city}</h2>
<p>$c->{geology_local}</p>
<p>$c->{economic_specific}</p>
<p>Local authority: <b>$c->{municipal_council}</b>. Nearby landmarks the local engineering community uses for site reference: $c->{nearby_landmarks}</p>
</section>

<section id="$c->{slug}-use-cases">
<h2>What we build in $c->{city}</h2>
<p>$c->{use_cases_local}</p>
<p>The wall systems available across these applications:</p>
<ul>
  <li><b>Anchored MSE wall</b>, the AnchorSOL system: precast concrete facing panels, hot-dip galvanised tendons, discrete deadman block anchors, crusher-run backfill. Most economical above 5 m wall height. <a href="../../../learn/what-is-mse-wall.html">More on MSE wall fundamentals →</a></li>
  <li><b>Reinforced Earth (RE) wall</b>, the steel-strip variant: cruciform precast facing, ribbed steel strip reinforcement, granular sand backfill. Henri Vidal\'s original 1963 system. <a href="../../../learn/reinforced-earth-wall.html">More on RE walls →</a></li>
  <li><b>Reinforced Soil (RS) wall</b>, the geosynthetic variant: HDPE geogrid or PET woven grid reinforcement, segmental block or precast facing, crusher-run backfill. Faster to install on tight footprints. <a href="../../../learn/reinforced-soil-wall.html">More on RS walls →</a></li>
  <li><b>RC retaining wall</b>, conventional reinforced-concrete cantilever or counterfort: for walls under 5 m, or where space, programme, or aesthetic favours RC over MSE. <a href="../../../learn/rc-retaining-wall-design.html">More on RC retaining walls →</a></li>
</ul>
</section>

<section id="$c->{slug}-projects">
<h2>AnchorSOL projects in or near $c->{city}</h2>
<p>$c->{local_projects}</p>
<p>Selected references span federal-road (JKR), expressway concession (PLUS, LLM, LATAR, ELITE, SUKE, DUKE, EKVE depending on corridor), rail-corridor (KTMB), and major-developer projects across $c->{state}. <a href="../../../projects/">Full project portfolio →</a></p>
</section>

<div class="article-cta">
  <p class="article-cta__lead">Building a wall in $c->{city}? Talk to us.</p>
  <p>500+ named projects since 1999. Anchored MSE, RE, RS, RC retaining walls. Specified by JKR, PLUS, KTMB, LLM.</p>
  <div class="article-cta__btns">
    <a href="https://wa.me/60122362159?text=Hi%20AnchorSOL%2C%20I%27d%20like%20to%20discuss%20a%20wall%20project%20in%20$city_lower." class="btn btn--p" target="_blank" rel="noopener">WhatsApp →</a>
    <a href="https://anchorsolwall.com/#contact" class="btn btn--g">Discuss your project →</a>
  </div>
</div>

<section id="$c->{slug}-faq">
<h2>FAQ — retaining wall contractor in $c->{city}</h2>
$faq_html
</section>

<aside class="article__related">
  <h3 class="article__related-title">Related</h3>
  <div class="article__related-grid">
    <a class="kb-card" href="../"><span class="kb-card__tag">State context</span><h3>$c->{state} state landing</h3><p>Full state-level context — agencies, geology, named projects across $c->{state}.</p><span class="kb-card__cta">Read →</span></a>
    <a class="kb-card" href="../../../contractor/"><span class="kb-card__tag">Contractor</span><h3>Retaining wall contractor services</h3><p>How AnchorSOL Wall Sdn. Bhd. delivers anchored MSE walls across Malaysia.</p><span class="kb-card__cta">Read →</span></a>
    <a class="kb-card" href="../../../projects/"><span class="kb-card__tag">Portfolio</span><h3>500+ named projects</h3><p>Federal road, expressway, rail corridor, hillside, bridge abutment. The wall of record.</p><span class="kb-card__cta">Browse →</span></a>
  </div>
</aside>

</div>
</article>

<footer><div class="wrap">
  <p>&copy; 2026 AnchorSOL® Wall Sdn. Bhd. · Bukit Jelutong, Shah Alam · enquiry\@anchorsolwall.com</p>
</div></footer>

<script src="../../../js/site.js" defer></script>

</body>
</html>
HTML
}

# ---------- Generate all ----------
my $count = 0;
for my $c (@cities) {
  my $dir = "$out_base/$c->{state_slug}/$c->{slug}";
  make_path($dir);
  my $html = render_city($c);
  utf8::encode($html);
  open my $out, '>:raw', "$dir/index.html" or die "write: $!";
  print $out $html;
  close $out;
  $count++;
  print "Generated $c->{state_slug}/$c->{slug}/index.html\n";
}
print "\nTotal city pages generated: $count\n";
