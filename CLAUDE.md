# low-code-rag-lab — project notes for Claude Code

三階段 AI 客服機器人工作坊（No-Code → Low-Code → Advanced 向量+圖譜 RAG）的**教學素材庫 + 可實跑實驗室**。
首梯已開課完畢，repo 現為可重複開課的 kit。對外 repo 是 **public**，提交前務必去敏。

## 結構（細節見 README.md）
- `docs/student/` 學員手冊（md/html/pdf）、`docs/student/simple/` 超白話版
- `docs/instructor-template/` 講師教案**去敏範本**（進版控）
- `docs/instructor/` 講師實際版（含名單、憑證）— **被 .gitignore 忽略，只存本機**
- `slides/` 投影片（`handbook.html` 為主檔）｜`lab-assets/` Lab 素材（knowledge-base、prompts、dify、mock-order-api、line-bridge、graphrag）
- `functions/line-webhook/` LINE ↔ Dify Cloud Function｜`infra/` GCP Terraform + 佈署腳本｜`obsidian/` 「只答 vault」問答 vault
- `scripts/` `preflight.sh`（煙霧測試）、`start-all.sh` / `stop-all.sh`、`deploy-line-webhook.sh`

## 常用指令
- 煙霧測試：`bash scripts/preflight.sh`（需先 `cp infra/learner/.env.example infra/learner/.env` 填值）
- GraphRAG 實驗室：`cd lab-assets/graphrag && cp .env.example .env && docker compose up -d && python ingest.py`
- 授課環境：`cd infra/terraform && terraform apply`（見 `infra/README.md`；**不會自動關機**，課後請手動停機或 `terraform destroy`）

## 硬規則（資料衛生）
- **永遠不要提交**：學員名單、帳密、API key／LINE token、真實 VM IP、GCP project number、Q&A 表單連結／QR、`.env`、`*.tfstate`、`*.tfvars`。
- 不要改動／搬移本機 `docs/instructor/` 內的原檔；要分享內容時**複製到 `docs/instructor-template/` 再去敏**，提交前用 `git grep` 掃 `sk-`、`app-`、`Bearer`、IP。
- `docs/student/` 的 PDF/HTML 由對應 md 產生，改 md 後記得重產；`docs/instructor-template/` 只收 md（PDF 一律不進版控，需要時本機自行產生）。
- commit 訊息不加 AI 署名（Co-Authored-By / Generated with …）。

## 語言與風格
- 文件以**繁體中文**為主；用語用「ChatGPT / Dify / 工程做法」，不要用「第一招/二招/三招」。
- 範例公司（綠野鮮蔬餐廳、醇焙手沖咖啡）皆為虛構。
