# low-code-rag-lab — AI 客服機器人三階段工作坊

> 半天（下午）就能跟著做的 AI 客服建置課程。
> 從 **No-Code → Low-Code → Advanced（向量 + 圖譜 RAG）** 三階段，循序漸進。
> 對象：**老闆 / PM / 客服主管** — 不用會寫程式也能開始。

這個 repo 同時是**教學素材庫**（講師教案、學員手冊、投影片）與**可實跑的 RAG 實驗室**
（Stage 3 的向量 vs 圖譜 RAG demo）。

---

## 課程一句話

> 公司想做 AI 客服，但不知道怎麼開始？
> 這堂課帶你從最簡單的 ChatGPT 做法，一路走到能處理「關聯式、多跳問題」的進階 RAG，
> 並且**每一步都是你自己動手做出來的，不是看 demo**。

- **時間**：2026/6/27（六）13:30–17:30｜半日
- **講師**：Kevin Wu（AI 顧問）
- **場地**：B-Time Empower Hub
- **限額**：20 人

---

## 三階段一覽

| 階段 | 主題 | 工具 | RAG 類型 | 學員產出 |
|------|------|------|----------|----------|
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
│   ├── instructor/               ← 講師教案（不對外公開，未納入 public repo；見 .gitignore）
│   └── student/                  ← 學員 Lab 手冊（步驟清楚、可重複）
│       ├── worksheet-self-assessment.md
│       ├── stage-1-lab.md
│       ├── stage-2-lab.md
│       └── stage-3-lab-takehome.md
├── slides/
│   └── index.html                ← 上課用投影片（深色科技風，鍵盤翻頁）
└── lab-assets/
    ├── knowledge-base/           ← 範例知識庫（餐廳 FAQ / 電商 SOP / 關係資料）
    ├── prompts/                  ← 三層次 system prompt 範本
    ├── dify/                     ← Dify app 設定與外掛知識庫連線說明
    └── graphrag/                 ← Stage 3 核心：可實跑的向量 vs 圖譜 RAG
```

---

## 快速開始

### 給講師
1. 講師教案（時間表、口白、demo 備援、備品 checklist）保留在本機 `docs/instructor/`，**未公開**。
2. 課前依各 stage 教案準備帳號與素材。
3. 投影片：用瀏覽器打開 `slides/index.html`，左右方向鍵翻頁。

### 給學員
- Stage 1 / 2 在課堂跟著 `docs/student/stage-1-lab.md`、`stage-2-lab.md` 做。
- Stage 3 課堂看講師 demo，回家照 `docs/student/stage-3-lab-takehome.md` 自架練習。

### 跑 Stage 3 的 GraphRAG 實驗室（進階 / take-home）
```bash
cd lab-assets/graphrag
cp .env.example .env          # 填入 LLM API key
docker compose up -d          # 啟動 LightRAG + Dify 相容 retrieval adapter
python ingest.py              # 把 knowledge-base 灌入圖譜
# 之後在 Dify 以 External Knowledge 連到 http://<host>:8000
```
細節見 `lab-assets/graphrag/README.md`。

---

## 設計理念

- **不教 prompt 花式技巧**，教「公司今天該選哪種做法、怎麼真的做出來、預算怎麼抓」。
- **每階段 what / why / how-to** — 先講為什麼需要，再教怎麼做。
- **可重複操作** — 步驟、範例資料、prompt、設定都附在 repo，照著做就會動。
- **進階不落地不算數** — Stage 3 不只講概念，提供能在自己筆電上跑起來的圖譜 RAG。

---

## 授權與用途

**雙授權**（見 [`LICENSE`](LICENSE)）：程式碼（`lab-assets/graphrag/`、`slides/index.html`）採 **MIT**；
課程內容（文件、知識庫、prompt）採 **CC BY 4.0**（可自由分享/改作，需署名）。

範例公司（綠野鮮蔬餐廳、手沖咖啡電商等）皆為虛構。
預算數字標示「範本」，實際導入請依匯率、區域、業態重算。
