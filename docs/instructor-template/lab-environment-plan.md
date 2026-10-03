# Labs 1–3 授課/彩排環境計畫（GCP 多租戶）

> 講師參考文件（不對外公開）。本檔為環境建置的定稿計畫；課程內容（投影片、graphrag take-home、宣傳頁）已另行完成。

## Context

要在課堂讓老師 + 最多 8 位學員，**用同一份 repo、同一套 script**，一步步親手體驗
Dify / RAG / Graph / Chatbot。利用一個**全新 GCP 帳號的 free credit**（已 `gcloud auth login`）。

經查證的關鍵限制與選定方案:
- **Dify Community = 單 workspace**，OSS 授權禁止多租戶 → **每人一台 VM**（隔離且授權乾淨）。
- **Free-trial GPU quota = 0 且不能申請** → LLM 走 **Vertex AI Gemini（經 LiteLLM）**；**BGE-M3 embedding 跑 CPU**；地端 Qwen 列課後選配。
- **Neo4j 多資料庫需 Enterprise**（Community 僅單庫）→ **Neo4j Enterprise（dev 免費授權）**，每人一 database + 一組帳密。
- **LINE 真接 OA** 需 HTTPS webhook → 每台 Dify 前置 **Caddy + sslip.io**（Let's Encrypt 免買網域）。

## 目標架構

```
GCP project（asia-east1，老師的 free-credit 帳號）
├── lab-svc（共用服務 VM, e2-standard-8）
│    ├── LiteLLM gateway（OpenAI 相容）── Vertex AI: gemini-2.5-flash / -lite
│    │                                  └─ BGE-M3（TEI 容器, CPU, HF_TOKEN 下載）
│    └── Neo4j Enterprise ── 9 databases + 9 users（admin=老師, student1..8）+ Browser 視覺化
└── lab-teacher / lab-student-1..8（每人一台, e2-standard-4）── 同一 script 佈署:
     ├── Dify（self-host docker-compose，模型供應指向 LiteLLM）
     ├── graphrag adapter（LightRAG → 該人的 Neo4j db + LiteLLM/BGE-M3）
     ├── mock order API（tool calling demo）
     └── Caddy（HTTPS, <ip>.sslip.io）→ 供 Dify web UI 與 LINE webhook
```
單一 OpenAI 相容端點（LiteLLM）同時餵 Dify 與 LightRAG → 換模型只改 LiteLLM config。

## 要建立的檔案

### A. 基礎設施 `infra/`
- `terraform/`:啟用 API、VPC/firewall、`student_count`(0–8)、9 學員 VM + 1 svc VM、SA + IAM（LiteLLM SA → `roles/aiplatform.user`）、預算告警 + 自動關機排程、outputs（IP/網址/帳密）。`terraform.tfvars.example`。
- `provision/learner-setup.sh`:裝 Docker、clone repo、`start-all.sh`。
- `provision/svc-setup.sh`:LiteLLM + Neo4j Enterprise + TEI(BGE-M3)。
- `litellm/config.yaml`:vertex gemini-2.5-flash/-lite + bge-m3、master key + 每人 virtual key。
- `neo4j/init-users.cypher` + `neo4j/README.md`（視覺化查詢）。
- `infra/accounts.md`:第三方帳號清單 + 每人帳密矩陣。

### B. 缺的數據/程式
- `lab-assets/mock-order-api/`（新）:FastAPI `GET /order/{id}`、`orders.json`、Dockerfile、OpenAPI schema。
- `lab-assets/dify/dify-selfhost/`:self-host compose override + `.env`（指向 LiteLLM）。
- `lab-assets/dify/customer-bot.dify.yml`:預建 app DSL 匯出（KB + 進階 prompt + tools + 外部知識庫）。
- 更新 `lab-assets/graphrag/`:Neo4j 圖儲存後端、`EMBEDDING_DIM` 吃 env（BGE-M3=1024）、base_url 指 LiteLLM；保留檔案式給公開 take-home。

### C. 啟動/彩排
- `scripts/start-all.sh` / `stop-all.sh`。
- `scripts/preflight.sh`:煙霧測試（LiteLLM completion + embedding、Neo4j 各 db、Dify `/health`、mock API、graphrag `/retrieval` 斷言 Q3「氮氣冷萃」/Q4「入門淺焙組」）。
- `docs/instructor/rehearsal-runbook.md`（新）:Labs 1–3 逐段彩排 + LINE 真機實測。
- `docs/instructor/env-operations.md`:佈署/teardown/成本維運。

## 第三方帳號
GCP（已登入）+ 啟用 Vertex AI；`HF_TOKEN`；LINE Developers（老師建真 OA，學員課中各自建）；Neo4j Enterprise dev 授權。

## 成本與護欄
9× e2-standard-4 + 1× e2-standard-8 ≈ $1.5/hr；不含自動關機（請手動停機），~40hr ≈ $45–60；Vertex token 量小。預算告警 $50/$100/$200 + `terraform destroy` 一鍵拆。

## 驗證（端到端）
1. `terraform plan`（先 `student_count=1`）→ `apply` → outputs。
2. 每台 VM `scripts/preflight.sh` 全綠。
3. Dify 匯入 DSL：問訂單→mock API、退款→轉真人、忽略規則→被擋。
4. Stage 3：graphrag 接 Dify 外部知識庫，Q2–Q5 對照；Neo4j Browser 拉關係圖。
5. LINE 真機：手機加老師 OA → 問 FAQ → 收到回覆。
6. 走一次 runbook 計時。
7. 全綠後 `git commit`（commit/PR 訊息不提 Claude/模型名）。

## 範圍備註
- 地端 Qwen3 因 free-trial 無 GPU → 課後選配文件。
- 公開 take-home graphrag 維持輕量檔案式；Neo4j 後端僅課堂用。

## 實作順序（先本地、後雲端；apply 前先確認再花 credit）
1. mock-order-api → 2. graphrag 更新（Neo4j/BGE-M3/LiteLLM）→ 3. litellm/neo4j config →
4. dify self-host + DSL → 5. scripts（start/stop/preflight）→ 6. infra/terraform + provision →
7. accounts.md / env-operations.md / rehearsal-runbook.md → 8. **暫停確認** → 9. GCP apply + 端到端驗證。
