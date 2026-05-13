#!/usr/bin/env bash
# Submit the current sitemap URLs to IndexNow (Bing, Yandex, Naver, Seznam).
# Run this after each push to main to nudge Bing/Yandex to re-crawl quickly.
# IndexNow API key: 3c366a2729863f59d2cdd424b9699604 (also at /3c366a2729863f59d2cdd424b9699604.txt)
#
# Usage:
#   bash tools/indexnow-submit.sh
#
# Documentation: https://www.indexnow.org/documentation

set -euo pipefail

KEY="3c366a2729863f59d2cdd424b9699604"
HOST="anchorsolwall.com"
KEY_LOCATION="https://${HOST}/${KEY}.txt"

# Pull URLs from sitemap.xml (live)
SITEMAP_URL="https://${HOST}/sitemap.xml"
URLS=$(curl -sf "${SITEMAP_URL}" | grep -oE '<loc>[^<]+</loc>' | sed -E 's|</?loc>||g')

if [ -z "$URLS" ]; then
  echo "ERROR: Could not fetch URLs from $SITEMAP_URL"
  exit 1
fi

# Build a JSON array of URLs
JSON_URLS=$(echo "$URLS" | awk 'BEGIN{printf "["} NR>1{printf ","} {printf "\"%s\"", $0} END{printf "]"}')

PAYLOAD=$(cat <<EOF
{
  "host": "${HOST}",
  "key": "${KEY}",
  "keyLocation": "${KEY_LOCATION}",
  "urlList": ${JSON_URLS}
}
EOF
)

echo "Submitting $(echo "$URLS" | wc -l) URLs to IndexNow..."

# Bing IndexNow endpoint (Yandex, Naver, Seznam all federate from this)
curl -X POST "https://api.indexnow.org/IndexNow" \
  -H "Content-Type: application/json; charset=utf-8" \
  -d "$PAYLOAD" \
  --silent --show-error --fail \
  && echo "OK: IndexNow submission accepted" \
  || echo "FAIL: IndexNow submission failed"
