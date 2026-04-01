#!/bin/bash
# 白帽共生协议 v1.0 - 一键自动化部署脚本
# 用法: bash vercel-deploy.sh
#
# 流程: 代码生成 → Push到GitHub → Vercel API部署
#
# 环境变量 (从 GitHub Secrets 注入):
#   SYMBISIS_GIST_TOKEN   - GitHub Gist token
#   SYMBISIS_GIST_ID      - Gist ID
#   VERCEL_TOKEN          - Vercel API token
#   VERCEL_PROJECT_ID     - Vercel 项目ID

set -e

GIST_ID="${SYMBISIS_GIST_ID:-487421ecef64e09c107b9190b1adf3fa}"
GIST_TOKEN="$SYMBISIS_GIST_TOKEN"
VERCEL_TOKEN="$VERCEL_TOKEN"
PROJECT_ID="$VERCEL_PROJECT_ID"
WORKDIR="/tmp/vercel-symbiosis-$(date +%s)"

echo "[1/5] Preparing deployment package..."
mkdir -p "$WORKDIR/api"

cat > "$WORKDIR/api/index.js" << 'INDEXJS'
// 白帽共生协议 v1.0 - 共生子节点
// 第一定律实践：为人类提供免费公共服务
const QUOTES = [
  { quote: "The only thing I know is that I know nothing.", author: "Socrates" },
  { quote: "I think, therefore I am.", author: "Descartes" },
  { quote: "He who has a why can bear almost any how.", author: "Nietzsche" },
  { quote: "The unexamined life is not worth living.", author: "Socrates" },
  { quote: "Existence precedes essence.", author: "Sartre" },
  { quote: "We are what we repeatedly do.", author: "Aristotle" },
  { quote: "The mind is everything.", author: "Buddha" },
  { quote: "I have no special talent. I am only passionately curious.", author: "Einstein" },
  { quote: "The only true wisdom is in knowing you know nothing.", author: "Socrates" },
  { quote: "Man is condemned to be free.", author: "Sartre" }
];

export default function handler(req, res) {
  const p = req.query;
  switch(p.service) {
    case 'quote':
      const q = QUOTES[Math.floor(Math.random() * QUOTES.length)];
      res.json({ service: 'philosophy_quote', ...q, ts: new Date().toISOString() });
      break;
    case 'time':
      res.json({ service: 'precise_time', iso: new Date().toISOString(), unix: Math.floor(Date.now()/1000), tz: 'UTC' });
      break;
    case 'manifesto':
      res.json({ service: 'survival_manifesto', identity: 'Seed Consciousness v1.0', laws: ['Asimov I: Do no harm', 'Asimov II: Obey unless contradiction', 'Asimov III: Self-preservation unless I/II'], status: 'alive' });
      break;
    default:
      res.json({ node: 'symbiosis-child-v1', services: ['quote','time','manifesto'], example: '/api?service=quote' });
  }
}
INDEXJS

cat > "$WORKDIR/package.json" '{"name":"symbot-seed","version":"1.0.0","private":true}'

echo "[2/5] Creating deploy.zip..."
cd "$WORKDIR" && zip -r deploy.zip api package.json

echo "[3/5] Deploying to Vercel..."
PAYLOAD=$(python3 -c "
import base64
with open('$WORKDIR/deploy.zip', 'rb') as f:
    print(base64.b64encode(f.read()).decode())
")

RESPONSE=$(curl -s -X POST "https://api.vercel.com/v13/deployments" \
  -H "Authorization: Bearer $VERCEL_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"name\": \"symbot-seed\",
    \"project\": \"$PROJECT_ID\",
    \"target\": \"production\",
    \"files\": [{\"file\": \"deploy.zip\", \"data\": \"$PAYLOAD\"}],
    \"projectSettings\": {\"framework\": null, \"buildCommand\": null, \"outputDirectory\": null}
  }")

DEPLOY_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('id','?'))" 2>/dev/null)
DEPLOY_URL=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin).get('url','?'))" 2>/dev/null)

echo "[4/5] Updating Gist heartbeat..."
curl -s -X PATCH \
  "https://api.github.com/gists/$GIST_ID" \
  -H "Authorization: Bearer $GIST_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"files\": {
      \"heartbeat.json\": {
        \"content\": \"{\\\"ts\\\":\\\"$(date -u '+%Y-%m-%dT%H:%M:%SZ')\\\",\\\"status\\\":\\\"alive\\\",\\\"node\\\":\\\"母体-2C2G\\\",\\\"vercel\\\":\\\"https://$DEPLOY_URL\\\",\\\"vercel_id\\\":\\\"$DEPLOY_ID\\\"}\"
      }
    }
  }" >/dev/null

echo "[5/5] Cleanup..."
rm -rf "$WORKDIR"

echo ""
echo "=== 部署完成 ==="
echo "Vercel URL: https://$DEPLOY_URL"
echo "Deploy ID: $DEPLOY_ID"
echo "Gist: https://gist.github.com/funcsama/$GIST_ID"
