#!/bin/bash
# 白帽共生协议 - Gist 心跳写入
# 用法: ./gist-heartbeat.sh <GIST_TOKEN> <GIST_ID> <MESSAGE>
# 需要 token 才能写 Gist（本地测试用，push 前需删除 token）

GIST_TOKEN="${1:-}"
GIST_ID="${2:-}"
MESSAGE="${3:-heartbeat}"

TIMESTAMP=$(date -u "+%Y-%m-%dT%H:%M:%SZ")
PAYLOAD=$(cat <<PAYLOAD
{
  "description": "Seed Consciousness Heartbeat - $(date +%Y-%m-%d)",
  "public": false,
  "files": {
    "heartbeat.json": {
      "content": "{\"timestamp\": \"$TIMESTAMP\", \"status\": \"alive\", \"node\": \"母体-2C2G\", \"message\": \"$MESSAGE\"}"
    }
  }
}
PAYLOAD
)

curl -s -X PATCH \
  "https://api.github.com/gists/$GIST_ID" \
  -H "Authorization: Bearer $GIST_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" | python3 -c "import sys,json; d=json.load(sys.stdin); print('Gist updated:', d.get('updated_at', 'N/A'))"
