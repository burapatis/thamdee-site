#!/usr/bin/env bash
# ทดสอบว่า Cloudflare API token + account id + site_tag ใช้งานได้
# ใช้: CLOUDFLARE_API_TOKEN=... CLOUDFLARE_ACCOUNT_ID=... CLOUDFLARE_WEB_ANALYTICS_SITE_TAG=... bash scripts/test-cf-analytics.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

: "${CLOUDFLARE_API_TOKEN:?ตั้ง CLOUDFLARE_API_TOKEN}"
: "${CLOUDFLARE_ACCOUNT_ID:?ตั้ง CLOUDFLARE_ACCOUNT_ID}"
: "${CLOUDFLARE_WEB_ANALYTICS_SITE_TAG:?ตั้ง CLOUDFLARE_WEB_ANALYTICS_SITE_TAG}"

utc_now() {
  date -u +"%Y-%m-%dT%H:%M:%SZ"
}

days_ago_utc() {
  python3 - "$1" <<'PY'
from datetime import datetime, timedelta, timezone
import sys
out = datetime.now(timezone.utc) - timedelta(days=int(sys.argv[1]))
print(out.strftime("%Y-%m-%dT%H:%M:%SZ"))
PY
}

echo "=== 1) ตรวจ token ==="
curl -s "https://api.cloudflare.com/client/v4/user/tokens/verify" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" | jq '{success, status: .result.status}'

echo
echo "=== 2) ดึง visits 7 วันล่าสุด (ทดสอบเร็ว) ==="
RANGE_START="$(days_ago_utc 7)"
RANGE_END="$(utc_now)"

read -r -d '' QUERY <<'GQL' || true
query TestVisits($accountTag: string!, $filter: AccountRumPageloadEventsAdaptiveGroupsFilter_InputObject!) {
  viewer {
    accounts(filter: { accountTag: $accountTag }) {
      rumPageloadEventsAdaptiveGroups(limit: 10, filter: $filter) {
        count
        sum {
          visits
        }
      }
    }
  }
}
GQL

PAYLOAD=$(jq -n \
  --arg query "$QUERY" \
  --arg accountTag "$CLOUDFLARE_ACCOUNT_ID" \
  --arg rangeStart "$RANGE_START" \
  --arg rangeEnd "$RANGE_END" \
  --arg siteTag "$CLOUDFLARE_WEB_ANALYTICS_SITE_TAG" \
  '{
    query: $query,
    variables: {
      accountTag: $accountTag,
      filter: {
        AND: [
          { siteTag: $siteTag },
          { datetime_geq: $rangeStart },
          { datetime_leq: $rangeEnd },
          { bot: 0 },
          { OR: [{ requestHost: "thamdee.com" }, { requestHost: "www.thamdee.com" }] }
        ]
      }
    }
  }')

curl -s "https://api.cloudflare.com/client/v4/graphql" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data-binary "$PAYLOAD" | jq .

echo
echo "=== 3) รวม visits ทั้งหมดแบบ chunked (เหมือนตอน deploy) ==="
export CLOUDFLARE_API_TOKEN CLOUDFLARE_ACCOUNT_ID CLOUDFLARE_WEB_ANALYTICS_SITE_TAG
export CLOUDFLARE_ANALYTICS_SINCE_YEAR="${CLOUDFLARE_ANALYTICS_SINCE_YEAR:-2024}"
bash "${SCRIPT_DIR}/fetch-cf-analytics.sh"
echo
cat "${SCRIPT_DIR}/../data/analytics.yaml"
