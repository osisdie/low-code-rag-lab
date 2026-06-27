"""共用的 LightRAG 初始化工廠。

ingest.py 與 dify_retrieval_adapter.py 都用這支建立同一個 LightRAG 實例，
讓「灌資料」與「查詢」共用同一份工作目錄（圖譜 + 向量索引）。

注意：LightRAG 的 init API 會隨版本演進。本範例對齊 requirements.txt 釘住的
lightrag-hku==1.3.0；若升級版本而報錯，請對照官方 README 的最新初始化寫法調整本檔。
"""
import os
from functools import partial

from dotenv import load_dotenv
from lightrag import LightRAG
from lightrag.llm.openai import openai_complete_if_cache, openai_embed
from lightrag.utils import EmbeddingFunc
from lightrag.kg.shared_storage import initialize_pipeline_status

load_dotenv()

WORKING_DIR = os.getenv("LIGHTRAG_WORKING_DIR", "./rag_storage")
LLM_MODEL = os.getenv("LLM_MODEL", "gpt-4o-mini")
EMBEDDING_MODEL = os.getenv("EMBEDDING_MODEL", "text-embedding-3-small")
API_KEY = os.getenv("OPENAI_API_KEY")
API_BASE = os.getenv("OPENAI_API_BASE", "https://api.openai.com/v1")

# 嵌入維度依模型而定：text-embedding-3-small=1536、BGE-M3=1024。用 env 切換。
EMBEDDING_DIM = int(os.getenv("EMBEDDING_DIM", "1536"))
MAX_TOKEN_SIZE = 8192

# 圖儲存後端：設了 NEO4J_URI 就用 Neo4j（課堂 GCP 環境，可視覺化）；
# 否則用 LightRAG 預設的檔案式 NetworkX（公開 take-home 輕量模式）。
# Neo4j 連線參數（NEO4J_URI / NEO4J_USERNAME / NEO4J_PASSWORD / NEO4J_DATABASE）
# 由 LightRAG 的 Neo4JStorage 直接讀取環境變數。
GRAPH_STORAGE = "Neo4JStorage" if os.getenv("NEO4J_URI") else "NetworkXStorage"


async def _llm_complete(prompt, system_prompt=None, history_messages=None, **kwargs):
    return await openai_complete_if_cache(
        LLM_MODEL,
        prompt,
        system_prompt=system_prompt,
        history_messages=history_messages or [],
        api_key=API_KEY,
        base_url=API_BASE,
        **kwargs,
    )


async def _embed(texts):
    return await openai_embed(
        texts,
        model=EMBEDDING_MODEL,
        api_key=API_KEY,
        base_url=API_BASE,
    )


async def build_rag() -> LightRAG:
    """建立並初始化一個可用的 LightRAG 實例。"""
    os.makedirs(WORKING_DIR, exist_ok=True)
    rag = LightRAG(
        working_dir=WORKING_DIR,
        llm_model_func=_llm_complete,
        embedding_func=EmbeddingFunc(
            embedding_dim=EMBEDDING_DIM,
            max_token_size=MAX_TOKEN_SIZE,
            func=_embed,
        ),
        graph_storage=GRAPH_STORAGE,
    )
    await rag.initialize_storages()
    await initialize_pipeline_status()
    return rag
