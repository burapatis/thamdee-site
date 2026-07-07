#!/usr/bin/env bash
# ดึงจำนวนผู้เข้าชมจาก Cloudflare Web Analytics (GraphQL API) ลง data/analytics.yaml
# GitHub Secrets ที่ต้องมี: CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID
# (CLOUDFLARE_WEB_ANALYTICS_SITE_TAG ใส่เองได้ถ้าต้องการ — ไม่ใส่จะหาจาก token ใน hugo.toml อัตโนมัติ)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/data/analytics.yaml"
HUGO_CONFIG="$ROOT/hugo.toml"

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
  echo "Cloudflare analytics secrets not set — skipping visitor count fetch."
  exit 0
fi

SITE_TAG="${CLOUDFLARE_WEB_ANALYTICS_SITE_TAG:-}"
if [[ -z "$SITE_TAG" ]]; then
  BEACON_TOKEN=$(read_beacon_token)
  if [[ -z "$BEACON_TOKEN" ]]; then
    echo "No cloudflareAnalyticsToken in hugo.toml and CLOUDFLARE_WEB_ANALYTICS_SITE_TAG not set — skipping."
    exit 0
  fi
  echo "Resolving site_tag from beacon token in hugo.toml..."
  SITE_TAG=$(resolve_site_tag "$BEACON_TOKEN")
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
        sum {
          visits
          pageViews
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
  --data-binary "$PAYLOAD")

if echo "$RESPONSE" | jq -e '.errors | length > 0' >/dev/null 2>&1; then
  echo "Cloudflare GraphQL error:"
  echo "$RESPONSE" | jq '.errors'
  exit 1
fi

VISITS=$(echo "$RESPONSE" | jq '[.data.viewer.accounts[0].rumPageloadEventsAdaptiveGroups[]?.sum.visits // 0] | add // 0')
PAGEVIEWS=$(echo "$RESPONSE" | jq '[.data.viewer.accounts[0].rumPageloadEventsAdaptiveGroups[]?.sum.pageViews // 0] | add // 0')
UPDATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cat > "$OUT" <<YAML
# อัปเดตอัตโนมัติโดย scripts/fetch-cf-analytics.sh — ไม่ต้องแก้มือ
visits: ${VISITS}
pageViews: ${PAGEVIEWS}
updatedAt: "${UPDATED_AT}"
source: cloudflare-web-analytics
YAML

echo "Visitor stats written: visits=${VISITS}, pageViews=${PAGEVIEWS}"
