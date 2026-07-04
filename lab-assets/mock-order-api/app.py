"""Mock 訂單查詢 API — 給 Lab 2 的 Dify tool calling demo 用。

提供一個假的訂單系統，讓 Dify 客服 bot 在被問「我的訂單到哪了」時，
能呼叫工具 get_order_status 取回 JSON。資料來自 orders.json，查無資料時回 404。

啟動：
    uvicorn app:app --host 0.0.0.0 --port 8080
或用 Docker（見 Dockerfile）。
"""
import json
import os
from pathlib import Path

from fastapi import Depends, FastAPI, Header, HTTPException

app = FastAPI(
    title="醇焙手沖咖啡 — Mock 訂單 API",
    description="教學用假訂單系統（Lab 2 tool calling demo）",
    version="1.0.0",
)

ORDERS = json.loads((Path(__file__).parent / "orders.json").read_text(encoding="utf-8"))

# 選用式 Bearer 驗證：有設 API_TOKEN 環境變數才啟用（課堂自架不設＝無驗證；雲端設了＝要驗證）。
API_TOKEN = os.environ.get("API_TOKEN")


def require_token(authorization: str = Header(default=None)):
    if not API_TOKEN:
        return  # 未設 token → 不驗證（維持課堂/本機原行為）
    if authorization != f"Bearer {API_TOKEN}":
        raise HTTPException(status_code=401, detail="unauthorized: missing or invalid Bearer token")


@app.get("/health")
def health():
    # 健康檢查不需 token，方便 Cloud Run/監控探測。
    return {"status": "ok", "orders_loaded": len(ORDERS), "auth": bool(API_TOKEN)}


@app.get("/order/{order_id}", operation_id="get_order_status", dependencies=[Depends(require_token)])
def get_order_status(order_id: str):
    """查詢單一訂單狀態。order_id 例：A1001。"""
    order = ORDERS.get(order_id.upper().strip())
    if not order:
        raise HTTPException(
            status_code=404,
            detail=f"查無訂單 {order_id}，請確認訂單編號（範例：A1001）。",
        )
    return {"order_id": order_id.upper().strip(), **order}
