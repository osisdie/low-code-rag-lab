# low-code-rag-lab — AI 客服機器人三階段工作坊

> 半天（下午）就能跟著做的 AI 客服建置課程。
> 從 **No-Code → Low-Code → Advanced（向量 + 圖譜 RAG）** 三階段，循序漸進。
> 對象：**老闆 / PM / 客服主管** — 不用會寫程式也能開始。
>
> **狀態**：首梯次已開課完畢（2026/7）。本 repo 現為可**重複開課的素材庫**：學員手冊、投影片、實驗環境、
> 以及去敏後的講師教案範本（`docs/instructor-template/`）都在這裡，直接套用即可開下一梯。

這個 repo 同時是**教學素材庫**（講師教案、學員手冊、投影片）與**可實跑的 RAG 實驗室**
（Stage 3 的向量 vs 圖譜 RAG demo）。

---

## 課程一句話

> 公司想做 AI 客服，但不知道怎麼開始？
> 這堂課帶你從最簡單的 ChatGPT 做法，一路走到能處理「關聯式、多跳問題」的進階 RAG，
> 並且**每一步都是你自己動手做出來的，不是看 demo**。

- **形式**：半日（約 4 小時，13:30–17:30）｜建議 20 人內
- **講師**：Kevin Wu（AI 顧問）
- **首梯**：2026 年 7 月，B-Time Empower Hub（日期、場地、人數下梯次請重填）

---

## 三階段一覽

| 階段 | 主題 | 工具 | RAG 類型 | 學員產出 |
|------|------|------|----------|----------|
| **Stage 0 · 觀念地基** | 科普今日主流 RAG 與專有名詞（純講解，不開電腦） | — | — | 一張看得懂的「名詞地圖」 |
| **Stage 1 · No-Code** | 用 ChatGPT 做 AI 客服 | ChatGPT / Gemini / Claude Projects | 內建檔案檢索（黑盒） | 一個能回 FAQ 的 bot 雛形 |
| **Stage 2 · Low-Code** | 用 Dify 串 LINE | Dify cloud | **向量 RAG**（語意相似） | 一個可上線、能轉真人的客服 bot |
| **Stage 3 · Advanced** | 向量 + 圖譜 RAG | Dify 內建知識庫 + 外掛 GraphRAG | **向量 + 圖譜**（關係/多跳） | 課堂完整 demo，進階實作帶回家練習 |
| **收尾段** | 正式導入決策 | — | — | 4 套預算範本 + 1週/1月/3月 行動清單 |

> **為什麼是這個順序？** 每一階段都在前一階段的「天花板」上往上長：
> ChatGPT 不能串通路 → 用 Dify；向量檢索答不全關聯問題 → 加圖譜。
> 學員會親眼看到每個天花板，才知道何時該升級、何時不必過度工程。

---

## 目錄結構

```
low-code-rag-lab/
├── README.md                     ← 你在這
├── docs/
│   ├── instructor-template/      ← 講師教案「去敏範本」（時間表、教案、口白稿、彩排 checklist、環境維運；見其 README）
│   ├── instructor/               ← （本機專用，被 .gitignore 忽略）實際版：含名單、憑證，不進版控
│   └── student/                  ← 學員 Lab 手冊（步驟清楚、可重複）
│       ├── student-worksheet-self-assessment.md
│       ├── student-stage-0-concepts.md  ← Stage 0 名詞地圖（RAG 科普，給非技術學員）
│       ├── student-stage-1-lab.md
│       ├── student-stage-2-lab.md  ← 含「課後：用 Dify Cloud 免費版繼續練習」
│       ├── student-stage-3-lab-takehome.md
│       ├── student-free-tools-menu.md  ← 課後免費 no-code 工具清單（NotebookLM / Gemini Gem / Coze…）
│       ├── student-onboarding-illustrated.*  ← 圖文操作手冊（md/html/pdf，含實機截圖）
│       ├── student-line-setup.*    ← LINE 串接逐步教學（md/html/pdf）
│       └── simple/                 ← 超白話版：開場名詞卡 + Stage 1/2 速查卡（md/html/pdf）
├── slides/
│   ├── handbook.html             ← 上課主檔：報紙格式滾動手冊（合併全三階段＋產業數據/評測，附出處連結）
│   ├── dify.html                 ← Dify 特別報導（社群角色/為何被創建/企業採用/應用領域＋n8n 伴讀）
│   ├── graphrag.html             ← GraphRAG 特別報導（來不及教時的科普：知識圖譜是什麼、何時該用）
│   └── obsidian.html             ← Obsidian 特別報導（graph view 平民版知識圖；AI 加持需算力）
├── index.html, .nojekyll         ← GitHub Pages 入口（導向 slides/handbook.html）
├── lab-assets/
│   ├── knowledge-base/           ← 範例知識庫（Stage 1：餐廳 FAQ；Stage 2/3：咖啡電商 SOP + 關係資料）
│   ├── prompts/                  ← system prompt 範本（哪支對應哪 Stage 見 prompts/README.md）
│   ├── dify/                     ← Dify app 設定、self-host 指引、DSL 骨架
│   ├── mock-order-api/           ← Lab 2 訂單查詢工具（tool calling demo）
│   ├── line-bridge/              ← Lab 2 LINE OA ↔ Dify 橋接（真接 LINE）
│   └── graphrag/                 ← Stage 3 核心：向量 vs 圖譜 RAG（檔案式/Neo4j 雙模式，含 Cypher 範例）
├── functions/line-webhook/       ← LINE ↔ Dify 的 Cloud Function（HTTPS webhook，streaming）
├── obsidian/                     ← 「只答 vault」AI 客服 vault：coffee / newsoft / 台鋼集團 圖譜示範 + your-company 範本 + 內部試用指南
├── scripts/                      ← start-all / stop-all / preflight（開課前煙霧測試）/ deploy-line-webhook
└── infra/                        ← GCP 授課環境（共用服務 + 老師 + 學員機）：Terraform + LiteLLM + Neo4j + 佈署腳本
```

> **授課環境（GCP）**：見 `infra/README.md`。一鍵建出共用服務（LiteLLM→Vertex Gemini、
> Neo4j、BGE-M3）+ Dify VM。首梯實際採「全班共用一台 Dify」（外部 IP 配額限制，省成本）；
> 試跑／彩排 checklist 見 `docs/instructor-template/`（去敏範本）。

---

## 快速開始

### 給講師
1. 講師教案（時間表、口白、demo 備援、彩排 checklist）的**去敏範本**在 [`docs/instructor-template/`](docs/instructor-template/)；
   複製到本機 `docs/instructor/`（已被 `.gitignore` 忽略）填入實際值使用。**學員名單、帳密、金鑰、QR 不進版控。**
2. 開課前依各 stage 教案準備帳號與素材；`scripts/preflight.sh` 可做煙霧測試。
3. 上課主檔：用瀏覽器打開 `slides/handbook.html`（報紙格式，直接滾動帶過全場）；延伸閱讀見 `slides/dify.html`。

### 給學員
- Stage 0 開場先看 `docs/student/student-stage-0-concepts.md`（RAG／專有名詞白話地圖，動手卡關時回來查）。
- Stage 1 / 2 在課堂跟著 `docs/student/student-stage-1-lab.md`、`student-stage-2-lab.md` 做（圖文版見 `student-onboarding-illustrated.md`；想要更白話的見 `docs/student/simple/`）。
- Stage 3 課堂看講師 demo，回家照 `docs/student/student-stage-3-lab-takehome.md` 自架練習。
- 想把機器人接上 LINE：`docs/student/student-line-setup.md`。
- 課後想繼續玩：見 `docs/student/student-free-tools-menu.md`（免費 no-code 工具清單）；想要一個「只答自家文件」的本地 bot，見 `obsidian/`（`internal-trial-guide` 有 NotebookLM／Claude Panel 兩條路）。

### 跑 Stage 3 的 GraphRAG 實驗室（進階 / take-home）
```bash
cd lab-assets/graphrag
cp .env.example .env          # 填入 LLM API key
docker compose up -d          # 啟動 LightRAG + Dify 相容 retrieval adapter
python ingest.py              # 把 knowledge-base 灌入圖譜
# 之後在 Dify 以 External Knowledge 連到 http://<host>:8000
```
細節見 `lab-assets/graphrag/README.md`。⚠️ 範例 `.env` 內的 `lab-graphrag-secret` 只是教學用預設值，真實部署請改掉。

---

## 設計理念

- **不教 prompt 花式技巧**，教「公司今天該選哪種做法、怎麼真的做出來、預算怎麼抓」。
- **每階段 what / why / how-to** — 先講為什麼需要，再教怎麼做。
- **可重複操作** — 步驟、範例資料、prompt、設定都附在 repo，照著做就會動。
- **進階不落地不算數** — Stage 3 不只講概念，提供能在自己筆電上跑起來的圖譜 RAG。

---

## 授權與用途

**雙授權**（見 [`LICENSE`](LICENSE)）：程式碼（`lab-assets/graphrag/`、`slides/*.html`）採 **MIT**；
課程內容（文件、知識庫、prompt）採 **CC BY 4.0**（可自由分享/改作，需署名）。

範例公司（綠野鮮蔬餐廳、手沖咖啡電商等）皆為虛構。
預算數字標示「範本」，實際導入請依匯率、區域、業態重算。
