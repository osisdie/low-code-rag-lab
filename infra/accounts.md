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

| 人 | learner VM | Dify 網址（http） | Neo4j 帳號 | Neo4j database |
|----|-----------|--------------------|-----------|----------------|
| 老師 | lab-teacher | http://&lt;ip&gt; | teacher | labteacher |
| 學員1 | lab-student1 | http://&lt;ip&gt; | student1 | labstudent1 |
| 學員2 | lab-student2 | http://&lt;ip&gt; | student2 | labstudent2 |
| 學員3 | lab-student3 | http://&lt;ip&gt; | student3 | labstudent3 |
| 學員4 | lab-student4 | http://&lt;ip&gt; | student4 | labstudent4 |
| 學員5 | lab-student5 | http://&lt;ip&gt; | student5 | labstudent5 |
| 學員6 | lab-student6 | http://&lt;ip&gt; | student6 | labstudent6 |
| 學員7 | lab-student7 | http://&lt;ip&gt; | student7 | labstudent7 |
| 學員8 | lab-student8 | http://&lt;ip&gt; | student8 | labstudent8 |

- 各人外部 IP：`terraform output learners` 取得後填入。
- Neo4j 初始密碼：預設全部 = `neo4j_password`（distinct 帳號 + database 已做到隔離）；要更安全可登入後各自改密。
- 共用服務：LiteLLM `http://<svc-ip>:4000/v1`（key=master）、Neo4j Browser `http://<svc-ip>:7474`。
