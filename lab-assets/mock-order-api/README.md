# Mock 訂單 API（Lab 2 tool calling demo）

假的訂單查詢服務，讓 Dify 客服 bot 在被問「我的訂單到哪了」時呼叫工具取回 JSON。

## 跑起來
```bash
# Docker
docker build -t mock-order-api . && docker run -p 8080:8080 mock-order-api
# 或本機
pip install -r requirements.txt && uvicorn app:app --host 0.0.0.0 --port 8080
```

## 測試
```bash
curl http://localhost:8080/health
curl http://localhost:8080/order/A1001   # 已出貨
curl http://localhost:8080/order/A1002   # 烘焙中
curl http://localhost:8080/order/Z9999   # 404 查無
```

## 接到 Dify
1. Dify →「工具」→「建立自訂工具」。
2. 貼上 `dify-tool-openapi.yaml`，把 `servers.url` 改成本服務網址。
3. 在客服 app 的 prompt 允許呼叫 `get_order_status`（見 `../prompts/advanced-prompt.txt`）。

## 範例訂單
| 訂單 | 狀態 |
|------|------|
| A1001 | 已出貨（明天到） |
| A1002 | 烘焙中 |
| A1003 | 已送達 |
| A1004 | 待付款 |
