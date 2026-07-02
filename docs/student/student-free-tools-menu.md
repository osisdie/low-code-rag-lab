# 課後免費工具體驗清單 — 回家自己動手玩

> 今天你在課堂做出了一個 AI 客服 bot。回家想繼續玩、或想比較「還有哪些免費做法」？
> 這頁幫你整理**現在（2026）真的能免費上手**的 no-code 工具，照「三做法」分層排：先玩白話好上手的，想更深入再往下看。

> ⚠️ **免費額度會變**：下面寫的額度都是撰寫時的狀況，**以各家官網為準**。免費多半夠你練習與試營運，正式上線再看要不要付費。

---

## 名詞先講白話

| 你會看到的字 | 白話意思 |
|--------------|----------|
| no-code / low-code | 不用寫程式，用拖拉＋填表就能做 |
| 知識庫 / RAG | 餵它你的文件，它回答前先翻文件（同 Stage 0 講的） |
| 自架 self-host | 裝在自己電腦或伺服器上，資料留自己手裡 |
| API key | 背後 AI（OpenAI/Gemini…）的鑰匙，按用量計費 |

---

## A. 最好上手、真的免費（PM／主管先玩這幾個）

| 工具 | 一句話它是什麼 | 免費到什麼程度 | 適合誰 |
|------|----------------|----------------|--------|
| **Dify Cloud 免費版** | 課堂用的 Dify 官方雲端版 | 免費版可建 App＋知識庫，送少量模型額度（用完自備 key） | 想直接延續今天成果的人 |
| **Google NotebookLM** | 上傳你的文件就能問答、答案**附出處** | 免費（個人 Google 帳號即可） | 只想「有個懂我文件的助理」、零設定 |
| **Gemini Gem（自訂 Gem）** | 在 Gemini 裡用純文字設定一個客製助理 | 免費 | 想快速做「有固定人設／規則」的小助理 |
| **Coze（ByteDance）** | 最接近 Dify 的體驗：知識庫＋流程＋外掛 | 免費額度大 | 想要 Dify 那種完整功能又免費的人 |
| **Botpress** | 視覺化流程 builder，做對話機器人 | 免費每月約 500 則訊息 | 想練「對話流程設計」的人 |

> 📌 **最像今天課堂**：Dify Cloud 免費版 → 見 [Stage 2 課後段落](student-stage-2-lab.md)。
> **最省事**：NotebookLM／Gemini Gem，開帳號就能玩，適合完全不想設定的主管。

**官網**：
- Dify Cloud — https://cloud.dify.ai
- NotebookLM — https://notebooklm.google.com
- Gemini（Gems）— https://gemini.google.com
- Coze — https://www.coze.com
- Botpress — https://botpress.com

---

## B. 進階 / 偏工程（想更深入、想掌控資料的人）

| 工具 | 一句話它是什麼 | 免費到什麼程度 | 適合誰 |
|------|----------------|----------------|--------|
| **Vertex AI Agent Builder**（Google Cloud，現稱 Gemini Enterprise Agent Platform） | GCP 上建、部署 AI Agent 的平台，有低程式的 Agent Studio | 新戶 **$300 credit（90 天）**＋ Express Mode 免開帳單的試用額度 | 已在用 GCP、想走企業級的人 |
| **Flowise / n8n** | 開源、可自架的**視覺化 RAG／流程** pipeline | 軟體免費，自己架（背後 LLM 仍按量計費） | 想自己掌控、串更多系統的人 |
| **Obsidian + Copilot 外掛** | 在自己筆記軟體裡做**本機 RAG** | 免費版可本機問答、可不用 API key | 重隱私、資料想全留在自己電腦的人 |

**官網**：
- Vertex AI Agent Builder — https://cloud.google.com/products/gemini-enterprise-agent-platform
- Flowise — https://flowiseai.com ｜ n8n — https://n8n.io
- Obsidian Copilot — https://github.com/logancyang/obsidian-copilot

---

## C. 好用但要留意（freemium / 只有試用）

**Wonderchat、SiteGPT、MindStudio** 等——上手很快、幾分鐘就能吃網站/文件做出客服 bot，但**免費多半是試用**，正式用要付費。想快速做 demo 給老闆看時可考慮，長期用前先看價目。

---

## 怎麼挑？（對回你的 worksheet 落點）

- **資料少、都是公開 FAQ、只想試** → NotebookLM / Gemini Gem（開帳號就玩）。
- **要知識庫＋對話流程、想接通路** → Coze / Dify Cloud（最接近今天課堂）。
- **要自己掌控資料、重隱私或想自架** → Flowise / n8n / Obsidian。
- **已在 GCP、想走企業級** → Vertex AI Agent Builder。

> 一句話：**先用白話工具做出「能動的雛形」給老闆看**，確定值得投入，再考慮自架或工程做法。別一開始就過度工程——這也是今天這堂課要你帶走的判斷。
