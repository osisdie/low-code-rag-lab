# 學員視角彩排 Checklist（預演學員會遇到的問題）

> 講師用範本（已去敏）。`<PLACEHOLDER>` 請換成實際值；實際值（IP、金鑰、帳密）只放本機 `docs/instructor/`，**勿提交進 repo**。
> 在一台「學員機」上以學員視角走一遍，先把學員會卡的地方抓出來。
>
> 📘 圖文操作手冊（給非工程學員、可重現）：`docs/student/student-onboarding-illustrated.md`（onboard → Stage 1 → Stage 2 全流程截圖）。

## 學員機環境（填入實際值）

| 用途 | 值 |
|------|----|
| 學員 Dify 主控台 | `http://<VM_IP>`（首次登入要建管理員帳號，見 `dify/README.example.md`） |
| 模型供應商 Base（Dify 內填） | `http://<INTERNAL_IP>:4000/v1`、Key `<LITELLM_KEY>` |
| 可用 LLM | `gemini-2.5-flash`、`gemini-2.5-flash-lite`（學員可與老師交錯切換做 A/B） |
| graphrag 外部知識庫 | `http://<INTERNAL_IP>:8000`、Key `<GRAPHRAG_API_KEY>`、ID `coffee` |
| 訂單工具 server url | `http://<INTERNAL_IP>:8080` |
| Neo4j（共用） | Browser `http://<VM_IP>:7474`、bolt `bolt://<VM_IP>:7687`、帳號 `<NEO4J_USER>`、db `<NEO4J_DB>` |
| 自檢 | `ssh lab@<VM_IP> 'bash /opt/lab/scripts/preflight.sh'`（應 9/9） |

> 註：每台學員 VM 的「內部服務」都跑在自己 VM 上，對學員而言位址一致、好記。

---

## 預演要驗證的「學員會卡點」與對策

### Stage 1（ChatGPT）— 卡點：沒有可用帳號
- [ ] 學員沒有 ChatGPT 帳號？→ 改用 **Gemini / Claude**（同樣可上傳檔案 + 系統提示），或老師備一個共用帳號
- [ ] 上傳檔案：餐廳 FAQ 連結（見 teacher checklist 素材區）
- [ ] ⚠️ 嚴格提示下現代模型**不一定**幻覺/脫線（會正確說「不確定」、會拒寫 Python）。
      可靠演法＝「鬆散提示」對比：問「20 人包場費用？能幫我線上訂位付訂金？」→ 會編價且只能叫你來電（不能真的訂）。詳見 teacher checklist Lab 1 Demo ①②

### Stage 2（Dify）— 卡點最多
- [ ] **首次登入要建管理員帳號**（self-host 每台獨立）；學員不知道 → 明確指引 `http://<VM_IP>/install`
- [ ] **必須先設模型供應商**（OpenAI-API-compatible 外掛 → 安裝 → 填 Base/Key → 加 gemini-2.5-flash + bge-m3/1024）。
      最常見錯誤：① 跳過這步直接建知識庫 → 失敗 ② Base 沒加 `/v1` ③ 忘了加 embedding 模型 ④ 維度填錯（要 1024）
- [ ] **HTTP 非 HTTPS**：網址是 `http://`，瀏覽器可能顯示「不安全」→ 正常，按繼續
- [ ] 知識庫建立步驟見 teacher checklist **B2 逐步**（Knowledge→Create→上傳→High Quality→bge-m3→Vector Search→Save & Process）
- [ ] 索引 Embedding 應自動帶 **bge-m3**（已設為 Default Model）；若空白手選 bge-m3，別選到 OpenAI
- [ ] App 類型要選 **Agent**（不是 Chatbot——Chatbot 沒有 Tools 區），訂單工具見 teacher **B3**
- [ ] 工具 server url 用內部 IP `http://<INTERNAL_IP>:8080`（不是 localhost）
- [ ] 若工具回「查詢發生錯誤」：Dify SSRF proxy 擋內網所致；新 VM 已由 `learner-setup.sh` 自動放行，既有機器跑 teacher **B3③** 修正
- [ ] widget 嵌到外部 HTTPS 頁面會被擋（mixed content）→ demo 用 Dify 內建預覽即可

### Stage 3（圖譜）— 卡點：以為要自己灌
- [ ] graphrag 已在 VM 上**自動灌好**（adapter 已 reload）→ 學員只需在 Dify 連外部知識庫
- [ ] 外部知識庫 Endpoint `http://<INTERNAL_IP>:8000`（內部 IP，Dify 同機呼叫，**不要用瀏覽器開**）
- [ ] Neo4j Browser 連線：用 `bolt://`（非 bolt+s://）
- [ ] 對照題答案同 teacher（西達摩 / 氮氣冷萃 / 入門淺焙組 / 產區）
- [ ] **模型 A/B**：app 右上模型下拉切 `gemini-2.5-flash` ↔ `gemini-2.5-flash-lite`，同題比答案（lite 較快、多跳推理易漏）→ 與老師/其他學員交錯比對

### LINE（Stage 2 真機）— 最大時間坑
- [ ] 每位學員要自己的 LINE OA + Messaging API channel → 多數人沒有、且申請慢
- [ ] **建議**：LINE 真機只由老師示範；學員用 Dify 網站預覽 + widget 體驗對話即可
- [ ] 真要做：學員各自部署自己的 Cloud Function + 自己的 channel → **逐步教學見 `docs/student/student-line-setup.md`**

**LINE 逐步檢查（用一組測試 channel 先走一遍）：**

1. [ ] **Dify 端拿 app 金鑰**：Dify → 你的 app → 右上 **Publish** → **API Access → API Key → Create new secret key** → `<DIFY_APP_KEY>`
2. [ ] **部署 Cloud Function**（gen2、`<REGION>`、專案 `<GCP_PROJECT_ID>`）
   - 來源 `functions/line-webhook`（streaming 版）；env：`DIFY_API_BASE=http://<VM_IP>/v1`、`DIFY_APP_KEY=<DIFY_APP_KEY>`、LINE secret/token = 你的 channel
   - 取得 URI：`https://<CLOUD_FUNCTION_URL>`
3. [ ] **API 層驗證**：直接打 Dify app API → 訂單 A1001 回已出貨；對 CF 送正確簽章 → **200**、亂簽 → **403**
4. [ ] **LINE Console**：
   - Messaging API 分頁 → **Webhook settings → Webhook URL** 填上 CF URI → **Update**
   - 按 **Verify** → **Success**
   - **Use webhook** 切 **ON**（綠色）
   - 確認 **Auto-reply messages = Disabled**
   - ⚠️ 核對：channel access token 與 CF env 的 `LINE_CHANNEL_ACCESS_TOKEN` 一致（否則簽章/回覆會失敗）
5. [ ] **手機實測**：加好友 → 傳「**訂單 A1001 狀況**」→ 應收到 bot 回覆

### 共通卡點
- [ ] 內部 IP 打不開 → 提醒：那是「填進 Dify 的值」，不是用瀏覽器開（同 teacher 說明）
- [ ] VM 若被停 → IP 已靜態、不變；重開即可
- [ ] preflight 不綠 → 多半是某服務還在起；`docker compose ps` 看狀態

---

## 預演流程（老師以學員視角走一遍）

- [ ] 用學員機，照「學員手冊」`docs/student/student-stage-1/2/3-lab.md` 從頭做
- [ ] 每段記錄：卡在哪、講解是否夠清楚、時間是否夠
- [ ] 把卡點回填到上方對策，課前補進學員手冊或口頭強調
- [ ] 確認學員機 preflight 9/9
