#!/usr/bin/env bash
# learner VM 開機自動佈署：Docker + Dify(self-host) + 個人服務(LiteLLM/graphrag/mock/line-bridge/Caddy)。
# LiteLLM 用「本 VM 所屬專案」的 Vertex（attached SA 走 ADC）；BGE-M3 走共用 lab-shared 的 TEI。
# 由 Terraform 以 metadata_startup_script 注入；以 root 執行。UI 步驟寫進 /etc/motd。
set -euxo pipefail

md() { curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/$1"; }
EXT_IP="$(curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip")"
DOMAIN="${EXT_IP//./-}.sslip.io"

REPO_URL="$(md repo-url)"
SHARED_IP="$(md shared-ip)"
LITELLM_KEY="$(md litellm-master-key)"
GRAPHRAG_KEY="$(md graphrag-key)"
VERTEX_PROJECT="$(md vertex-project)"
VERTEX_LOCATION="$(md vertex-location)"
NEO4J_USER="$(md neo4j-user)"
NEO4J_PW="$(md neo4j-password)"
NEO4J_DB="$(md neo4j-database)"

# --- Docker ---
export DEBIAN_FRONTEND=noninteractive
apt-get update -y && apt-get install -y ca-certificates curl git
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" >/etc/apt/sources.list.d/docker.list
apt-get update -y && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# --- repo ---
git clone "$REPO_URL" /opt/lab || (cd /opt/lab && git pull)

# --- Dify self-host ---
git clone https://github.com/langgenius/dify.git /opt/dify || (cd /opt/dify && git pull)
cd /opt/dify/docker
cp -n .env.example .env
{
  echo ""
  echo "# --- lab overrides ---"
  echo "CONSOLE_API_URL=https://${DOMAIN}"
  echo "CONSOLE_WEB_URL=https://${DOMAIN}"
  echo "SERVICE_API_URL=https://${DOMAIN}"
  echo "APP_API_URL=https://${DOMAIN}"
  echo "APP_WEB_URL=https://${DOMAIN}"
} >>.env
docker compose up -d

# --- 個人服務 .env ---
cd /opt/lab/infra/learner
cat >.env <<EOF
VERTEX_PROJECT=${VERTEX_PROJECT}
VERTEX_LOCATION=${VERTEX_LOCATION}
TEI_BASE=http://${SHARED_IP}:8081/v1
LITELLM_MASTER_KEY=${LITELLM_KEY}
OPENAI_API_KEY=${LITELLM_KEY}
OPENAI_API_BASE=http://litellm:4000/v1
LLM_MODEL=gemini-2.5-flash
EMBEDDING_MODEL=bge-m3
EMBEDDING_DIM=1024
NEO4J_URI=bolt://${SHARED_IP}:7687
NEO4J_USERNAME=${NEO4J_USER}
NEO4J_PASSWORD=${NEO4J_PW}
NEO4J_DATABASE=${NEO4J_DB}
DIFY_EXTERNAL_KNOWLEDGE_API_KEY=${GRAPHRAG_KEY}
LIGHTRAG_WORKING_DIR=./rag_storage
ADAPTER_PORT=8000
LINE_CHANNEL_SECRET=FILL_IN_LINE_LAB
LINE_CHANNEL_ACCESS_TOKEN=FILL_IN_LINE_LAB
DIFY_API_BASE=http://localhost/v1
DIFY_APP_KEY=FILL_IN_AFTER_BUILDING_APP
LAB_DOMAIN=${DOMAIN}
EOF
export LAB_DOMAIN="$DOMAIN"
docker compose up -d --build

# --- 等本機 LiteLLM 就緒（確認能呼叫自家 Vertex）後灌圖譜（非致命）---
for i in $(seq 1 60); do
  curl -sf "http://localhost:4000/v1/models" -H "Authorization: Bearer ${LITELLM_KEY}" >/dev/null 2>&1 && break || sleep 5
done
docker exec lcrl-graphrag python ingest.py || true

cat >/etc/motd <<EOF
==== low-code-rag-lab 個人環境（專案 ${VERTEX_PROJECT}）====
Dify 主控台 : https://${DOMAIN}        （首次登入需建管理員帳號）
本機 LiteLLM : http://${DOMAIN%/}:4000/v1  （Dify 模型供應商填這個；key=LiteLLM master）
Neo4j Browser: http://${SHARED_IP}:7474   （帳號 ${NEO4J_USER} / db ${NEO4J_DB}）

待辦（UI，無法自動化）:
 1) Dify→模型供應商→OpenAI-API-compatible：Base http://<本機>:4000/v1，Key=LiteLLM master
    加模型 gemini-2.5-flash（LLM）、bge-m3（embedding, dim 1024）
 2) 建知識庫（/opt/lab/lab-assets/knowledge-base/*）、建 app（貼 prompts/advanced-prompt.txt）
 3) 加工具（匯入 mock-order-api/dify-tool-openapi.yaml）、加外部知識庫（graphrag :8000）
 4) LINE：填 /opt/lab/infra/learner/.env 的 LINE_* 與 DIFY_APP_KEY，再 docker compose up -d line-bridge
 驗證：/opt/lab/scripts/preflight.sh
EOF
echo "learner 佈署完成：${DOMAIN}（Vertex 專案 ${VERTEX_PROJECT}）"
