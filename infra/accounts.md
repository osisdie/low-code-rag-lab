# 第三方帳號清單 + 帳密矩陣

> ⚠️ 本檔含密碼欄位，**請勿**提交真實密碼到 git（`accounts.local.md` 已被 .gitignore；
> 要記真實值請另存為 `accounts.local.md`）。本檔為範本/清單。

## 一、課前要備妥的第三方帳號

| 服務 | 用途 | 誰準備 | 備註 |
|------|------|--------|------|
| **GCP 專案**（$300 trial） | 跑全部 VM + Vertex | 老師 | 已 `gcloud auth login`；`gcloud auth application-default login` 給 Terraform |
| **Vertex AI**（啟用 API） | Gemini LLM | 老師 | Terraform 會啟用 `aiplatform.googleapis.com` |
| **HuggingFace token** | TEI 下載 BGE-M3 | 老師 | `HF_TOKEN`，read 權限即可 |
| **LINE Developers**（Messaging API channel） | Lab 2 真接 LINE | 老師（學員課中各自建） | 取 Channel secret + access token |
| **Neo4j Enterprise**（dev 授權） | Stage 3 圖譜 | 老師 | compose 用 `NEO4J_ACCEPT_LICENSE_AGREEMENT=yes`（教育/評估） |
| GitHub repo（public） | 各 VM clone | 老師 | `repo_url` |

## 二、Terraform 變數（填 `terraform/terraform.tfvars`）
`project_id`、`litellm_master_key`、`hf_token`、`neo4j_password`、`graphrag_key`、（選）`billing_account`。

## 三、每人帳密矩陣（上課發給學員）

| 人 | learner VM | Dify 網址（sslip） | Neo4j 帳號 | Neo4j database |
|----|-----------|--------------------|-----------|----------------|
| 老師 | lab-teacher | https://&lt;ip&gt;.sslip.io | teacher | lab_teacher |
| 學員1 | lab-student1 | https://&lt;ip&gt;.sslip.io | student1 | lab_student_1 |
| 學員2 | lab-student2 | https://&lt;ip&gt;.sslip.io | student2 | lab_student_2 |
| 學員3 | lab-student3 | https://&lt;ip&gt;.sslip.io | student3 | lab_student_3 |
| 學員4 | lab-student4 | https://&lt;ip&gt;.sslip.io | student4 | lab_student_4 |
| 學員5 | lab-student5 | https://&lt;ip&gt;.sslip.io | student5 | lab_student_5 |
| 學員6 | lab-student6 | https://&lt;ip&gt;.sslip.io | student6 | lab_student_6 |
| 學員7 | lab-student7 | https://&lt;ip&gt;.sslip.io | student7 | lab_student_7 |
| 學員8 | lab-student8 | https://&lt;ip&gt;.sslip.io | student8 | lab_student_8 |

- 各人 IP / sslip 網域：`terraform output learners` 取得後填入。
- Neo4j 初始密碼：預設全部 = `neo4j_password`（distinct 帳號 + database 已做到隔離）；要更安全可登入後各自改密。
- 共用服務：LiteLLM `http://<svc-ip>:4000/v1`（key=master）、Neo4j Browser `http://<svc-ip>:7474`。
