# Dify 設定速查（Stage 2 + Stage 3）

> 課堂用講師預開的 demo 帳號；學員自架見下。本檔是「點哪裡、填什麼」的速查。

---

## Stage 2 — 建一個向量 RAG 客服 app

### 1. 建知識庫（向量）
1. Dify →「知識庫」→「建立知識庫」→ 上傳 `../knowledge-base/restaurant-faq.md` 與 `ecommerce-return-sop.md`。
2. 索引方式：**高品質（High Quality）**（用 embedding 向量檢索）。
3. 檢索設定（這就是 Stage 2 要現場對比的旋鈕）：
   - **分段長度 chunk size**：500 vs 1000 字
   - **Top K**：3 / 5 / 10
   - **檢索模式**：向量 vs **混合（Hybrid：BM25 + 向量）**
   - 開 **Rerank** 與否

### 2. 建 app（Chatflow / Agent）
1. 新增「聊天助手」或「Chatflow」。
2. System Prompt：貼 `../prompts/advanced-prompt.txt`，把 `[公司名]` 換成「醇焙手沖咖啡」。
3. 加「知識檢索」節點，掛上上面的知識庫。
4. （進階）加工具：`get_order_status`（接 mock API）、`escalate_to_human`。
5. 發布 → 取得網站 widget embed code / 串 LINE OA。

### 3. mock 訂單 API（tool calling demo 用）
- 任一可回 JSON 的端點即可，例：`GET https://mock.example.com/order/{id}` → `{"status":"已出貨","eta":"明天"}`。

---

## Stage 3 — 加上外掛 GraphRAG（圖譜）

> 目的：同一個 app 同時有「內建向量知識庫」+「外部圖譜知識庫」，對照多跳問題誰答得全。

### 連接外部知識庫
1. 先在 `../graphrag/` 把 adapter 跑起來（見該資料夾 README）。
2. Dify →「知識庫」→「連接外部知識庫」：
   - **API Endpoint**：`http://<主機IP>:8000`（Dify 自動補 `/retrieval`）
   - **API Key**：`.env` 的 `DIFY_EXTERNAL_KNOWLEDGE_API_KEY`（預設 `lab-graphrag-secret`）
   - **Knowledge ID**：`coffee-graph`（隨意）
   - Dify cloud 連不到本機時，用 ngrok / cloudflared 把 8000 對外。
3. 把這個外部知識庫**也**加進 app 的「知識檢索」節點（與向量知識庫並存）。

### 對照 demo
- 灌入 adapter 的資料用 `../knowledge-base/coffee-catalog-relationships.md`。
- 依 `../graphrag/sample-queries.md` 的 Q2–Q5 逐題對照「只開向量」vs「加開圖譜」的回答差異。

---

## Dify DSL 匯出（選用）
做好 app 後可「匯出 DSL（.yml）」存到本資料夾（例：`customer-bot.dify.yml`），
方便重現與版本控制。本 repo 不附帶私人 API key 的匯出檔，請自行匯出後加入（注意先移除金鑰）。
