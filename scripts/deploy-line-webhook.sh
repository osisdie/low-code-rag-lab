#!/usr/bin/env bash
# 部署 LINE webhook Cloud Function 到指定專案。
# 因 org policy (automaticIamGrantsForDefaultServiceAccounts 啟用) 不會自動給
# Cloud Build 預設 SA 權限，這裡手動補上，否則 build 會失敗。
#
# 用法：scripts/deploy-line-webhook.sh <project_id> [region]
# 需求：repo 根目錄 .env 內有 LINE_CHANNEL_SECRET / LINE_CHANNEL_ACCESS_TOKEN
#       （選填 DIFY_API_BASE / DIFY_APP_KEY，Dify 起來後再帶入即可真正回覆）
set -euo pipefail
PROJECT="${1:?需要 project_id}"; REGION="${2:-asia-east1}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
set -a; . "$ROOT/.env"; set +a

echo "▶ 啟用 API …"
gcloud services enable cloudfunctions.googleapis.com cloudbuild.googleapis.com \
  run.googleapis.com artifactregistry.googleapis.com compute.googleapis.com --project "$PROJECT"

NUM=$(gcloud projects describe "$PROJECT" --format='value(projectNumber)')
CB_SA="${NUM}-compute@developer.gserviceaccount.com"
echo "▶ 補 Cloud Build SA 權限（org policy 不自動給）：$CB_SA"
for R in roles/cloudbuild.builds.builder roles/logging.logWriter roles/artifactregistry.writer roles/storage.objectViewer; do
  gcloud projects add-iam-policy-binding "$PROJECT" --member="serviceAccount:$CB_SA" --role="$R" --condition=None >/dev/null
  echo "   ✔ $R"
done

EXTRA=""
[ -n "${DIFY_API_BASE:-}" ] && EXTRA="${EXTRA},DIFY_API_BASE=${DIFY_API_BASE}"
[ -n "${DIFY_APP_KEY:-}" ] && EXTRA="${EXTRA},DIFY_APP_KEY=${DIFY_APP_KEY}"

echo "▶ 部署 line-webhook …"
gcloud functions deploy line-webhook --gen2 --runtime=python311 --region="$REGION" \
  --source="$ROOT/functions/line-webhook" --entry-point=line_webhook \
  --trigger-http --allow-unauthenticated --project "$PROJECT" \
  --set-env-vars "LINE_CHANNEL_SECRET=${LINE_CHANNEL_SECRET},LINE_CHANNEL_ACCESS_TOKEN=${LINE_CHANNEL_ACCESS_TOKEN}${EXTRA}"

echo; echo "✔ Webhook URL："
gcloud functions describe line-webhook --gen2 --region="$REGION" --project "$PROJECT" --format='value(serviceConfig.uri)'
