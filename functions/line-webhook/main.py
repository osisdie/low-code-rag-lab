"""LINE webhook 作為 GCP Cloud Function（2nd gen, HTTP trigger）。

用途：
  1. 作為穩定的 HTTPS webhook 端點，讓 LINE Developers Console 的「Verify」通過
     （不依賴 VM 是否開機）。
  2. 驗證 X-Line-Signature；收到文字訊息時轉給 Dify 客服 app，再用 LINE reply API 回覆。
     （Dify 尚未設好時，回一句佔位訊息，仍讓驗證/連線成功。）

環境變數（部署時 --set-env-vars）：
  LINE_CHANNEL_SECRET        必填
  LINE_CHANNEL_ACCESS_TOKEN  必填
  DIFY_API_BASE              選填，例 https://<teacher-dify>/v1（Dify 起來後再設）
  DIFY_APP_KEY               選填，Dify app 的 API key
"""
import base64
import hashlib
import hmac
import os

import functions_framework
import requests

CHANNEL_SECRET = os.environ["LINE_CHANNEL_SECRET"]
ACCESS_TOKEN = os.environ["LINE_CHANNEL_ACCESS_TOKEN"]
DIFY_API_BASE = os.environ.get("DIFY_API_BASE", "").rstrip("/")
DIFY_APP_KEY = os.environ.get("DIFY_APP_KEY", "")

LINE_REPLY_URL = "https://api.line.me/v2/bot/message/reply"
_conversations: dict[str, str] = {}


def _valid_signature(body: bytes, signature: str) -> bool:
    mac = hmac.new(CHANNEL_SECRET.encode(), body, hashlib.sha256).digest()
    return hmac.compare_digest(base64.b64encode(mac).decode(), signature or "")


def _ask_dify(user_id: str, text: str) -> str:
    if not (DIFY_API_BASE and DIFY_APP_KEY):
        return "（LINE 已成功連線；Dify 客服 app 尚未設定，設定後即可正常回覆。）"
    payload = {
        "inputs": {}, "query": text, "response_mode": "blocking",
        "user": user_id, "conversation_id": _conversations.get(user_id, ""),
    }
    r = requests.post(f"{DIFY_API_BASE}/chat-messages", json=payload,
                      headers={"Authorization": f"Bearer {DIFY_APP_KEY}"}, timeout=60)
    r.raise_for_status()
    data = r.json()
    if data.get("conversation_id"):
        _conversations[user_id] = data["conversation_id"]
    return data.get("answer", "（目前無法回覆，請稍候）")


def _reply(reply_token: str, text: str):
    requests.post(LINE_REPLY_URL,
                  json={"replyToken": reply_token, "messages": [{"type": "text", "text": text[:5000]}]},
                  headers={"Authorization": f"Bearer {ACCESS_TOKEN}"}, timeout=30)


@functions_framework.http
def line_webhook(request):
    body = request.get_data()
    if not _valid_signature(body, request.headers.get("X-Line-Signature", "")):
        return ("bad signature", 403)
    # LINE「Verify」會送空 events；簽章對就回 200 即通過。
    events = (request.get_json(silent=True) or {}).get("events", [])
    for ev in events:
        if ev.get("type") == "message" and ev.get("message", {}).get("type") == "text":
            answer = _ask_dify(ev.get("source", {}).get("userId", "anon"), ev["message"]["text"])
            _reply(ev["replyToken"], answer)
    return ("OK", 200)
