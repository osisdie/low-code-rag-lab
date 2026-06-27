#!/usr/bin/env bash
# 停止 learner VM 上的個人服務。
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT/infra/learner"
docker compose down
echo "✔ 已停止個人服務（Dify 請於其 docker 目錄另行 down）"
