# infra/ — GCP 授課環境（老師 + 最多 8 學員）

一鍵在 GCP 建出：1 台共用服務 VM（LiteLLM→Vertex Gemini、Neo4j Enterprise、BGE-M3）
+ 每人一台 learner VM（Dify + graphrag + mock API + LINE 橋接 ，Dify 走 HTTP，LINE 由 Cloud Function 處理 HTTPS）。

```
terraform/   Terraform：VM、網路、IAM、預算、每日自動關機（student_count 控制人數）
provision/   開機啟動腳本（svc-setup.sh / learner-setup.sh，Terraform 注入）
svc/         共用服務 docker-compose（LiteLLM + Neo4j + TEI）
litellm/     LiteLLM config（Vertex gemini-2.5-flash/-lite + bge-m3）
neo4j/       多租戶初始化 cypher + 視覺化說明
learner/     每台 learner 的個人服務 compose
accounts.md  第三方帳號清單 + 每人帳密矩陣
```

## 佈署
```bash
gcloud auth application-default login        # Terraform 用
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars # 填 project_id / litellm_master_key / hf_token / neo4j_password
terraform init
terraform apply -var student_count=1         # 彩排先 1 人省錢，正式改 8
terraform output                             # 拿各人外部 IP / Neo4j db
```

## 成本與護欄
- 9× e2-standard-4 + 1× e2-standard-8 ≈ **$1.5/hr**；每日 20:00 自動關機。
- 籌備+彩排+上課 ~40hr ≈ **$45–60**；Vertex token 量小。遠低於 $300。
- 預算告警（填 `billing_account` 才啟用）50/80/100%。
- **拆除**：`terraform destroy`。

## 注意
- 機密（LiteLLM/Neo4j/HF）經 instance metadata 傳遞，屬短期教學環境作法；正式環境請改 Secret Manager。
- UI 步驟（Dify 模型供應商、知識庫、app、LINE 綁定）無法腳本化，開機後寫在各 VM 的 `/etc/motd`。
- 詳細維運見 `../docs/instructor/env-operations.md`（講師用）。
