# Stage 3 GraphRAG 實驗室

把 **LightRAG（向量 + 知識圖譜）** 包成 **Dify 外部知識庫（External Knowledge API）** 端點，
讓同一個 Dify 客服 app 能同時查「內建向量知識庫」與「外掛圖譜知識庫」，現場對照檢索效果。

```
Dify app
 ├── 內建知識庫（向量 RAG）          ← Stage 2 已建
 └── 外部知識庫（本服務）
        └── POST /retrieval  ─────►  LightRAG（向量 + 圖譜，mix 模式）
```

> **課堂 vs 帶回家**：課堂講師用此服務（或託管的 InfraNodus GraphRAG）做完整 demo；
> 學員回家照本 README 自架練習。需要 Docker 或 Python 3.11 + 一把 LLM API key。

---

## 檔案

| 檔案 | 作用 |
|------|------|
| `rag_factory.py` | 建立共用的 LightRAG 實例（LLM + embedding 設定） |
| `ingest.py` | 把 `../knowledge-base/*.md` 灌入，建圖譜 + 向量索引 |
| `dify_retrieval_adapter.py` | FastAPI：實作 Dify `POST /retrieval` 契約 |
| `docker-compose.yml` / `Dockerfile` | 一鍵起跑 |
| `sample-queries.md` | 向量 vs 圖譜 對照題組（demo 用） |

---

## 方式 A：Docker（推薦）

```bash
cp .env.example .env          # 填入 OPENAI_API_KEY、自訂 DIFY_EXTERNAL_KNOWLEDGE_API_KEY
docker compose run --rm graphrag python ingest.py    # 先灌資料、建圖譜（會呼叫 LLM，需數分鐘）
docker compose up -d                                  # 啟動 retrieval 端點（:8000）
curl http://localhost:8000/health                     # 應回 {"status":"ok","rag_ready":true}
```

## 方式 B：本機 Python

```bash
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env          # 填好 key
python ingest.py
uvicorn dify_retrieval_adapter:app --host 0.0.0.0 --port 8000
```

---

## 在 Dify 串接外部知識庫

1. Dify →「知識庫」→「連接外部知識庫」。
2. **API Endpoint** 填：`http://<你的主機IP>:8000`（Dify 會自動加上 `/retrieval`）。
   - Dify 為 cloud 版時，需讓它連得到你的機器（用 ngrok / cloudflared 等把 8000 對外）。
3. **API Key** 填：`.env` 裡的 `DIFY_EXTERNAL_KNOWLEDGE_API_KEY`（預設 `lab-graphrag-secret`）。
4. 新增外部知識庫，`Knowledge ID` 隨意（例：`coffee-graph`）。
5. 在 Stage 2 的客服 app 裡，把這個外部知識庫加進「知識檢索」節點，與內建向量知識庫並用。

---

## 驗證（不經 Dify 直接打）

```bash
curl -s -X POST http://localhost:8000/retrieval \
  -H "Authorization: Bearer lab-graphrag-secret" \
  -H "Content-Type: application/json" \
  -d '{"knowledge_id":"coffee-graph","query":"和冷萃黑咖啡同產線且同政策的商品有哪些？","retrieval_setting":{"top_k":8,"score_threshold":0.2}}' \
  | python -m json.tool
```

對照題組與預期答案見 `sample-queries.md`。

---

## 常見問題

- **`rag_ready: false` / 查不到東西**：先確認跑過 `ingest.py` 且 `rag_storage/` 有檔。
- **LightRAG init 報錯**：本範例對齊 `lightrag-hku==1.3.0`；若你裝了較新版，請依官方 README 調整 `rag_factory.py` 的初始化寫法。
- **Dify cloud 連不到 localhost**：cloud 端在外網，要用 ngrok/cloudflared 把 `:8000` 暴露成公開網址，再填到 Dify。
- **嵌入維度不符**：換 embedding 模型要同步改 `rag_factory.py` 的 `EMBEDDING_DIM`。
- **想零安裝做課堂 demo**：可改用託管的 InfraNodus GraphRAG（Dify 官方有教學），同樣走 External Knowledge API。
