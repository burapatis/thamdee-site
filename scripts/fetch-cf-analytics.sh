#!/usr/bin/env bash
# ดึงจำนวนผู้เข้าชมจาก Cloudflare Web Analytics (GraphQL API) ลง data/analytics.yaml
# GitHub Secrets ที่ต้องมี: CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID
# (CLOUDFLARE_WEB_ANALYTICS_SITE_TAG ใส่เองได้ถ้าต้องการ — ไม่ใส่จะหาจาก token ใน hugo.toml อัตโนมัติ)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/data/analytics.yaml"
HUGO_CONFIG="$ROOT/hugo.toml"

warn_skip() {
  echo "$1" >&2
  echo "Skipping visitor count fetch — site deploy continues." >&2
  exit 0
}

cf_api() {
  curl -fsS "https://api.cloudflare.com/client/v4/$1" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    -H "Content-Type: application/json" \
    "${@:2}"
}

read_beacon_token() {
  if [[ -n "${CLOUDFLARE_WEB_ANALYTICS_BEACON_TOKEN:-}" ]]; then
    echo "$CLOUDFLARE_WEB_ANALYTICS_BEACON_TOKEN"
    return
  fi
  if [[ -f "$HUGO_CONFIG" ]]; then
    grep 'cloudflareAnalyticsToken' "$HUGO_CONFIG" \
      | sed -n 's/.*= *"\([^"]*\)".*/\1/p' \
      | head -1
  fi
}

resolve_site_tag() {
  local beacon_token="$1"
  local response
  response=$(cf_api "accounts/${CLOUDFLARE_ACCOUNT_ID}/rum/site_info/list" || true)

  if ! echo "$response" | jq -e '.success == true' >/dev/null 2>&1; then
    echo "Cloudflare site list API failed:" >&2
    echo "$response" | jq '.' >&2 || echo "$response" >&2
    echo >&2
    echo "ตรวจสอบ: Account ID ถูกต้อง และ API Token มีสิทธิ์ Account Analytics Read + Account Settings Read" >&2
    return 1
  fi

  local site_tag
  site_tag=$(echo "$response" | jq -r --arg token "$beacon_token" '
    (.result // [])[]
    | select(.site_token == $token or (.snippet // "" | contains($token)))
    | .site_tag
  ' | head -1)

  if [[ -z "$site_tag" ]]; then
    echo "ไม่พบ site_tag ที่ตรงกับ beacon token ใน hugo.toml" >&2
    echo "รายการ Web Analytics sites ใน account นี้:" >&2
    echo "$response" | jq -r '(.result // [])[] | "- host: \(.rules[0].host // "unknown") | site_tag: \(.site_tag // "n/a")"' >&2
    return 1
  fi

  echo "$site_tag"
}

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" || -z "${CLOUDFLARE_ACCOUNT_ID:-}" ]]; then
  warn_skip "Cloudflare analytics secrets not set."
fi

SITE_TAG="${CLOUDFLARE_WEB_ANALYTICS_SITE_TAG:-}"
if [[ -z "$SITE_TAG" ]]; then
  BEACON_TOKEN=$(read_beacon_token)
  if [[ -z "$BEACON_TOKEN" ]]; then
    warn_skip "No cloudflareAnalyticsToken in hugo.toml and CLOUDFLARE_WEB_ANALYTICS_SITE_TAG not set."
  fi
  echo "Resolving site_tag from beacon token in hugo.toml..."
  if ! SITE_TAG=$(resolve_site_tag "$BEACON_TOKEN"); then
    warn_skip "Could not resolve site_tag from Cloudflare API."
  fi
  echo "Using site_tag: ${SITE_TAG}"
fi

HOSTS_JSON='[{"requestHost":"thamdee.com"},{"requestHost":"www.thamdee.com"}]'
FOUNDING_YEAR="${CLOUDFLARE_ANALYTICS_SINCE_YEAR:-2024}"
SINCE="${FOUNDING_YEAR}-01-01T00:00:00Z"

read -r -d '' QUERY <<'GQL' || true
query WebAnalyticsVisits($accountTag: string!, $filter: AccountRumPageloadEventsAdaptiveGroupsFilter_InputObject!) {
  viewer {
    accounts(filter: { accountTag: $accountTag }) {
      rumPageloadEventsAdaptiveGroups(limit: 10000, filter: $filter) {
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
  --arg siteTag "$SITE_TAG" \
  --arg since "$SINCE" \
  --argjson hosts "$HOSTS_JSON" \
  '{
    query: $query,
    variables: {
      accountTag: $accountTag,
      filter: {
        AND: [
          { siteTag: $siteTag },
          { datetime_geq: $since },
          { bot: 0 },
          { OR: $hosts }
        ]
      }
    }
  }')

RESPONSE=$(curl -fsS "https://api.cloudflare.com/client/v4/graphql" \
  -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data-binary "$PAYLOAD" || true)

if echo "$RESPONSE" | jq -e '.errors | length > 0' >/dev/null 2>&1; then
  echo "Cloudflare GraphQL error:" >&2
  echo "$RESPONSE" | jq '.errors' >&2
  warn_skip "GraphQL query failed."
fi

GROUPS=$(echo "$RESPONSE" | jq '.data.viewer.accounts[0].rumPageloadEventsAdaptiveGroups // []')
VISITS=$(echo "$GROUPS" | jq '[.[].sum.visits // 0] | add // 0')
PAGEVIEWS=$(echo "$GROUPS" | jq '[.[].count // 0] | add // 0')
UPDATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cat > "$OUT" <<YAML
# อัปเดตอัตโนมัติโดย scripts/fetch-cf-analytics.sh — ไม่ต้องแก้มือ
visits: ${VISITS}
pageViews: ${PAGEVIEWS}
updatedAt: "${UPDATED_AT}"
source: cloudflare-web-analytics
YAML

echo "Visitor stats written: visits=${VISITS}, pageViews=${PAGEVIEWS}"
