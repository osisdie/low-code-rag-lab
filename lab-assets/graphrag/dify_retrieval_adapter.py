"""把 LightRAG 包成 Dify「外部知識庫（External Knowledge API）」相容端點。

Dify 的契約（見 https://docs.dify.ai/en/use-dify/knowledge/external-knowledge-api）：
  - Dify 會對 {你設定的 endpoint}/retrieval 發 POST
  - Header：Authorization: Bearer <你在 Dify 設定的 API Key>
  - Body：{ "knowledge_id": str, "query": str,
            "retrieval_setting": { "top_k": int, "score_threshold": float } }
  - 回應 200：{ "records": [ { "content": str, "score": float,
                              "title": str, "metadata": {...} }, ... ] }

本 adapter 收到查詢後，用 LightRAG 的 mix 模式（向量 + 圖譜）取出「檢索脈絡」，
回給 Dify，由 Dify 端的 LLM 組最終答案。

啟動：
    uvicorn dify_retrieval_adapter:app --host 0.0.0.0 --port 8000
"""
import os
from contextlib import asynccontextmanager

from dotenv import load_dotenv
from fastapi import FastAPI, Header, HTTPException
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

from lightrag import QueryParam
from rag_factory import build_rag

load_dotenv()

EXPECTED_BEARER = os.getenv("DIFY_EXTERNAL_KNOWLEDGE_API_KEY", "lab-graphrag-secret")

# 全域 LightRAG 實例（啟動時初始化一次）
_rag = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    global _rag
    _rag = await build_rag()
    yield


app = FastAPI(title="GraphRAG ↔ Dify External Knowledge Adapter", lifespan=lifespan)


class RetrievalSetting(BaseModel):
    top_k: int = 5
    score_threshold: float = 0.0


class RetrievalRequest(BaseModel):
    knowledge_id: str
    query: str
    retrieval_setting: RetrievalSetting = Field(default_factory=RetrievalSetting)


def _check_auth(authorization: str | None):
    """驗證 Dify 帶來的 Bearer Token。"""
    if not authorization or not authorization.startswith("Bearer "):
        # Dify 規格：錯誤碼 1001 = 無效的 Authorization header 格式
        raise HTTPException(status_code=403, detail={"error_code": 1001,
                            "error_msg": "Invalid Authorization header format."})
    token = authorization.split(" ", 1)[1].strip()
    if token != EXPECTED_BEARER:
        # 1002 = 授權失敗
        raise HTTPException(status_code=403, detail={"error_code": 1002,
                            "error_msg": "Authorization failed."})


@app.get("/health")
async def health():
    return {"status": "ok", "rag_ready": _rag is not None}


@app.post("/retrieval")
async def retrieval(req: RetrievalRequest, authorization: str | None = Header(default=None)):
    _check_auth(authorization)
    if _rag is None:
        raise HTTPException(status_code=503, detail="RAG 尚未就緒")

    # 用 mix 模式：同時走向量檢索與知識圖譜，only_need_context 只回脈絡不直接生成答案
    param = QueryParam(
        mode="mix",
        only_need_context=True,
        top_k=req.retrieval_setting.top_k,
    )
    context = await _rag.aquery(req.query, param=param)

    if not context or not str(context).strip():
        return JSONResponse({"records": []})

    # LightRAG 回傳的是一段整合好的脈絡（實體 + 關係 + 相關片段）。
    # 對 Dify 而言一筆 record 即可被注入到 prompt；score 給 1.0 表示來自圖譜檢索。
    records = [{
        "content": str(context),
        "score": 1.0,
        "title": "GraphRAG context (向量 + 圖譜)",
        "metadata": {"source": "lightrag", "mode": "mix",
                     "knowledge_id": req.knowledge_id},
    }]
    return JSONResponse({"records": records})
