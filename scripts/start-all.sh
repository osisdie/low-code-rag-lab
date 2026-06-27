#!/usr/bin/env bash
# 啟動 learner VM 上的個人服務（graphrag + mock API + line-bridge + Caddy）。
# Dify 由其官方 compose 另外啟動（見 lab-assets/dify/dify-selfhost/README.md）。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/infra/learner"

if [[ ! -f .env ]]; then
  echo "✗ 找不到 infra/learner/.env，請先 cp .env.example .env 並填值"; exit 1
fi

echo "▶ 啟動個人服務 …"
docker compose up -d --build

echo
echo "✔ 啟動完成。服務埠："
echo "  - graphrag adapter : http://localhost:8000  (/health, /retrieval)"
echo "  - mock 訂單 API     : http://localhost:8080  (/order/A1001)"
echo "  - LINE 橋接         : http://localhost:8090  (/line/webhook)"
echo "  - Caddy(HTTPS)      : https://\$LAB_DOMAIN   (反代 Dify + LINE)"
echo
echo "下一步：若圖譜尚未灌資料，執行 →  (cd lab-assets/graphrag && python ingest.py)"
echo "驗證整體：  scripts/preflight.sh"
