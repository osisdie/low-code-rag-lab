# Stage 3 Lab（帶回家）— 自己架一套向量 + 圖譜 RAG

> 課堂上你看了講師完整 demo。這份是**回家自己動手**的版本。
> 不趕時間、可以慢慢試。需要：Docker（或 Python 3.11）+ 一把 LLM API key。
>
> 技術細節與疑難排解：`lab-assets/graphrag/README.md`。本文是「為什麼這樣做 + 照著走」。

---

## 你要做出什麼

讓你 Stage 2 的 Dify 客服 app，**同時**查兩個知識庫：

```
Dify app
 ├── 內建知識庫（向量）   ← 你 Stage 2 建的
 └── 外掛圖譜知識庫       ← 這份 lab 架的 LightRAG
```

然後用對照問題，親眼看「向量答不全、加圖譜答得齊」。

---

## 步驟

### 1. 起服務（建圖譜 + 開 retrieval 端點）
```bash
cd lab-assets/graphrag
cp .env.example .env
#  編輯 .env：填 OPENAI_API_KEY；DIFY_EXTERNAL_KNOWLEDGE_API_KEY 自己取一個字串

docker compose run --rm graphrag python ingest.py   # 灌資料、建圖譜（會呼叫 LLM，數分鐘）
docker compose up -d                                 # 啟動端點
curl http://localhost:8000/health                    # 看到 {"status":"ok","rag_ready":true} 就成功
```

> 沒裝 Docker？用 Python 方式，見 `lab-assets/graphrag/README.md` 的「方式 B」。

### 2. 先不經 Dify，直接測 adapter
```bash
curl -s -X POST http://localhost:8000/retrieval \
  -H "Authorization: Bearer lab-graphrag-secret" \
  -H "Content-Type: application/json" \
  -d '{"knowledge_id":"coffee-graph","query":"和冷萃黑咖啡同產線且同政策的商品有哪些？","retrieval_setting":{"top_k":8,"score_threshold":0.2}}'
```
- ✅ **檢核點**：回應的 `records[0].content` 裡能看到「氮氣冷萃」相關脈絡。

### 3. 在 Dify 接上這個外掛知識庫
1. Dify →「知識庫」→「連接外部知識庫」。
2. **API Endpoint**：`http://<你電腦的IP>:8000`（Dify 會自動加 `/retrieval`）。
   - 用 Dify cloud 時，本機 localhost 它連不到 → 用 `ngrok http 8000` 或 cloudflared 產生公開網址再填。
3. **API Key**：填你 `.env` 設的 `DIFY_EXTERNAL_KNOWLEDGE_API_KEY`。
4. Knowledge ID 填 `coffee-graph`。
5. 回到 Stage 2 的 app，把這個外部知識庫**也**加進「知識檢索」節點。

### 4. 對照測試（重點）
依 `lab-assets/graphrag/sample-queries.md` 的 Q2–Q5，分別在
「只開內建向量知識庫」與「加開圖譜知識庫」兩種設定下問同一題，比較答案完整度。

| 題 | 問題 | 圖譜應補上的答案 |
|----|------|------------------|
| Q2 | 跟耶加雪菲同供應商的還有哪些豆？ | 西達摩 |
| Q3 | 跟冷萃黑咖啡同產線且同政策的有哪些？ | 氮氣冷萃 |
| Q4 | La Esperanza 斷貨會影響哪些商品和促銷組合？ | P3、P4 + 入門淺焙組 |
| Q5 | 夏日冷萃組用到哪些產區的豆？ | 瓜地馬拉、台灣阿里山 |

---

## 疑難排解（速查）
- **rag_ready: false / 查不到**：先確認 `ingest.py` 跑完、`rag_storage/` 有檔。
- **Dify 連不到 localhost**：cloud 端在外網，要 ngrok/cloudflared 把 8000 對外。
- **LightRAG 版本報錯**：本範例對齊 `lightrag-hku==1.3.0`，新版請依官方 README 調 `rag_factory.py`。
- 更多見 `lab-assets/graphrag/README.md`。

---

## 想清楚再導入（這才是這堂課要你帶走的）
- 圖譜**不是每家公司都要**。先問自己：**我的客服問題裡，有多少是「同X的還有哪些」「A影響哪些B」這種關係/多跳？**
  - 很多 → 值得評估圖譜（補向量盲區）。
  - 幾乎都是查 FAQ → Stage 2 向量就夠，別過度工程。
- 換成你自己的資料：把 `coffee-catalog-relationships.md` 換成你公司的商品/政策/供應商關係表，重跑 `ingest.py`。
