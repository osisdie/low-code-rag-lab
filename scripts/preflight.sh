#!/usr/bin/env bash
# 彩排前煙霧測試：逐一檢查所有服務，並斷言 Stage 3 圖譜對照題的關鍵答案。
# 跑全部檢查（不會一失敗就停），最後給總結；有任一失敗則 exit 1。
#
# 用法：scripts/preflight.sh            # 讀 infra/learner/.env
#       LAB_SVC_IP=10.0.0.9 scripts/preflight.sh
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ENV_FILE:-$ROOT/infra/learner/.env}"
[[ -f "$ENV_FILE" ]] && set -a && . "$ENV_FILE" && set +a

# LiteLLM 在本機 host 上以 :4000 對外（.env 的 OPENAI_API_BASE 是 compose 內部名，host 連不到）
LITELLM_BASE="http://localhost:4000/v1"
LITELLM_KEY="${LITELLM_MASTER_KEY:-${OPENAI_API_KEY:-}}"
GRAPHRAG_KEY="${DIFY_EXTERNAL_KNOWLEDGE_API_KEY:-lab-graphrag-secret}"
ADAPTER="http://localhost:${ADAPTER_PORT:-8000}"

PASS=0; FAIL=0
ok(){ echo "  ✔ $1"; PASS=$((PASS+1)); }
no(){ echo "  ✗ $1"; FAIL=$((FAIL+1)); }
hr(){ echo; echo "── $1"; }

# 1. mock 訂單 API
hr "mock 訂單 API"
if curl -sf "http://localhost:8080/order/A1001" | grep -q "已出貨"; then ok "A1001 已出貨"; else no "mock API 查詢失敗"; fi

# 2. graphrag adapter 健康
hr "graphrag adapter"
if curl -sf "$ADAPTER/health" | grep -q '"rag_ready": *true'; then ok "rag_ready=true"; else no "adapter 未就緒（是否跑過 ingest.py?）"; fi

# 3. 圖譜對照題斷言（Stage 3 主秀）
q(){ # $1=query  $2=expect
  local out
  out=$(curl -sf -X POST "$ADAPTER/retrieval" -H "Authorization: Bearer $GRAPHRAG_KEY" \
        -H 'Content-Type: application/json' \
        -d "{\"knowledge_id\":\"coffee-graph\",\"query\":\"$1\",\"retrieval_setting\":{\"top_k\":8,\"score_threshold\":0.2}}" 2>/dev/null)
  if echo "$out" | grep -q "$2"; then ok "「$1」→ 命中『$2』"; else no "「$1」→ 未見『$2』（圖譜可能未灌好）"; fi
}
hr "圖譜對照題（向量 vs 圖譜）"
q "和冷萃黑咖啡同產線且同政策的商品有哪些？" "氮氣冷萃"
q "La Esperanza 斷貨會影響哪些商品和促銷組合？" "入門淺焙組"

# 4. LINE 橋接
hr "LINE 橋接"
if curl -sf "http://localhost:8090/health" | grep -q ok; then ok "line-bridge 健康"; else no "line-bridge 無回應"; fi

# 5. LiteLLM gateway（模型清單）
hr "LiteLLM gateway"
if curl -sf "$LITELLM_BASE/models" -H "Authorization: Bearer $LITELLM_KEY" | grep -q "gemini-2.5-flash"; then
  ok "LiteLLM 有 gemini-2.5-flash"; else no "LiteLLM /models 失敗或缺模型"; fi

# 6. BGE-M3 embedding（經 LiteLLM）
hr "BGE-M3 embedding"
if curl -sf -X POST "$LITELLM_BASE/embeddings" -H "Authorization: Bearer $LITELLM_KEY" \
   -H 'Content-Type: application/json' -d '{"model":"bge-m3","input":"咖啡"}' | grep -q '"embedding"'; then
  ok "bge-m3 embedding 正常"; else no "embedding 失敗（TEI 是否就緒?）"; fi

# 7. Neo4j bolt 連線（TCP）
hr "Neo4j"
NEO4J_HOST=$(echo "${NEO4J_URI:-bolt://localhost:7687}" | sed -E 's#.*//([^:/]+).*#\1#')
NEO4J_PORT=$(echo "${NEO4J_URI:-bolt://localhost:7687}" | sed -E 's#.*:([0-9]+).*#\1#')
if timeout 3 bash -c ">/dev/tcp/$NEO4J_HOST/$NEO4J_PORT" 2>/dev/null; then ok "Neo4j bolt $NEO4J_HOST:$NEO4J_PORT 可連"; else no "Neo4j bolt 連不上"; fi

# 8. Dify 前端
hr "Dify"
code=$(curl -s -o /dev/null -w '%{http_code}' http://localhost/ 2>/dev/null || echo 000)
if [[ "$code" =~ ^(200|302|307)$ ]]; then ok "Dify 回應 $code"; else no "Dify 未回應（$code）"; fi

echo; echo "════════════════════════"
echo "  PASS=$PASS  FAIL=$FAIL"
echo "════════════════════════"
[[ $FAIL -eq 0 ]] && { echo "✔ 全綠，可以彩排"; exit 0; } || { echo "✗ 有項目未過，見上方"; exit 1; }
