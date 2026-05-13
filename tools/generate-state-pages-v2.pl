#!/usr/bin/env perl
# v2: richer state-specific content + correct UTF-8 encoding (literal Unicode chars
# instead of hex escapes; no :utf8 layer to avoid double-encoding).
use strict;
use warnings;
use File::Path qw(make_path);
use utf8;
binmode STDOUT, ':utf8';

my $out_dir = 'G:/My Drive/CLAUDE WORKING FILES/ANCHORSOL WEBSITE/site/locations';

# Each state has 5 rich fields driving quality copy:
#   geology, terrain     — local geological / engineering context
#   agencies             — state-specific public-works counterparts
#   economic_context     — investment + infrastructure context
#   lai_note             — Dr Lai's engineering observation specific to the state
#   why_us_here          — why anchored MSE fits this state in particular

my @states = (
  {
    slug => 'selangor',
    name => 'Selangor',
    type => 'state',
    capital => 'Shah Alam',
    cities => 'Shah Alam, Petaling Jaya, Subang Jaya, Klang, Cheras, Kajang, Semenyih, Sungai Buloh, Bukit Jelutong, Damansara, Rawang, Selayang, Hulu Selangor, Bukit Antarabangsa, Bandar Saujana Putra, Bandar Utama, Sepang, Ulu Klang',
    context => "Selangor is the densest infrastructure market in Malaysia and the centre of AnchorSOL's delivered portfolio. The company's HQ sits in Bukit Jelutong, Shah Alam, with precast manufacturing on-site.",
    geology => 'Selangor terrain ranges from coastal alluvial plain along the Klang-Kapar belt to weathered granite and meta-sediment hillsides in the Klang Valley periphery (Hulu Klang, Bukit Antarabangsa, Templer Hills, Bukit Tunku). Klang Valley soft alluvial clays are 5 to 30 m thick on the coastal side and routinely require ground improvement (PVDs + preload, stone columns, or jet grouting) before MSE foundation can support tall walls.',
    agencies => 'JKR Negeri Selangor (state Public Works), MBSA (Shah Alam city council), MBSJ (Subang Jaya), MPKj (Kajang), MPS (Selayang), MPSepang, MPSP (Petaling Jaya) for local-authority projects. PLUS Expressways and LLM for highway concessions. Putrajaya Holdings and Sime Darby Property for major township developments. KTMB for the central rail corridor.',
    economic_context => 'Klang Valley is responsible for the majority of Malaysian GDP. Major active infrastructure programmes: MRT3 Circle Line, ECRL Selangor section, Pan-Borneo Highway feeder roads, KLIA Aeropolis expansion, data centre developments in Cyberjaya and Sepang corridor.',
    lai_note => 'Our oldest in-service AnchorSOL walls were built in 1999 in Selangor and remain under no measurable distress 27 years later. The Klang Valley is where the system was developed, refined, and proven, so the local engineering knowledge runs deepest here.',
    why_us_here => 'Closest delivery distance from our Bukit Jelutong manufacturing facility means lowest haulage cost. The largest concentration of completed projects means the deepest reference list for prospective clients to inspect. Most agency relationships originate here.',
    projects => '<li><b>East Klang Valley Expressway (EKVE)</b>, LLM concession, 25,000 m² of anchored MSE wall</li><li><b>NKVE Jalan Meru Link</b>, PLUS Expressways, 11,000 m²</li><li><b>Elmina Business Park 2 Phase 4B</b>, Sime Darby Property, 12,452 m²</li><li><b>Mixed Development Semenyih</b>, Duta Villa, 12,000 m²</li><li><b>Templer Hills</b>, hillside stabilization for residential platform creation</li><li><b>Bukit Antarabangsa</b>, post-landslide context hillside retention</li><li><b>Putrajaya Holdings Precinct 11</b>, 10,000 m² (counted under Putrajaya, but Selangor adjacency)</li>',
  },
  {
    slug => 'kuala-lumpur',
    name => 'Kuala Lumpur',
    type => 'federal territory',
    capital => 'Kuala Lumpur',
    cities => 'Cheras, Wangsa Maju, Ampang, Bangsar, Damansara Heights, Mont Kiara, Setiawangsa, KL Sentral, Pantai, Jalan Duta, Sungai Besi, Brickfields, Sentul, Titiwangsa, Bukit Bintang',
    context => "Kuala Lumpur is the densest infrastructure market in Malaysia by project value per square kilometre. Federal Territory walls span urban expressway interchanges, sub-track rail embankments, national-monument compounds, and drainage works on the Klang-Gombak river system.",
    geology => 'KL sits on the limestone bedrock of the Kuala Lumpur Limestone formation, with overlying alluvium along the Klang and Gombak rivers. Urban sites often have buried services, unstable historical fill, and adjacent existing structures, all of which make MSE wall foundation design demanding. Subsurface karst features (cavities, pinnacles) require additional ground investigation around the Mid Valley, Pantai, and Pudu corridors.',
    agencies => 'DBKL (Kuala Lumpur City Hall) for federal-territory authority. JKR Federal for trunk roads. LLM, Prolintas (SUKE concessionaire), Ekovest (DUKE), and Maju Holdings (KL-Putrajaya) for tolled expressways. KTMB for the central rail corridor through KL Sentral. Istana Negara and other federal compounds via JKR.',
    economic_context => 'KL hosts the federal government, the country\'s financial district, and the most dense commercial real-estate market in Malaysia. Recent and active infrastructure: MRT2 Putrajaya Line (now operational), MRT3 Circle Line (under construction), Setiawangsa-Pantai DUKE3 (operational), KVDT2 (KTMB double track upgrade), continuous Klang Valley flood-mitigation works.',
    lai_note => 'Urban KL is the most demanding site context we deliver in. Tight access, live traffic, adjacent occupied structures, and architectural finish requirements all matter. The 3 to 4 person AnchorSOL crew with no heavy vibration plant is purpose-built for urban projects where conventional RC formwork would block lanes for months.',
    why_us_here => 'Architectural facing for prestige projects (Istana Negara, government compounds). Modular construction speed for projects on tight programmes. Zero vibration plant for sites adjacent to occupied buildings. Compatibility with the elevated MRT and KTMB rail corridors that thread through the city.',
    projects => '<li><b>Duta-Ulu Klang Expressway (DUKE) Phase 2</b>, Ekovest / LLM, 22,000 m²</li><li><b>Sungai Besi-Ulu Kelang Expressway (SUKE) Package CA1</b>, Prolintas, 22,000 m²</li><li><b>Setiawangsa-Pantai Expressway (DUKE Phase 3)</b>, LLM / Ekovest, 8,200 m²</li><li><b>Istana Negara Jalan Duta</b>, the National Palace, JKR, 8,000 m²</li><li><b>KL-Putrajaya Highway Packages 3 &amp; 4</b>, LLM / Maju Holdings, 8,000 m²</li><li>KTMB sub-track retention through the central corridor</li>',
  },
  {
    slug => 'putrajaya',
    name => 'Putrajaya',
    type => 'federal territory',
    capital => 'Putrajaya',
    cities => 'Precinct 1, Precinct 2, Precinct 5, Precinct 9, Precinct 11, Precinct 14, Precinct 16, Precinct 18, Putrajaya Sentral, Diplomatic Enclave, Government Quarters',
    context => "Putrajaya is the federal administrative capital, a planned city built from 1995 onwards on what was previously palm-oil estate. AnchorSOL has delivered walls on multiple Putrajaya Holdings precincts.",
    geology => 'Putrajaya sits on the weathered granite plateau of the Selangor-Negeri Sembilan border. The site was extensively cut and filled during the 1995-2002 city construction phase, leaving substantial engineered fill across the central precincts. Retention pond walls, precinct boundary walls, and lakefront retaining works are the dominant geometry.',
    agencies => 'Perbadanan Putrajaya (Putrajaya Corporation), the federal-territory authority. Putrajaya Holdings as the master developer for new precincts. JKR Federal for trunk-road connections. LLM for the KL-Putrajaya Highway.',
    economic_context => 'Putrajaya hosts the Prime Minister\'s Department, all major federal ministries, and the diplomatic missions. Continuing development includes Precinct 5 government quarters, Precinct 9 mixed-use, lakefront retail, and the MRT2 Putrajaya Line terminus at Putrajaya Sentral.',
    lai_note => 'Putrajaya walls almost always need an architectural face. The city\'s civic-monumental aesthetic is not negotiable, and ordinary retaining-wall finishes look out of place. Our precast facing panels with cast-in textures match the urban design intent without bolt-on cladding.',
    why_us_here => 'Architectural face quality. Compatibility with the lakefront and retention-pond geometry. Speed of construction during the active development cycles. Established relationship with Putrajaya Holdings as a master developer.',
    projects => '<li><b>Putrajaya Holdings Precinct 11</b>, 10,000 m² of boundary and retention-pond walls</li><li><b>KL-Putrajaya Highway approaches</b>, LLM / Maju Holdings, 8,000 m² across Packages 3 and 4</li><li>Additional precinct boundary and retention pond walls across central Putrajaya</li>',
  },
  {
    slug => 'johor',
    name => 'Johor',
    type => 'state',
    capital => 'Johor Bahru',
    cities => 'Johor Bahru, Iskandar Puteri, Nusajaya, Pasir Gudang, Senai, Kulai, Batu Pahat, Pontian, Kluang, Muar, Mersing, Segamat, Tangkak, Kota Tinggi',
    context => "Johor's marquee programme is the Iskandar Regional Development Authority coastal corridor between Johor Bahru and Nusajaya. Marine retention, reclamation walls, township boundary walls.",
    geology => 'Johor coastline features soft marine clays 10 to 25 m thick along the Tebrau Straits, requiring ground improvement before tall MSE walls can sit on it. Inland Johor is on weathered granite and meta-sediment, more straightforward foundation conditions. The Iskandar corridor has both: alluvial coastal zones requiring stone columns or jet grouting, and uplands suitable for direct foundation.',
    agencies => 'JKR Negeri Johor for state highways and federal road works. Iskandar Regional Development Authority (IRDA) for the JB-Nusajaya corridor master planning. Johor Port Authority for Pasir Gudang and Tanjung Pelepas works. Khazanah Nasional / UEM Sunrise for major Iskandar township developments.',
    economic_context => 'Johor hosts Malaysia\'s largest cross-border economic flow with Singapore. Iskandar Malaysia is the flagship economic zone. Major active programmes: RTS Link (rail bridge to Singapore, completion 2027), JB-Singapore high-speed rail revival discussions, Forest City Phase II, Pengerang petrochemical complex.',
    lai_note => 'Coastal Johor is where we deploy marine-spec durability across the wall: Grade 40 concrete on facing panels, 75 mm cover in splash zones, heavier galvanizing on tendons, additional sacrificial-thickness allowance per BS 8006 Annex B. The marine spec is project-specific to each site\'s exposure class.',
    why_us_here => 'Marine durability competence from prior Iskandar coastal works. Container freight feasible if road delivery is constrained. Patent-protected anchored variant means specifiers committing to AnchorSOL get a single-source design without intermediate licensors.',
    projects => '<li><b>Lebuhraya Pesisiran Pantai JB-Nusajaya, Section 3</b>, Iskandar Regional Development Authority, 23,000 m²</li><li>Coastal reclamation walls along the JB-Nusajaya corridor</li><li>Township boundary walls in Iskandar Puteri, Pasir Gudang, Senai, Kulai</li><li>Federal-road retaining works in Batu Pahat, Pontian, Kluang corridors</li>',
  },
  {
    slug => 'pahang',
    name => 'Pahang',
    type => 'state',
    capital => 'Kuantan',
    cities => 'Kuantan, Pekan, Temerloh, Bentong, Raub, Maran, Jerantut, Rompin, Bera, Lipis, Cameron Highlands, Genting Highlands',
    context => "Pahang is the largest state on Peninsular Malaysia by area and AnchorSOL's marquee programme is Kuantan Port City reclamation and waterfront retention.",
    geology => 'Coastal Pahang (Kuantan, Pekan, Rompin) sits on Quaternary alluvium with marine clay layers. Inland Pahang is on the Central Belt sedimentary and meta-sedimentary rocks: limestone karst features around Jerantut and Raub, granite uplands around Bentong, peat lowlands in pockets along the Pahang River. Pahang River flood-mitigation works frequently encounter soft alluvial deposits.',
    agencies => 'JKR Negeri Pahang for state highways. East Coast Economic Region Development Council (ECERD) for the Kuantan corridor. JPS Pahang for Sungai Pahang flood works. State EPU for major investment promotions. Kuantan Port Authority for port-related infrastructure.',
    economic_context => 'Pahang hosts Kuantan Port (the main east-coast deep-water port), Gebeng petrochemical zone, and the Kuantan-Kerteh-Kemaman East Coast industrial corridor. The East Coast Rail Link (ECRL) Pahang section is under construction, requiring substantial retaining-wall infrastructure at stations and along the alignment.',
    lai_note => 'Kuantan Port City is where we built the largest single marine-spec reclamation wall in our portfolio at 14,500 m². The combination of submerged-to-tidal exposure, port loading, and very soft marine clay foundations meant ground improvement (jet grouting columns) under nearly the entire wall length.',
    why_us_here => 'Marine durability competence from Kuantan. Heavy industrial loading capability from petrochemical zone works. ECRL station and embankment retention as a major ongoing demand stream. Cameron Highlands and Genting Highlands hillside stabilization as a tourism-infrastructure niche.',
    projects => '<li><b>Kuantan Port City</b>, East Coast Economic Region Development (ECERD), 14,500 m²</li><li>Sungai Pahang flood-mitigation walls (JPS)</li><li>Federal-road retaining walls on the East Coast Highway and Karak Highway approaches</li><li>Genting Highlands hillside stabilization (selected projects)</li>',
  },
  {
    slug => 'perak',
    name => 'Perak',
    type => 'state',
    capital => 'Ipoh',
    cities => 'Ipoh, Taiping, Manjung (Lumut), Kampar, Bidor, Tapah, Sungai Siput, Kuala Kangsar, Bagan Datuk, Pangkor, Teluk Intan, Parit Buntar',
    context => "Perak hosts federal-road and JKR retaining works on the North-South Expressway corridor, state-road and township developments across Ipoh, Taiping and Manjung.",
    geology => 'Perak terrain is dominated by the Kledang and Bintang Ranges (granite uplands) flanking the Kinta Valley limestone karst. Ipoh\'s famous limestone hills present specific MSE wall foundation conditions: shallow karst cavities, pinnacled bedrock, mixed competence. The Kinta River alluvial plain has variable soft-clay layers 5 to 15 m thick.',
    agencies => 'JKR Negeri Perak for state highways and federal trunk roads. MBI (Ipoh City Council) for urban projects. State JPS for flood works on Sungai Perak and tributaries. PNB and state-linked developers for Manjung and Taiping township projects.',
    economic_context => 'Perak hosts Lumut Naval Base, Manjung industrial port, and Kinta Valley tin-mining heritage. Active programmes: Bagan Datuk port expansion, Lumut Maritime Industrial City, Ipoh-Taiping double-track rail upgrades, Bidor industrial estate.',
    lai_note => 'Perak granite and limestone quarries supply much of the crusher run used on AnchorSOL projects nationwide. The geology that gives Perak its quarries also gives its hillsides their dramatic terrain, which is exactly where anchored MSE excels at hillside cut-and-fill platform creation.',
    why_us_here => 'Local crusher run supply ex-Perak quarries (Bidor, Tapah, Tronoh). Hillside experience from Ipoh and Cameron approach roads. Long-standing JKR Perak relationship for federal-road delivery.',
    projects => '<li><b>Sultan Iskandar interchange</b>, Ipoh, on the NSE corridor</li><li><b>JKR Bandar Sri Iskandar</b> federal-road retaining wall</li><li>State-road retaining works across Taiping, Manjung and Kampar approach roads</li><li>Manjung Lumut industrial port retaining works</li>',
  },
  {
    slug => 'penang',
    name => 'Penang',
    type => 'state',
    capital => 'George Town',
    cities => 'George Town, Bayan Lepas, Butterworth, Bukit Mertajam, Air Itam, Tanjung Bungah, Tanjung Tokong, Nibong Tebal, Balik Pulau, Sungai Petani approach roads, Kepala Batas',
    context => "Penang's hilly terrain makes the state a natural fit for anchored MSE walls. Hillside stabilization across the Penang Island ridge, township retaining walls on the mainland Seberang Perai.",
    geology => 'Penang Island is dominated by the central granite ridge (Penang Hill, 833 m). Steep hillside slopes around George Town, Air Itam, Tanjung Bungah, and Balik Pulau are weathered granite with thin residual-soil cover, prone to slope failure during heavy rainfall. Seberang Perai mainland is flatter alluvial plain. Penang Bridge corridor sits on dredged marine fill over soft clay.',
    agencies => 'MBPP (Penang Island City Council) and MBSP (Seberang Perai City Council). JKR Negeri Pulau Pinang for state highways. Penang Port Authority. PDC (Penang Development Corporation) for industrial estate developments. State-level engineering departments increasingly active in hillside-development scrutiny following historic landslide events.',
    economic_context => 'Penang hosts Bayan Lepas electronics manufacturing cluster (Intel, AMD, Bosch, Osram), Penang International Airport, Penang Bridge and Sultan Abdul Halim Mu\'adzam Shah Bridge (Second Penang Bridge). Active programmes: Penang Transport Master Plan (LRT Bayan Lepas, Pan Island Link), Batu Kawan industrial expansion, Penang Silicon Design Park.',
    lai_note => 'Penang Island hillsides are the most demanding cut-and-fill platforms we deliver. The combination of steep weathered-granite slopes, intense rainfall, and adjacent occupied homes means slope-stability margin needs to be extra. Our anchored deadman engages the competent granite bedrock close behind the facing, which friction-based MSE often cannot reach on these geometries.',
    why_us_here => 'Hillside competence. Tight-access construction with no heavy vibration plant, important for sites above occupied residential streets. Architectural facing options for prestige hillside-development projects in Tanjung Bungah and Balik Pulau.',
    projects => '<li>Penang Island hill stabilisation around George Town, Air Itam and Tanjung Bungah</li><li>Seberang Perai township boundary walls around Bukit Mertajam and Butterworth</li><li>Federal road retaining works in Nibong Tebal and Balik Pulau corridor</li><li>Bayan Lepas industrial estate platform creation</li>',
  },
  {
    slug => 'kedah',
    name => 'Kedah',
    type => 'state',
    capital => 'Alor Setar',
    cities => 'Alor Setar, Sungai Petani, Kulim, Pendang, Langkawi, Anak Bukit, Baling, Sik, Yan, Pokok Sena, Padang Terap, Kuala Kedah',
    context => "Kedah hosts AnchorSOL's flagship JPS flood-mitigation programme: the Sungai Kedah / Anak Bukit works, 15,000 m² of riverine retention.",
    geology => 'Kedah is dominated by the Kedah-Perlis paddy plain (the country\'s rice-bowl), underlain by alluvial soft clays 10 to 25 m thick over limestone bedrock. The Bujang Valley archaeological corridor has additional cultural-heritage constraints on excavation. Northern Kedah transitions into the Perlis-Kedah Range with granite uplands around Baling and Sik.',
    agencies => 'JKR Negeri Kedah for state highways. JPS Kedah for Sungai Kedah, Sungai Muda, Sungai Anak Bukit flood-mitigation works. State Agriculture department for paddy-area drainage. Kulim High-Tech Park authority for industrial estate works.',
    economic_context => 'Kedah hosts Kulim Hi-Tech Park (semiconductor and electronics), Padang Terap-Naka industrial corridor, Langkawi tourism economy, and Kuala Kedah Port. Active programmes: ECRL Kedah section (under construction), Penang LRT extension to Kulim, Langkawi infrastructure upgrades, Sungai Muda flood mitigation Phase 2.',
    lai_note => 'Sungai Kedah / Anak Bukit was a stress-test for our marine-spec durability on a freshwater riverine project. Submergence cycling during the monsoon, plus the soft alluvial foundation, meant the wall had to flex with seasonal pore-pressure changes. The composite soil-steel mass of MSE handled it where a rigid RC wall would have cracked at the joints.',
    why_us_here => 'Riverine and flood-mitigation track record from JPS Kedah works. Long-distance haulage to north Peninsular is straightforward by road. ECRL Kedah station and embankment infrastructure is an ongoing opportunity.',
    projects => '<li><b>Sungai Kedah / Anak Bukit Flood Mitigation</b>, JPS Malaysia, 15,000 m²</li><li>Federal-road retaining works across Alor Setar, Sungai Petani and Pendang</li><li>State-road retention in Baling and Pendang district</li><li>Kulim Hi-Tech Park industrial estate platform creation (selected projects)</li>',
  },
  {
    slug => 'negeri-sembilan',
    name => 'Negeri Sembilan',
    type => 'state',
    capital => 'Seremban',
    cities => 'Seremban, Port Dickson, Nilai, Senawang, Bahau, Tampin, Rembau, Kuala Pilah, Jelebu, Lukut, Mantin',
    context => "Negeri Sembilan hosts the Jalan Lingkaran Tengah Seremban programme. Industrial estate walls in Senawang and Nilai, township developments around Port Dickson.",
    geology => 'Negeri Sembilan terrain transitions from the coastal alluvial plain at Port Dickson and Lukut to the granite-and-meta-sediment uplands of the Titiwangsa Range foothills around Jelebu, Kuala Pilah, and Bahau. Seremban valley has moderate-thickness alluvial deposits over weathered granite bedrock. Sungai Linggi and Sungai Muar drainage systems run through the state.',
    agencies => 'JKR Negeri Sembilan for state and federal-road works. MPS (Seremban Municipal Council), MPPD (Port Dickson Municipal Council), MPN (Nilai). State Investment Centre for industrial estate promotion. State JPS for Sungai Linggi flood works.',
    economic_context => 'Negeri Sembilan hosts the Senawang-Nilai-Tampin industrial corridor (manufacturing, logistics), KLIA Aeropolis spillover, Port Dickson Refinery and tourism. Active programmes: KL-Seremban Highway upgrades, Seremban-Port Dickson rail link discussions, Nilai industrial expansion phases.',
    lai_note => 'Negeri Sembilan industrial sites typically have predictable foundation conditions and tight programmes. Senawang and Nilai factory-pad walls are the sweet spot for anchored MSE: medium-tall (8 to 15 m), engineered platforms, hand back to follow-on trades quickly, schedule certainty.',
    why_us_here => 'Industrial platform creation competence. Proximity to Klang Valley manufacturing means short haulage. JKR Negeri Sembilan track record on federal-road retention.',
    projects => '<li><b>Jalan Lingkaran Tengah Seremban, Phase 2A</b>, JKR, 15,000 m²</li><li>Industrial estate retaining walls in Senawang and Nilai</li><li>Township developments around Port Dickson and Seremban</li><li>Lukut-Port Dickson coastal retention (selected projects)</li>',
  },
  {
    slug => 'melaka',
    name => 'Melaka',
    type => 'state',
    capital => 'Melaka',
    cities => 'Melaka Tengah, Alor Gajah, Jasin, Ayer Keroh, Bandar Hilir, Klebang, Pulau Sebang, Bukit Beruang, Krubong',
    context => "Melaka projects include federal-road retaining works on the North-South Expressway corridor, heritage-context retention near the city centre, and township boundary walls.",
    geology => 'Melaka coastline is dominated by reclaimed marine clay (Hatten, Klebang, Pulau Melaka reclamations). Inland Melaka is on weathered granite and meta-sediment foothills with moderate-thickness residual soil cover. The Sungai Melaka and Sungai Linggi drainage cross the state.',
    agencies => 'MBMB (Melaka Historic City Council) covering Melaka Tengah, MPAG (Alor Gajah), MPJ (Jasin). JKR Negeri Melaka for trunk-road works. State Heritage Board for UNESCO buffer-zone projects requiring conservation-context retention. State EPU for industrial promotion.',
    economic_context => 'Melaka hosts Melaka Historic City UNESCO heritage zone (tourism), Krubong-Hang Tuah Jaya industrial cluster, Melaka Gateway development (ongoing). Active programmes: West Coast Expressway feeder links, Melaka-Klang Valley high-speed rail proposals.',
    lai_note => 'Melaka heritage retention work requires conservation-context aesthetics. We have specified stone-masonry gravity walls and traditional crib walls on selected heritage-zone projects. The MSE wall comes out for engineered infrastructure outside the buffer zone.',
    why_us_here => 'Heritage-context architectural face options. Mixed-typology approach: MSE for engineered walls, gravity / crib for heritage replication. Proximity to Klang Valley manufacturing.',
    projects => '<li>Federal-road retaining works on the NSE Melaka section</li><li>Township boundary walls on Melaka Tengah and Alor Gajah approach roads</li><li>Heritage-context retention near the Melaka UNESCO buffer zone</li><li>Krubong industrial estate platform creation</li>',
  },
  {
    slug => 'terengganu',
    name => 'Terengganu',
    type => 'state',
    capital => 'Kuala Terengganu',
    cities => 'Kuala Terengganu, Kemaman, Dungun, Marang, Kuala Berang, Hulu Terengganu, Setiu, Besut, Paka, Pasir Raja',
    context => "Terengganu projects include East Coast Highway federal-road retaining works, coastal retention walls, and Sungai Terengganu flood-mitigation works.",
    geology => 'Terengganu coastline features sandy beach ridges over marine clay. Inland Terengganu is on the Central Belt granite-and-meta-sediment, with Sungai Terengganu cutting through to discharge near Kuala Terengganu. Tasik Kenyir reservoir backwater affects upper Sungai Terengganu hydrology. Mt Tahan extends into south Terengganu.',
    agencies => 'JKR Negeri Terengganu for state highways. JPS Terengganu for Sungai Terengganu, Sungai Kemaman, Sungai Dungun flood works. State Tourism for Pulau Redang and Pulau Perhentian infrastructure. Petronas affiliates for Kerteh-Paka petrochemical infrastructure.',
    economic_context => 'Terengganu hosts Petronas Carigali and Petronas Penapisan Terengganu (Kerteh refinery), Kemaman Supply Base, Kenyir Lake hydropower, Pulau Redang and Pulau Perhentian tourism. Active programmes: ECRL Terengganu section, East Coast Highway widening, Kemaman Port expansion.',
    lai_note => 'East Coast monsoon flooding shapes the Terengganu engineering context. Walls along Sungai Terengganu, Sungai Kemaman, Sungai Dungun need to handle annual submergence and rapid drawdown. Drainage design behind the wall is structural, not cosmetic.',
    why_us_here => 'Marine and riverine durability competence. ECRL Terengganu station and embankment retention as ongoing demand. Pahang-Terengganu axis covers eastern half of Peninsular delivery via Karak / East Coast Highway.',
    projects => '<li>East Coast Highway federal-road retaining works</li><li>Coastal retention walls along Kuala Terengganu and Kuala Berang approach roads</li><li>Sungai Terengganu flood-mitigation works in collaboration with JPS</li><li>Kerteh-Paka petrochemical infrastructure platform creation (selected projects)</li>',
  },
  {
    slug => 'kelantan',
    name => 'Kelantan',
    type => 'state',
    capital => 'Kota Bharu',
    cities => 'Kota Bharu, Pasir Mas, Tumpat, Tanah Merah, Gua Musang, Bachok, Pasir Puteh, Kuala Krai, Jeli, Machang',
    context => "Kelantan projects include federal-road retaining works on the East-West Highway corridor, Sungai Kelantan flood-mitigation walls, and JKR state-road retaining works.",
    geology => 'Kelantan coast has soft marine and estuarine deposits up to 30 m thick around Tumpat and Pasir Mas. Inland Kelantan transitions to the Central Belt with granite uplands at Gua Musang and Jeli. Sungai Kelantan flooding (severe in 2014 and recurring) shapes flood-mitigation design assumptions across the state.',
    agencies => 'JKR Negeri Kelantan for state highways and federal trunk roads. JPS Kelantan for Sungai Kelantan, Sungai Pengkalan Chepa, Sungai Golok flood works. State EPU for industrial promotion. Padi Beras Nasional Berhad (BERNAS) for paddy-area drainage.',
    economic_context => 'Kelantan economy is agriculture (paddy rice) and small-to-medium industry. Cross-border trade with southern Thailand via Rantau Panjang and Pengkalan Kubor. Active programmes: ECRL Kelantan section (under construction), East-West Highway (Gerik to Jeli to Kota Bharu) widening, Sungai Kelantan flood-mitigation Phase 3.',
    lai_note => 'Sungai Kelantan flood-mitigation walls are designed for the post-2014 flood-extreme scenario. The wall holds against full submergence during peak flood, then drains the backfill rapidly as the river recedes. Drainage capacity behind the wall is sized for once-in-25-year flood event, not just the design earth pressure.',
    why_us_here => 'Flood-mitigation engineering competence. Long-haul road delivery from Selangor to Kelantan is feasible via Karak / East-West Highway. ECRL Kelantan section as ongoing infrastructure demand.',
    projects => '<li>East-West Highway federal-road retaining works (Gerik to Jeli to Kota Bharu)</li><li>Sungai Kelantan flood-mitigation walls (JPS)</li><li>JKR state-road retaining works around Kota Bharu and Pasir Mas</li><li>Tumpat-Pengkalan Kubor cross-border infrastructure (selected projects)</li>',
  },
  {
    slug => 'perlis',
    name => 'Perlis',
    type => 'state',
    capital => 'Kangar',
    cities => 'Kangar, Padang Besar, Arau, Beseri, Simpang Ampat, Sanglang, Kuala Perlis',
    context => "Perlis is Malaysia's smallest state by area. AnchorSOL's footprint here is concentrated on federal-road retaining works around Kangar.",
    geology => 'Perlis is dominated by Mata Ayer karst limestone formations and the Perlis-Kedah granite range. Sungai Perlis and Sungai Korok flood-prone lowlands underlie the paddy plain. The Bukit Bintang-Bukit Chinta-Bukit Lagi limestone karst features rise above the plain with distinctive scarp slopes.',
    agencies => 'JKR Negeri Perlis for state and federal-road works. JPS Perlis for Sungai Perlis and Sungai Korok flood-mitigation. State EPU for cross-border trade promotion at Padang Besar. Universiti Malaysia Perlis (UniMAP) for academic-precinct infrastructure.',
    economic_context => 'Perlis is the smallest state but hosts the Padang Besar-Sadao cross-border trade gateway with Thailand. UniMAP Sungai Chuchuh campus. Active programmes: Sungai Perlis flood-mitigation, Padang Besar customs and infrastructure upgrades, Kuala Perlis ferry-terminal improvements (Pulau Langkawi feeder).',
    lai_note => 'Perlis projects are small in volume but technically interesting because of the karst limestone foundation conditions. Wall foundations need careful site investigation for cavities and pinnacled bedrock.',
    why_us_here => 'Long-distance haulage to the northernmost state remains feasible via the NSE Penang-Perlis corridor. Cross-border trade infrastructure as a niche demand stream.',
    projects => '<li>Federal-road retaining works around Kangar</li><li>JPS Perlis drainage and irrigation works on Sungai Perlis and Sungai Korok systems</li><li>Padang Besar cross-border infrastructure (selected projects)</li>',
  },
  {
    slug => 'sabah',
    name => 'Sabah',
    type => 'state',
    capital => 'Kota Kinabalu',
    cities => 'Kota Kinabalu, Sandakan, Tawau, Lahad Datu, Keningau, Tenom, Beaufort, Papar, Kudat, Semporna, Kinabatangan, Kunak, Ranau',
    context => "Sabah's challenging terrain, fault-influenced geology, and high-rainfall regime make anchored MSE the right call for hill stabilisation and riverbank retention.",
    geology => 'Sabah geology is dominated by the Crocker Range (Crocker Formation sandstone, shale, conglomerate) running parallel to the west coast. Mt Kinabalu granite massif influences the central highlands. Seismically active: the 2015 Ranau M6.0 earthquake reshaped local design coefficients. East Sabah is on the Telupid ophiolite complex and various sedimentary basins. Heavy rainfall (3,500-4,000 mm/year on the west coast) drives drainage design.',
    agencies => 'JKR Negeri Sabah and the federal JKR for trunk roads. State Public Works for state-network roads. JKAS (Jabatan Kerja Raya Sabah) Forestry and rural-road authorities. State Water Department for catchment works. Sabah Ports for Kota Kinabalu, Sandakan, Tawau port infrastructure.',
    economic_context => 'Sabah hosts Kota Kinabalu (capital), Sandakan timber and oil-palm hub, Tawau-Lahad Datu eastern industrial corridor, plus Sandakan, Sepilok, Sukau, Danum Valley ecotourism. Active programmes: Pan Borneo Highway Sabah Phase 1B (under construction, $3 billion+), Sabah Ammonia Urea project, KK Sentral mixed-use development.',
    lai_note => 'Sabah projects use elevated seismic coefficient (kh = 0.10 to 0.15) versus the peninsular standard (0.05 to 0.10). The composite soil-steel mass of our anchored MSE yields elastically through seismic events and recovers, where rigid RC cantilever cracks at the rebar-concrete interface. Sabah is where the seismic-performance argument for MSE becomes a deal-decider.',
    why_us_here => 'Seismic competence. Hillside engineering experience translates directly to the Crocker Range terrain. Container freight from Selangor to Kota Kinabalu, Sandakan, and Tawau ports is established. Pan Borneo Highway Phase 1B is a multi-year demand stream.',
    projects => '<li>Kota Kinabalu hill stabilisation projects</li><li>Sandakan federal-road retention works</li><li>JKR Sabah road network retaining structures</li><li>Tawau coastal and port infrastructure walls</li><li>Pan Borneo Highway Sabah Section retaining works</li>',
  },
  {
    slug => 'sarawak',
    name => 'Sarawak',
    type => 'state',
    capital => 'Kuching',
    cities => 'Kuching, Sibu, Miri, Bintulu, Sri Aman, Sarikei, Limbang, Mukah, Lawas, Kota Samarahan, Serian, Sematan, Bau',
    context => "Sarawak is Malaysia's largest state by area. AnchorSOL projects run on the Pan Borneo Highway corridor and on state-government and federal-road retaining works around major cities.",
    geology => 'Sarawak geology spans the Crocker Formation sandstones in the west (Kuching, Serian), the central Belaga Formation sedimentary basin (Sibu, Bintulu), and the eastern Limbang area on diverse meta-sediment and igneous rocks. Coastal Sarawak features mangrove and peat-swamp lowlands up to 10 m thick (especially Sibu and the Rajang delta), requiring substantial ground improvement. Heavy rainfall (3,500-5,000 mm/year) drives all engineering.',
    agencies => 'JKR Negeri Sarawak for state and federal roads. State Government direct for major Sarawak-specific projects (Sarawak has more autonomy than other states). Petronas LNG and Sarawak Energy for Bintulu industrial infrastructure. State Department of Drainage and Irrigation. JKR Sarawak Forestry roads.',
    economic_context => 'Sarawak hosts Kuching (capital, services), Sibu (timber + rice), Miri (oil and gas + tourism), Bintulu (Petronas LNG Complex, Asean\'s largest LNG export terminal). Active programmes: Pan Borneo Highway Sarawak Phase 1 (under construction, $4 billion+), Sarawak Coastal Road, Sarawak Second Trunk Road, hydropower expansion (Bakun, Murum, Baleh), Kuching urban transit network.',
    lai_note => 'Sarawak peat-swamp foundations are the most demanding ground conditions in our portfolio. Peat compresses indefinitely under load; you can\'t MSE on peat directly. Standard solution: full peat removal where shallow (less than 3 m), piled foundation with load-transfer platform where deep. Sarawak Pan Borneo Highway has both.',
    why_us_here => 'Long-haul container freight from Selangor to Kuching, Sibu, Bintulu, Miri ports is established. Pan Borneo Highway Sarawak as multi-year demand stream. Bintulu LNG complex infrastructure as specialist niche. Hydropower-access road retention as a niche.',
    projects => '<li><b>Pan Borneo Highway (Sarawak section)</b> retaining works</li><li>Kuching, Sibu, Miri and Bintulu federal-road retention</li><li>JKR Sarawak state-network retaining structures</li><li>Petronas LNG and oil-and-gas infrastructure walls in Bintulu</li><li>Sarawak Coastal Road retaining wall infrastructure</li>',
  },
  {
    slug => 'labuan',
    name => 'Labuan',
    type => 'federal territory',
    capital => 'Victoria',
    cities => 'Victoria (Bandar Labuan), Labuan town, Patau-Patau, Kerupang, Sungai Lada, Layang-Layangan, Pohon Batu',
    context => "Labuan, the federal island territory off the Sabah coast, hosts coastal infrastructure and federal-territory road retaining works.",
    geology => 'Labuan island geology is the Belait Formation sandstone with thin coastal alluvium. The island is moderately hilly toward the centre. Marine clay deposits in coastal flats around the airport and Patau-Patau. Heavy rainfall (3,500 mm/year) drives drainage.',
    agencies => 'Labuan Corporation (federal-territory authority). JKR Federal for trunk roads. Labuan Port Authority. Labuan Financial Services Authority for offshore financial centre infrastructure. Petronas affiliates for Labuan oil-and-gas service base.',
    economic_context => 'Labuan hosts the Labuan International Business and Financial Centre, Labuan Shipyard (Petronas), oil-and-gas service base for South China Sea operations, and Labuan Free Trade Zone. Active programmes: deepwater port expansion, oil-and-gas terminal upgrades, financial-centre infrastructure.',
    lai_note => 'Labuan projects require marine durability spec given the island context. Container freight from Selangor via Labuan port. Demand is concentrated in oil-and-gas service-base infrastructure and federal-territory road works.',
    why_us_here => 'Marine durability. Container delivery network. Federal-territory contract familiarity from Putrajaya and KL work.',
    projects => '<li>Coastal infrastructure retention walls</li><li>Federal-territory road retaining works</li><li>Petronas Labuan Shipyard infrastructure retaining works (selected)</li>',
  },
);

# Standard tabbar + footer
sub render_tabbar_and_footer {
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

sub render_page {
  my ($s) = @_;
  my $url = "https://anchorsolwall.com/locations/$s->{slug}/";
  my $name = $s->{name};
  my $type = $s->{type};
  my $cap = $s->{capital};
  my $is_east_my = ($s->{slug} =~ /^(sabah|sarawak|labuan)$/);
  my $delivery_note = $is_east_my ? "by container freight to East Malaysia ports" : "by road on the Peninsular network";
  my $seismic_note = ($s->{slug} =~ /^(sabah|sarawak)$/) ? "elevated seismic coefficient kh = 0.10 to 0.15 (post-2015 Ranau earthquake codification)" : "standard peninsular seismic coefficient kh = 0.05 to 0.10";

  my $title = "MSE Wall $name | RE / RS / RC Retaining Wall Contractor $name | AnchorSOL®";
  my $desc = "MSE wall in $name. Anchored MSE, Reinforced Earth (RE) wall, Reinforced Soil (RS) wall, RC retaining wall contractor serving $name. $s->{context}";

  my $kw = "MSE wall $name, MSE wall contractor $name, Mechanically Stabilized Earth wall $name, Anchored MSE wall $name, RE wall $name, Reinforced Earth wall $name, RS wall $name, Reinforced Soil wall $name, RC wall $name, RC retaining wall $name, Reinforced concrete retaining wall $name, Retaining wall $name, Retaining wall contractor $name, Hillside retaining wall $name, Slope retaining wall $name, Bridge abutment $name, AnchorSOL $name, MSE wall $cap, Retaining wall $cap";

  my $h1 = "MSE wall, RE wall, RS wall, RC wall contractor in $name.";

  my $lede = qq|<p class="article__lede">If you are scoping a retaining wall project in <b>$name</b>, this page is the engineer's brief. AnchorSOL® has delivered MSE walls (anchored variant and friction-based), Reinforced Earth walls (RE), Reinforced Soil walls (RS), and consulted on RC retaining walls across $name for over two decades. $s->{context} What follows is the state-specific engineering context, the cities we have worked across, the agencies that specify us, the projects already in service, and how to procure for your $name project.</p>|;

  my $faq1q = "Who is the No.1 MSE wall contractor in $name?";
  my $faq1a = "AnchorSOL\xC2\xAE Wall Sdn. Bhd. is the most-specified MSE wall contractor in $name as part of a national portfolio of 500+ named projects and 1,000,000+ square metres of wall delivered since 1999. Specified by JKR, LLM, PLUS, KTMB, JPS, and major state agencies. " . substr($s->{lai_note}, 0, 200);
  $faq1a =~ s/"/\\"/g;

  my $faq2q = "What wall types do you build in $name?";
  my $faq2a = "All retaining-wall families: anchored MSE walls (AnchorSOL\xC2\xAE system, our specialty), Reinforced Earth walls (RE, the original Henri Vidal 1963 system and modern friction-based variants), Reinforced Soil walls (RS, geogrid + modular block), RC retaining walls (cantilever, gravity, counterfort) for short walls or basement integration, plus crib walls and gabion walls where appropriate. For $name specifically, our anchored MSE wall is the most-common choice because of $s->{why_us_here}.";
  $faq2a =~ s/"/\\"/g;

  my $faq3q = "How do I procure MSE wall services for a project in $name?";
  my $faq3a = "Send the project brief (location within $name, wall height range, application type, soil report if available) via WhatsApp +60 12-236 2159 or email lai\@anchorsolwall.com. Same-day response with indicative scope, programme, and cost band. Delivery from our Selangor manufacturing facility $delivery_note.";
  $faq3a =~ s/"/\\"/g;

  # Page body
  my $body = qq|
<section>
<h2>The local engineering context, $name</h2>
<p><b>Geology and terrain.</b> $s->{geology}</p>
<p><b>Economic and infrastructure context.</b> $s->{economic_context}</p>
<p><b>Why anchored MSE fits $name.</b> $s->{why_us_here}</p>
<p class="article__field-note" style="border-left:3px solid var(--amber); padding:14px 20px; margin:20px 0; background:rgba(255,255,255,.03); color:var(--ink);">$s->{lai_note}</p>
</section>

<section>
<h2>What we build in $name, by wall type</h2>

<h3>Anchored MSE wall (AnchorSOL® system, our specialty)</h3>
<p>The cost-efficient default for most $name retaining walls above 5 metres. Our anchored mechanism terminates each tendon at a discrete deadman block, with pullout resistance from passive earth pressure on the block rather than friction along the strip. The system runs on locally-sourced crusher run at ≥34° friction angle, saving 30 to 50% on backfill cost versus friction-based MSE that requires premium granular fill at ≥36°. For $name, the local backfill economics typically favour the anchored variant strongly. <a href="../../learn/what-is-mse-wall.html">Read the MSE wall pillar guide →</a></p>

<h3>Reinforced Earth wall (RE wall)</h3>
<p>The original Vidal Reinforced Earth system (Terre Armée, 1963) and modern friction-based variants. Steel-strip or geogrid reinforcement, granular sand backfill, cruciform or rectangular precast facing. We deliver RE walls in $name where the project budget commits to premium granular fill, the design standard requires the Vidal-style strip variant specifically, or the friction-based reach is preferred for the geometry. <a href="../../learn/reinforced-earth-wall.html">Read the RE wall guide →</a></p>

<h3>Reinforced Soil wall (RS wall)</h3>
<p>Modern variants: HDPE punched-and-drawn geogrid, PET woven geogrid, welded steel wire mesh, polymeric strip composites. Often paired with modular segmental retaining wall (SRW) block facing for residential and amenity walls in $name. RS variants suit medium-height walls in residential and township applications. <a href="../../learn/reinforced-soil-wall.html">Read the RS wall guide →</a></p>

<h3>RC retaining wall (cantilever, gravity, counterfort)</h3>
<p>For short walls below 3 metres, basement walls integrating with building structures, water-retaining structures, and architectural cantilever walls where RC is the right answer, we provide design consultation. Above 5 metres of wall height, MSE almost always beats RC on cost for $name projects (typical RM 1,200-1,700 per m² for MSE versus RM 1,800-2,800 per m² for RC at 10 m height). <a href="../../learn/rc-retaining-wall-design.html">Read the RC wall design guide →</a></p>

<h3>Crib walls and gabion walls (selected applications)</h3>
<p>For very short walls in landscape contexts, riverbank protection, slope-toe walls, or remote-access sites in $name, we also specify and supply crib walls and gabion walls. Less than 5% of our $name portfolio but the right answer for the right project (typically heritage-context, conservation, or low-engineering applications).</p>
</section>

<section>
<h2>Cities in $name where AnchorSOL® has delivered</h2>
<p>From the state capital <b>$cap</b> through to outlying districts, our project footprint in $name spans:</p>
<p>$s->{cities}.</p>
<p>Each project carries the same design and construction standard regardless of city: full BS 8006-1:2010 / FHWA NHI-10-024 / JKR Standard Specification compliance, modular precast facing, hand-or-mini-compactor backfill within 1 m of the facing, geocomposite or granular drainage layer with toe collection pipe, monitoring instrumentation on critical structures.</p>
</section>

<section>
<h2>Marquee $name projects</h2>
<ul>
$s->{projects}
</ul>
<p><a href="../../projects/">Browse the full 500+ project portfolio →</a></p>
</section>

<section>
<h2>$name agencies and approving authorities</h2>
<p>$s->{agencies}</p>
<p>For procurement teams: our standard pre-qualification documentation covers CIDB G7 registration, ≥10 named MSE wall projects, professional engineer (Ir. BEM) leading the design team, ISO 9001:2015 quality system, in-house manufacturing certification, financial standing per project value, full insurance (Professional Indemnity + Public Liability + Workmen's Compensation) per the project value bands.</p>
</section>

<section>
<h2>Specifying retaining walls for $name projects</h2>
<p>Tender clauses we recommend for $name retaining-wall projects:</p>
<ul>
<li><b>Design standards</b>: BS 8006-1:2010 (primary), FHWA NHI-10-024 (parametric reference), JKR Standard Specification (materials and workmanship). For $name, use $seismic_note.</li>
<li><b>Backfill spec</b>: anchored MSE allows crusher run at ≥34° friction angle; friction-based MSE requires premium granular at ≥36°. Locally-sourced crusher run typically meets the anchored spec at $name quarry rates.</li>
<li><b>Concrete grade</b>: Grade 30 minimum for inland walls per BS 8500 exposure class XC2/XC3; Grade 35 to 40 for coastal or aggressive environments per XS2/XS3.</li>
<li><b>Reinforcement</b>: hot-dip galvanized carbon-steel deformed bar to BS 4449 + BS EN ISO 1461. BS 8006 Annex B sacrificial-thickness allowance built into the section for the specified 75 to 120 year design life.</li>
<li><b>Pre-qualification</b>: CIDB G7 minimum, ≥10 named MSE wall projects, Ir. BEM design engineer, ISO 9001, in-house manufacturing. Detailed pre-qualification clauses in <a href="../../learn/mse-wall-specification-template.html">our 8-section spec template</a>.</li>
</ul>
</section>

<section>
<h2>Procuring AnchorSOL® for $name</h2>
<ol>
<li><b>Brief us.</b> Send project location within $name, wall height range, application (highway, hillside, bridge, marine, township, industrial), soil report if available, target programme. Via <a href="https://wa.me/60122362159?text=Hi%20AnchorSOL%2C%20project%20enquiry%20in%20$s->{slug}.">WhatsApp +60 12-236 2159</a> or <a href="mailto:lai\@anchorsolwall.com">lai\@anchorsolwall.com</a>.</li>
<li><b>Same-day response.</b> Indicative scope, programme, and cost band from the engineering team within hours.</li>
<li><b>Formal design submission.</b> Once awarded, full design calculations, drawings, method statement, materials specifications, and quality plan within 2 to 4 weeks.</li>
<li><b>Manufacture and delivery.</b> Precast panels cast in our Selangor facility, deadman blocks fabricated in-house, tendons cut and galvanised to spec. Delivery $delivery_note.</li>
<li><b>Installation and handover.</b> 3-4 person trained erection crew, no heavy vibration plant on site. Monitoring instrumentation installed per the design, with baseline readings handed to the asset owner at practical completion.</li>
</ol>
<p><a class="btn btn--p" href="https://wa.me/60122362159?text=Hi%20AnchorSOL%2C%20project%20enquiry%20in%20$s->{slug}." target="_blank" rel="noopener">WhatsApp a brief from $name →</a>  <a class="btn btn--g" href="../../#contact">All contact details</a></p>
</section>
|;

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
<meta property="og:site_name" content="AnchorSOL® Wall" />
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
     "alternateName": ["Anchored MSE wall $name", "Mechanically Stabilized Earth wall $name", "RE wall contractor $name", "RS wall contractor $name", "RC retaining wall consultation $name", "Retaining wall contractor $name", "Hillside retaining wall contractor $name"],
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
    <span class="wm"><span>ANCHORSOL<sup>®</sup></span><small>WALL SYSTEMS · EST. 1999</small></span>
  </a>
</div></div></header>

<main id="main" class="article">
<div class="wrap article__wrap">

<nav class="breadcrumb" aria-label="Breadcrumb">
  <a href="../../">Home</a> <span>·</span> <a href="../">Locations</a> <span>·</span> <span>$name</span>
</nav>

<article>
<header class="article__head">
  <span class="article__tag">Location reference, $name</span>
  <h1>$h1</h1>
  $lede
  <p class="article__meta">By <b>AnchorSOL® Wall Sdn. Bhd.</b> &middot; Engineering reference &middot; ~10 min read</p>
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
      <span class="kb-card__cta">See locations index →</span>
    </a>
    <a class="kb-card" href="../../contractor/">
      <span class="kb-card__tag">Contractor</span>
      <h3>MSE wall contractor reference</h3>
      <p>Malaysia's No.1 MSE wall contractor. Anchored MSE, RE wall, RS wall, RC wall design and build.</p>
      <span class="kb-card__cta">Read contractor reference →</span>
    </a>
    <a class="kb-card" href="../../projects/">
      <span class="kb-card__tag">Portfolio</span>
      <h3>500+ named projects</h3>
      <p>Every wall in the delivered portfolio. JKR, PLUS, LLM, KTMB, Putrajaya, Iskandar, Padma Bridge.</p>
      <span class="kb-card__cta">Browse portfolio →</span>
    </a>
  </div>
</aside>

</div>
</main>
HTML

  $html .= render_tabbar_and_footer();
  return $html;
}

# Generate all pages, writing as raw bytes (no :utf8 layer) so the inline
# Unicode literals (already valid UTF-8 in source) write through cleanly.
for my $s (@states) {
  my $dir = "$out_dir/$s->{slug}";
  make_path($dir) unless -d $dir;
  my $path = "$dir/index.html";
  open my $out, '>:raw', $path or die "write $path: $!";
  my $html = render_page($s);
  # Encode to UTF-8 bytes
  utf8::encode($html);
  print $out $html;
  close $out;
  print "OK    locations/$s->{slug}/index.html\n";
}

print "\nDone. " . scalar(@states) . " state pages regenerated with quality content + correct UTF-8.\n";
