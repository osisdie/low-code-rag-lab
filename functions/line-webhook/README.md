# LINE webhook（GCP Cloud Function）

老師的 LINE OA（channel `2010532083`）用這個 Cloud Function 當 webhook：穩定 HTTPS、
能通過 LINE「Verify」，並把訊息轉給 Dify 客服 app。比 VM 上的 line-bridge 穩（不受 VM 開關機影響）。

## 需要的 LINE 資訊（請填到 repo 根目錄 `.env`）
從 https://developers.line.biz/console/channel/2010532083/ 取得：
- **Channel secret**：`Basic settings` → Channel secret → 填 `LINE_CHANNEL_SECRET`
- **Channel access token (long-lived)**：`Messaging API` → Channel access token → Issue → 填 `LINE_CHANNEL_ACCESS_TOKEN`

`.env` 追加：
```
LINE_CHANNEL_SECRET=xxxxxxxx
LINE_CHANNEL_ACCESS_TOKEN=xxxxxxxx
```

## 部署（部到穩定的 admin/quota 專案）
```bash
PROJECT=YOUR_ADMIN_PROJECT_ID                 # 穩定、已開 billing 的專案（例：admin/quota project）
REGION=asia-east1
gcloud services enable cloudfunctions.googleapis.com cloudbuild.googleapis.com \
  run.googleapis.com artifactregistry.googleapis.com --project $PROJECT

# 從 .env 帶入 LINE 憑證
set -a; . /mnt/c/writable/git/osisdie/low-code-rag-lab/.env; set +a

gcloud functions deploy line-webhook \
  --gen2 --runtime=python311 --region=$REGION \
  --source=. --entry-point=line_webhook \
  --trigger-http --allow-unauthenticated \
  --set-env-vars LINE_CHANNEL_SECRET="$LINE_CHANNEL_SECRET",LINE_CHANNEL_ACCESS_TOKEN="$LINE_CHANNEL_ACCESS_TOKEN" \
  --project $PROJECT
```
部署完成會給一個 URL，例：`https://asia-east1-<proj>.cloudfunctions.net/line-webhook`

## 設到 LINE
1. LINE Console → `Messaging API` → **Webhook URL** 填上面的 URL → **Verify**（應顯示 Success）。
2. 開啟 **Use webhook**；關閉 **Auto-reply messages / Greeting**（避免干擾）。

## 接上 Dify（老師 Dify 起來後）
Dify app 建好、拿到 app API key 後，更新 function 環境變數即可開始真正對話：
```bash
gcloud functions deploy line-webhook --gen2 --region=$REGION --source=. \
  --entry-point=line_webhook --trigger-http --allow-unauthenticated --project $PROJECT \
  --set-env-vars LINE_CHANNEL_SECRET="$LINE_CHANNEL_SECRET",LINE_CHANNEL_ACCESS_TOKEN="$LINE_CHANNEL_ACCESS_TOKEN",DIFY_API_BASE="https://<teacher-dify>/v1",DIFY_APP_KEY="app-xxxx"
```
（在 Dify app 設好之前，function 會回一句「已連線、Dify 尚未設定」的佔位訊息，Verify 仍會成功。）
