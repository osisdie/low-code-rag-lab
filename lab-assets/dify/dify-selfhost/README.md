# Dify 自架（每人一台 VM）

每位學員（與老師）在自己的 learner VM 上跑一套 Dify Community（單 workspace，授權乾淨）。
模型供應指向 lab-svc 的 LiteLLM；前面用 Caddy 做 HTTPS（給 web widget 與 LINE webhook 用）。

> 這份是「怎麼部署 + 怎麼指向 LiteLLM + 怎麼接 LINE」。自動化版見 `../../../infra/provision/learner-setup.sh`。

## 1. 部署 Dify
```bash
git clone https://github.com/langgenius/dify.git
cd dify/docker
cp .env.example .env
# 編輯 .env：把對外網址設成你的 sslip.io 網域（讓 console/web/api 連結正確）
#   CONSOLE_API_URL=https://<ip>.sslip.io
#   CONSOLE_WEB_URL=https://<ip>.sslip.io
#   SERVICE_API_URL=https://<ip>.sslip.io
#   APP_API_URL=https://<ip>.sslip.io
#   APP_WEB_URL=https://<ip>.sslip.io
docker compose up -d
```
Dify 的 nginx 預設聽 80；Caddy 反代 443→80 並自動取 Let's Encrypt 憑證（見 `caddy/Caddyfile`）。

## 2. 指向 LiteLLM（模型供應）
Dify Console → 設定 → 模型供應商 → **OpenAI-API-compatible**：
- **API Base URL**：`http://<lab-svc-ip>:4000/v1`
- **API Key**：lab-svc 的 `LITELLM_MASTER_KEY`
- 新增兩個模型：
  - LLM：`gemini-2.5-flash`（與 `gemini-2.5-flash-lite`）
  - Text Embedding：`bge-m3`（維度 1024）

## 3. 建知識庫（向量 RAG）
上傳 `../../knowledge-base/restaurant-faq.md`、`ecommerce-return-sop.md`，索引選高品質，embedding 用 `bge-m3`。

## 4. 建客服 app
- 匯入 `../customer-bot.dify.yml`（範本骨架）或手動建，貼 `../../prompts/advanced-prompt.txt`。
- 掛上知識庫、加自訂工具（匯入 `../../mock-order-api/dify-tool-openapi.yaml`）。
- 加外部知識庫（Stage 3）：endpoint `http://<本機或lab-svc>:8000`、key = graphrag 的 `DIFY_EXTERNAL_KNOWLEDGE_API_KEY`。

## 5. 上線通路
- **網站 widget**：app →「嵌入網站」→ copy embed code。
- **LINE OA（真接）**：app →「存取 API」拿 app key，設定 `../../line-bridge/`，LINE webhook 指 `https://<ip>.sslip.io/line/webhook`。

## 6. 匯出正式 DSL
建好且測過後，app →「匯出 DSL」覆蓋 `../customer-bot.dify.yml`，下次可一鍵重現。
