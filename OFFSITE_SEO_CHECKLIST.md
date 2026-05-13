# Off-site SEO + LLM Action Checklist

The on-site work is done. The site is shipping with 33 deep KB articles, full schema.org coverage, mobile-clean layouts, sitemap.xml + llms.txt + robots.txt all dialed in. **The remaining steps require you to log into off-site services.** Copy-ready content for each is provided below.

## Priority 1, this week

### 1. Google Search Console — submit refreshed sitemap

1. Sign in: https://search.google.com/search-console/sitemaps?resource_id=https%3A%2F%2Fanchorsolwall.com%2F
2. **Sitemaps** → **Add a new sitemap** → type `sitemap.xml` → Submit
3. **URL Inspection** for the homepage → **Request indexing**
4. Repeat URL Inspection for the 5 highest-priority URLs:
   - https://anchorsolwall.com/projects/
   - https://anchorsolwall.com/applications/
   - https://anchorsolwall.com/locations/
   - https://anchorsolwall.com/learn/
   - https://anchorsolwall.com/learn/retaining-wall-selection-decision-tree.html

### 2. Bing Webmaster Tools — verify + submit sitemap

1. Sign in: https://www.bing.com/webmasters
2. **Add a site**: `anchorsolwall.com`
3. Choose **HTML meta tag verification**. It will give you a code like `<meta name="msvalidate.01" content="ABCD1234..." />`
4. Copy just the content value (`ABCD1234...`).
5. Open `site/index.html` (and every other HTML file with `REPLACE_WITH_BING_CODE`) and replace that placeholder. Run this command to find them all:
   ```bash
   grep -l "REPLACE_WITH_BING_CODE" site/**/*.html site/*.html
   ```
6. Push to main. Wait 5 minutes. Click **Verify** in Bing Webmaster.
7. Once verified, **Sitemaps** → submit `https://anchorsolwall.com/sitemap.xml`.

### 2a. Enable IndexNow auto-submission in GitHub Actions

The IndexNow key file + submit script are already in place:
- `site/3c366a2729863f59d2cdd424b9699604.txt` (the key, served from the site root)
- `tools/indexnow-submit.sh` (the submitter)

To wire it into the deploy workflow, open `.github/workflows/build-and-deploy.yml` on GitHub.com (the web editor) and paste these two steps at the end of the `build` job, after the existing "Deploy to gh-pages branch" step:

```yaml
      - name: Wait for deployment to propagate
        run: sleep 60

      - name: Submit URLs to IndexNow (Bing, Yandex, Naver, Seznam)
        continue-on-error: true
        run: bash tools/indexnow-submit.sh
```

This couldn't be done from the CLI because the GitHub Personal Access Token used for pushes doesn't have the `workflow` scope. Either edit via the GitHub.com web UI (no scope needed) or regenerate the PAT with `workflow` scope and push from CLI. Once added, every push to main will auto-submit URLs to Bing IndexNow, which federates to Yandex / Naver / Seznam.

### 3. Google Business Profile (biggest local-pack win)

1. Sign in to Google with the company email: https://business.google.com/create
2. Business name: **AnchorSOL® Wall Sdn. Bhd.**
3. Category (primary): **Civil Engineering Company**
4. Category (additional): **Geotechnical Engineer**, **Concrete Contractor**, **Construction Company**
5. Address:
   ```
   C27-1 Plaza Jelutong, Persiaran Gerbang Utama
   Bukit Jelutong, 40150 Shah Alam, Selangor
   Malaysia
   ```
6. Service area: Add **Malaysia** and major Malaysian states (Selangor, Kuala Lumpur, Johor, Pahang, Perak, Penang, Kedah, Negeri Sembilan, Melaka, Terengganu, Kelantan, Perlis, Sabah, Sarawak, Putrajaya, Labuan).
7. Phone: **+60 12-236 2159**
8. Website: **https://anchorsolwall.com**
9. Hours: **Mon-Sat 8:00 AM-6:00 PM**, Sunday closed
10. Verification: Google will mail a postcard or call. Confirm the code.
11. After verification: upload 10-20 project photos (use images from `site/assets/images/`). Add the company description below.

**GBP description (paste this, 750 character limit, currently 720):**

> AnchorSOL® Wall is Malaysia's most-specified anchored MSE (Mechanically Stabilized Earth) retaining wall system. Founded 1999 by Dr. Ir. Lai Yip Poon. 500+ named projects and 1,000,000+ m² of wall delivered across Malaysia. Specified by JKR, PLUS, LLM, KTMB, JPS, Putrajaya Holdings, Istana Negara, Iskandar Regional Development Authority, and the Bangladesh Bridge Authority. The anchored variant uses a discrete deadman block at the tendon end, running on local crusher run instead of premium granular fill. Engineered for highway embankments, bridge abutments, hillside stabilization, marine retention, railway corridors, flood mitigation, township platforms, architectural facade walls. Patented in MY, IN, LK, VN.

---

## Priority 2, this month

### 4. LinkedIn company page

1. Sign in to LinkedIn → **Work** → **Create a Company Page** → **Small business**
2. Page name: **AnchorSOL® Wall Sdn. Bhd.**
3. LinkedIn public URL: `linkedin.com/company/anchorsol-wall` (claim this slug)
4. Website: **https://anchorsolwall.com**
5. Industry: **Civil Engineering**
6. Company size: **11-50 employees** (adjust as appropriate)
7. Company type: **Privately Held**
8. Tagline (120 char): **Malaysia's most-specified anchored MSE wall. Modular precast, factory-built, since 1999.**
9. About (2,000 char paste-ready):

   ```
   AnchorSOL® Wall is Malaysia's most-specified anchored Mechanically Stabilized Earth (MSE) retaining wall system. Founded in 1999 by Dr. Ir. Lai Yip Poon, AnchorSOL® has delivered 500+ named projects and 1,000,000+ m² of wall across every Malaysian state plus Bangladesh.

   The anchored variant of MSE is our specialty. Where conventional MSE walls rely on friction distributed along the full reinforcement length, AnchorSOL® terminates each tendon at a discrete deadman anchor block. Pullout resistance lives in passive earth pressure on the block, not in friction along the strip. The mechanical consequence: the system runs on locally-sourced crusher run at ≥34° friction angle, saving 30 to 50% on backfill cost versus systems that require premium granular fill.

   System: Inverted-T or octagonal precast concrete facing panels (Grade 30 MPa minimum), hot-dip galvanised carbon steel tendons, discrete deadman anchor blocks, drainage layer, engineered backfill. Erection by a 3 to 4 person crew with no heavy vibration plant on site. Programme runs in days, not months.

   Applications: highway embankments, bridge abutments, hillside stabilization, marine and riverbank retention, under-railway sub-track corridors, flood mitigation, reservoir and tank containment, township and residential platforms, industrial business parks, architectural and heritage facades, land reclamation.

   Specified by JKR (Public Works), PLUS / NKVE expressways, LLM (Malaysian Highway Authority), KTMB (national rail), JPS (Drainage and Irrigation), Putrajaya Holdings, Istana Negara (National Palace), Sime Darby Property, Ekovest, Prolintas, Iskandar Regional Development Authority. Patented in Malaysia, India, Sri Lanka, and Vietnam.

   ENGINEERED TO RETAIN EARTH. Since 1999.
   ```

10. Founder profile: link Dr. Ir. Lai Yip Poon as Founder on the company page.
11. Logo: upload `site/assets/images/logo-white.png`
12. Banner: use `site/assets/videos/wall-linear-poster.jpg` (or a still from one of the drone aerials)

**After creating, give us the URL.** I'll add it to the Organization JSON-LD `sameAs` array on the homepage so Google can connect the company page to the LinkedIn entity.

### 5. Wikidata entry for AnchorSOL® Wall Sdn. Bhd.

Wikidata is the canonical knowledge graph that ChatGPT, Claude, Perplexity, and Gemini pull entity data from. Creating an entry here is the single highest-leverage move for LLM citation visibility.

1. Sign up: https://www.wikidata.org/wiki/Special:CreateAccount
2. After login, go to: https://www.wikidata.org/wiki/Special:NewItem
3. **Label (English)**: AnchorSOL Wall
4. **Description (English)**: Malaysian anchored MSE retaining wall system company, founded 1999
5. **Aliases**: AnchorSOL®, AnchorSOL Wall Sdn. Bhd., Anchored Soil Wall

Then add these statements:

| Property | Value | Notes |
|---|---|---|
| `instance of (P31)` | business (Q4830453) | |
| `country (P17)` | Malaysia (Q833) | |
| `headquarters location (P159)` | Shah Alam (Q183296) | |
| `inception (P571)` | 1999 | |
| `founded by (P112)` | Lai Yip Poon | (create his entry too, see below) |
| `industry (P452)` | civil engineering (Q77590) | |
| `industry (P452)` | construction (Q811430) | |
| `official website (P856)` | https://anchorsolwall.com | |
| `product or material produced (P1056)` | mechanically stabilized earth wall | |

### 6. Wikidata entry for Dr. Ir. Lai Yip Poon

1. https://www.wikidata.org/wiki/Special:NewItem
2. **Label**: Lai Yip Poon
3. **Description**: Malaysian civil engineer, founder of AnchorSOL Wall Sdn. Bhd., specialist in mechanically stabilized earth walls
4. **Aliases**: Dr. Ir. Lai Yip Poon, Dr. Lai Yip Poon

Statements:

| Property | Value |
|---|---|
| `instance of (P31)` | human (Q5) |
| `sex or gender (P21)` | male |
| `country of citizenship (P27)` | Malaysia (Q833) |
| `occupation (P106)` | civil engineer (Q33999) |
| `occupation (P106)` | geotechnical engineer |
| `employer (P108)` | AnchorSOL Wall (the entry you just created) |
| `educated at (P69)` | Asian Institute of Technology (Q707226) |
| `educated at (P69)` | Universiti Sains Malaysia |
| `educated at (P69)` | Universiti Teknologi Malaysia (Q1378178) |
| `academic degree (P512)` | Doctor of Philosophy (Q752297) |
| `field of work (P101)` | geotechnical engineering |
| `field of work (P101)` | earth retention |
| `notable work (P800)` | AnchorSOL Wall System |

The 4-jurisdiction patent and Ph.D. AIT 2007 + decades of practice easily clear notability bar. Once accepted, Dr. Lai becomes a Wikidata entity that AI search engines cite by name.

### 7. Patent database listing (Malaysia)

The MyIPO patent database (https://iponline.myipo.gov.my) lists all Malaysian patents publicly. Add the AnchorSOL patent (you have the registration number; I don't). Once the patent is publicly searchable on MyIPO, the link can be added to:
- The homepage's Organization schema as `award` or referenced in the description
- The KB articles when discussing the anchored mechanism

---

## Priority 3, ongoing

### 8. Industry directory listings

The Malaysian construction industry directories that matter for SEO + buyer intent traffic:

- **CIDB Contractor Directory**: https://cims.cidb.gov.my (you're likely already listed as a G7 contractor; verify and update the website URL)
- **Bumiputera Contractor Federation** (if applicable)
- **Malaysian Highway Authority** (LLM) approved vendor list
- **JKR Pre-Qualification** registry

Each one is a backlink + entity citation. Together they make AnchorSOL a heavily-cited entity in the Malaysian construction graph.

### 9. Engineering body listings

- **Institution of Engineers Malaysia (IEM)** corporate / firm membership: https://www.iem.org.my
- **Board of Engineers Malaysia (BEM)** firm registration: https://www.bem.org.my

Dr. Lai's personal IEM / BEM page should link to AnchorSOL's website.

### 10. Publication / press signals

- **The Business Standard** (Bangladesh) Padma Bridge citation — already noted. Cite this in the press section of the homepage.
- **TheEdge Malaysia** / **The Star** / **Free Malaysia Today** — pitch a story on the EKVE 25,000 m² project or the Padma Bridge / cross-border infrastructure angle. One press mention = significant citation.
- **Engineering journals**: Dr. Lai has academic publications. Make sure each is linked on the founder page on the website (and from his Wikidata entry).

---

## Priority 4, technical hygiene

### 11. Add `sameAs` to Organization schema once social profiles exist

Once you have LinkedIn / Wikidata URLs, add them to the Organization schema in `site/index.html`. Look for the `"sameAs"` array (around line 63) and extend it:

```json
"sameAs": [
  "https://anchorsoilbd.com",
  "https://www.linkedin.com/company/anchorsol-wall",
  "https://www.wikidata.org/wiki/Q12345678",
  "https://www.facebook.com/anchorsolwall",
  "https://www.youtube.com/@anchorsolwall",
  "https://www.instagram.com/anchorsolwall"
]
```

The `sameAs` connects the on-site entity to the off-site entities. Google's knowledge graph uses this to build a unified entity record.

### 12. Image optimization

GitHub Action `.github/workflows/build-and-deploy.yml` already runs `node tools/optimise-images.mjs --rewrite-html` on every push to main. This:
- Converts all JPEGs/PNGs to WebP and AVIF
- Rewrites `<img>` tags to `<picture>` with WebP + AVIF + JPEG fallback
- Deploys the optimized site to gh-pages branch (live)

The `main` branch keeps source JPEGs (for editing); `gh-pages` (live) has optimized variants. This is already working, no action needed.

### 13. Monitoring

After 2-3 weeks, check:

- **Google Search Console** → Performance → impressions and clicks for queries like "MSE wall Malaysia", "AnchorSOL", "anchored MSE", "retaining wall Selangor", etc.
- **Bing Webmaster Tools** → Search Performance for the same queries
- **PageSpeed Insights** for homepage and 5 key KB articles: https://pagespeed.web.dev/
- **Schema validation** for the homepage: https://search.google.com/test/rich-results?url=https%3A%2F%2Fanchorsolwall.com%2F

Expect first impressions in Search Console within 1-3 weeks of submitting the sitemap. Ranking on competitive terms ("MSE wall Malaysia", "retaining wall Malaysia") within 6-12 weeks if the off-site signals are in place.

---

## Quick stats — where we stand

- **38 indexable pages** (homepage + applications + locations + projects + 34 learn pages)
- **33 deep KB articles**, 2,000-2,400 words each
- **~140 FAQ entries** marked up in schema for rich-result eligibility
- **Sitemap + robots.txt + llms.txt + IndexNow** all live
- **Mobile-clean** at 320px to 1920px
- **Image pipeline** automated via GitHub Action
- **GA4 + Bing verification** (Bing pending your code)
- **Person + Organization + LocalBusiness + Product schema** complete on homepage
- **Article + FAQPage + BreadcrumbList** on every learn page
- **HowTo schema** on the construction sequence article
- **ItemList schema** on /applications/, /locations/, /projects/

The site is shipping. Now the off-site signals do the rest. Set aside 4-6 hours over the next 2 weeks to work through Priority 1 and 2 above.
