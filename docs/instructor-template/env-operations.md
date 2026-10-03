# 環境維運（講師用）

> GCP 授課環境的佈署 / 開關 / 拆除 / 成本。架構與檔案見 `../../infra/`。

## 一、首次佈署（課前 1–2 天）
```bash
gcloud auth login
gcloud auth application-default login        # Terraform 用
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars # 填 project_id / litellm_master_key / hf_token / neo4j_password
terraform init
terraform apply -var student_count=1         # 先 1 人試跑
terraform output                             # 拿網址/IP/sslip/Neo4j db
```
開機腳本自動裝好 Docker、Dify、個人服務、Neo4j 帳號。**UI 步驟**（Dify 模型供應商、知識庫、app、LINE 綁定）見各 VM 的 `/etc/motd`。

## 二、試跑通過後擴編（首梯實際改採「全班共用一台 Dify」，見 teacher-rehearsal-checklist「架構決策」）
```bash
terraform apply -var student_count=8
```
把 `terraform output learners` 的網址/帳密填進 `../../infra/accounts.md`（真值存 `accounts.local.md`）發給學員。

## 三、開關機（保護 credit）
- **目前不設自動關機**（課前持續有人驗證）；用完請手動停機或 `terraform destroy`。
- 上課當天手動開機：
  ```bash
  gcloud compute instances start $(gcloud compute instances list --format='value(name)') --zone asia-east1-b
  ```
- 手動關機：把 `start` 換成 `stop`。

## 四、健康檢查
- SSH 進任一 learner VM：`ssh lab@<ip>` → `bash /opt/lab/scripts/preflight.sh`（全綠才開課）。
- 服務沒起來：`cd /opt/lab/infra/learner && docker compose ps / logs`；Dify 在 `/opt/dify/docker`。

## 五、成本
- 執行中 ≈ $1.5/hr（9 學員機規模）。籌備+試跑+上課 ~40hr ≈ $45–60。Vertex token 量小。
- 監看：`gcloud billing` 或 GCP Console → Billing。預算告警在 50/80/100%（需填 `billing_account`）。

## 六、課後拆除（重要，停止計費）
```bash
cd infra/terraform
terraform destroy
```
確認 GCP Console 無殘留 VM / 磁碟 / 外部 IP。

## 七、常見問題
- **GPU**：free trial 無 GPU quota，本環境不用 GPU（LLM 走 Vertex、BGE-M3 跑 CPU）。地端 Qwen 屬課後選配（需升級付費 + 申請 quota）。
- **Caddy 拿不到憑證**：確認 80/443 防火牆開、sslip 網域解析到外部 IP。
- **Dify cloud 連不到地端**：本環境 Dify 為自架，無此問題；外部知識庫走同台或 svc 內網。
- **LiteLLM 連不到 Vertex**：確認 svc VM 的 SA 有 `roles/aiplatform.user` 且 `VERTEX_LOCATION` 有該模型。
