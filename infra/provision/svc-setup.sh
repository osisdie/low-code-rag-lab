#!/usr/bin/env bash
# lab-shared 開機自動佈署：Docker + (Neo4j Enterprise + TEI/BGE-M3) + 初始化 Neo4j 多租戶帳號。
# 由 Terraform 以 metadata_startup_script 注入；以 root 執行。
set -euxo pipefail

md() { curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/attributes/$1"; }
REPO_URL="$(md repo-url)"
HF_TOKEN="$(md hf-token)"
NEO4J_PW="$(md neo4j-initial-pw)"

# --- Docker ---
export DEBIAN_FRONTEND=noninteractive
apt-get update -y && apt-get install -y ca-certificates curl git
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" >/etc/apt/sources.list.d/docker.list
apt-get update -y && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# --- repo + 起服務 ---
git clone "$REPO_URL" /opt/lab || (cd /opt/lab && git pull)
cd /opt/lab/infra/svc
cat >.env <<EOF
HF_TOKEN=${HF_TOKEN}
NEO4J_INITIAL_PW=${NEO4J_PW}
EOF
docker compose up -d

# --- 等 Neo4j 起來，初始化多租戶帳號（cypher 內 ChangeMe-* 換成統一初始密碼）---
for i in $(seq 1 60); do
  if docker exec lcrl-neo4j cypher-shell -u neo4j -p "$NEO4J_PW" "RETURN 1;" >/dev/null 2>&1; then break; fi
  sleep 5
done
sed -E "s/ChangeMe-[^']*'/${NEO4J_PW}'/g" /opt/lab/infra/neo4j/init-users.cypher \
  | docker exec -i lcrl-neo4j cypher-shell -u neo4j -p "$NEO4J_PW" -d system || true

echo "lab-shared 佈署完成：Neo4j :7474,:7687 / TEI(BGE-M3) :8081"
