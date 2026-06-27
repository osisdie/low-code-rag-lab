"""LINE ↔ Dify 橋接服務（Lab 2「真的串 LINE OA」用）。

Dify 沒有原生 LINE 通路，這支小服務負責：
  1. 接 LINE Messaging API 的 webhook（驗證簽章）
  2. 把使用者訊息轉給 Dify 的 /chat-messages API
  3. 把 Dify 的回覆用 LINE reply API 送回

每個 LINE 使用者維持一個 Dify conversation_id，保留上下文。

啟動：
    uvicorn app:app --host 0.0.0.0 --port 8090
LINE webhook 設成： https://<你的Dify網域>/line/webhook
（實務上 Caddy 會把 /line/webhook 反代到本服務；或直接把 LINE webhook 指到本服務的公開網址）
"""
import base64
import hashlib
import hmac
import os

import httpx
from fastapi import FastAPI, Header, HTTPException, Request

LINE_CHANNEL_SECRET = os.environ["LINE_CHANNEL_SECRET"]
LINE_CHANNEL_ACCESS_TOKEN = os.environ["LINE_CHANNEL_ACCESS_TOKEN"]
DIFY_API_BASE = os.getenv("DIFY_API_BASE", "http://localhost/v1")
DIFY_APP_KEY = os.environ["DIFY_APP_KEY"]

LINE_REPLY_URL = "https://api.line.me/v2/bot/message/reply"

app = FastAPI(title="LINE ↔ Dify bridge")

# lineUserId -> dify conversation_id（記憶體版，重啟會清空；課堂夠用）
_conversations: dict[str, str] = {}


def _verify_signature(body: bytes, signature: str | None) -> bool:
    mac = hmac.new(LINE_CHANNEL_SECRET.encode(), body, hashlib.sha256).digest()
    expected = base64.b64encode(mac).decode()
    return signature is not None and hmac.compare_digest(expected, signature)


async def _ask_dify(user_id: str, text: str) -> str:
    payload = {
        "inputs": {},
        "query": text,
        "response_mode": "blocking",
        "user": user_id,
        "conversation_id": _conversations.get(user_id, ""),
    }
    headers = {"Authorization": f"Bearer {DIFY_APP_KEY}"}
    async with httpx.AsyncClient(timeout=60) as client:
        r = await client.post(f"{DIFY_API_BASE}/chat-messages", json=payload, headers=headers)
        r.raise_for_status()
        data = r.json()
    if data.get("conversation_id"):
        _conversations[user_id] = data["conversation_id"]
    return data.get("answer", "（目前無法回覆，請稍候）")


async def _reply_line(reply_token: str, text: str):
    headers = {"Authorization": f"Bearer {LINE_CHANNEL_ACCESS_TOKEN}"}
    payload = {"replyToken": reply_token, "messages": [{"type": "text", "text": text[:5000]}]}
    async with httpx.AsyncClient(timeout=30) as client:
        await client.post(LINE_REPLY_URL, json=payload, headers=headers)


@app.get("/health")
async def health():
    return {"status": "ok"}


@app.post("/line/webhook")
async def webhook(request: Request, x_line_signature: str | None = Header(default=None)):
    body = await request.body()
    if not _verify_signature(body, x_line_signature):
        raise HTTPException(status_code=403, detail="bad signature")

    events = (await request.json()).get("events", [])
    for ev in events:
        if ev.get("type") == "message" and ev.get("message", {}).get("type") == "text":
            user_id = ev.get("source", {}).get("userId", "anon")
            text = ev["message"]["text"]
            answer = await _ask_dify(user_id, text)
            await _reply_line(ev["replyToken"], answer)
    return {"ok": True}
