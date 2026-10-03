# 講師教案範本（去敏版，可重複使用）

這是 `docs/instructor/`（講師本機實際版，被 `.gitignore` 忽略）的**去敏範本**，讓下一梯次可以沿用：
時間表、各 Stage 教案、口白稿、彩排 checklist、環境維運與預算收尾。

**這裡刻意沒有**：學員名單、任何帳密／金鑰／token／真實 IP、Q&A 表單的 QR code 與連結、產生出來的 PDF/HTML。

## 內容

| 檔案 | 用途 |
|---|---|
| `instructor-00-overview-and-pacing.md` | 全場時間表與節奏（日期、場地、人數為 `<…>` 欄位） |
| `instructor-stage-1-nocode.md` / `-stage-2-lowcode.md` / `-stage-3-advanced-rag.md` | 三階段教案 |
| `instructor-closing-budget-action.md` | 收尾：預算範本 + 1週/1月/3月 行動清單 |
| `講師口白稿.md` | 逐段口白（PDF/HTML 需要時自行由 md 產生） |
| `teacher-rehearsal-checklist.md` | 老師彩排 Checklist & Rundown（逐欄位設定、Lab 題目與預期答） |
| `learner-rehearsal-checklist.md` | 以學員視角預演的卡點與對策 |
| `rehearsal-runbook.md` | Labs 1–3 逐段彩排 + LINE 真機實測 |
| `dify-cloud-e2e-verify.md` | 在 Dify Cloud 端對端驗證（知識庫、工具、LINE） |
| `env-operations.md` / `lab-environment-plan.md` | GCP 環境佈署、teardown、成本維運 |
| `quiz-warm-up.md` / `free-tools-demo-notes.md` | 暖身測驗題庫、免費工具示範筆記（私人連結已移除） |
| `bonus.html`, `faq.xlsx`, `img/stage3/` | 加碼頁、Q&A 表單範本（空白）、備援截圖 |
| `dify/README.example.md` | 憑證變數**範本**（只有名稱與 placeholder） |

## Placeholder 對照

`<VM_IP>` 外部 IP｜`<INTERNAL_IP>` 內部 IP｜`<LITELLM_KEY>` LiteLLM key｜`<DIFY_APP_KEY>` / `<DIFY_APP_ID>` Dify app｜
`<LINE_CHANNEL_SECRET>` / `<LINE_CHANNEL_ACCESS_TOKEN>` LINE｜`<NEO4J_PASSWORD>`｜`<API_TOKEN>` 訂單 API Bearer｜
`<GCP_PROJECT_ID>` / `<GCP_PROJECT_NUMBER>`｜`<DATE>` `<VENUE>` `<CAPACITY>` 開課資訊。

## 下次開課怎麼用

1. 複製整個資料夾到本機 `docs/instructor/`（該路徑被 `.gitignore` 忽略，實際值不會被提交）：
   `cp -r docs/instructor-template/. docs/instructor/`
2. 把 `<…>` 換成這梯次的實際值；憑證寫進 `docs/instructor/dify/README.md`（參考 `README.example.md`）。
3. 學員名單放 `docs/instructor/學員名單.md`（只留本機，**不要進版控**）。
4. 重新建立 Q&A 表單與 QR code（本範本不含舊的）。
5. 有新心得時，**回寫範本前先去敏**，再提交。

> 提交前自我檢查：`git grep -nE 'sk-|app-[A-Za-z0-9]{10,}|Bearer |@gmail'` 與 IP 掃描應無命中。
