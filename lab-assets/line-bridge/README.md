# LINE ↔ Dify 橋接（Lab 2 真接 LINE OA）

Dify 沒有原生 LINE 通路，這支服務把 LINE webhook 接到 Dify 的 chat API，做出真的能用手機對話的客服 bot。

```
手機 LINE → LINE 平台 → (webhook) → line-bridge → Dify /chat-messages → 回覆 → LINE → 手機
```

## 設定步驟
1. **建 LINE OA + channel**：到 [LINE Developers](https://developers.line.biz/)，建 Provider → Messaging API channel。
   取得 **Channel secret** 與 **Channel access token（long-lived）**。關閉「自動回覆訊息」、開啟「Webhook」。
2. **拿 Dify app key**：Dify 客服 app →「存取 API」→ 產生 API key，並記下 API base（self-host 通常 `https://<你的Dify網域>/v1`）。
3. **跑橋接**：
   ```bash
   cp .env.example .env   # 填 LINE 與 Dify 的值
   docker build -t line-bridge . && docker run -p 8090:8090 --env-file .env line-bridge
   ```
4. **設 webhook URL**：在 LINE channel 設定填 `https://<你的公開網域>/line/webhook`
   （Caddy 反代 `/line/webhook` → 本服務 :8090；見 `../../infra/` 的 Caddy 設定）。
5. **驗證**：手機加好友 → 傳「你們運費怎麼算？」→ 應收到 Dify 知識庫的回覆。

## 注意
- 本服務驗證 `X-Line-Signature`，簽章不符回 403。
- conversation 對應存記憶體，重啟會清空上下文（課堂足夠）。
- LINE reply token 有時效，且每則 webhook 只能 reply 一次。
