# Obsidian Vault ＋ Claude Panel（只答 vault 的問答助理）

這個資料夾是設計來當成一個 **Windows Obsidian vault**。裝上 **Claude Panel** 社群外掛後，
你就有一個右側聊天面板，**只會根據這個 vault 裡的筆記回答問題**，找不到就明說沒有、不亂編。

## 這是怎麼運作的

- **Claude Panel** 外掛會把 `claude` CLI（Claude Code）開在**這個 vault 資料夾當工作目錄**。
- 因為工作目錄就是 vault，Claude Code 會自動讀取 vault 根目錄的 **`CLAUDE.md`**——裡面寫死了「只答 vault、找不到就說沒有、標出處、唯讀」等規則。
- 另外 **`.claude/settings.json`** 在**權限層**直接封掉「寫檔／改檔／上網／執行指令」，所以唯讀、不上網不是靠它自律，是強制的。

> 一句話：**規則寫在 `CLAUDE.md`，界線鎖在 `.claude/settings.json`**。想調行為改前者，想調權限改後者。

## 安裝步驟（Windows）

1. **先裝 `claude` CLI 並登入**（Claude Panel 需要它）：
   - 安裝 Claude Code，執行一次 `claude` 完成登入（Claude Pro／Max 訂閱，或填 Anthropic API key）。
2. **用 Obsidian 開這個資料夾當 vault**：
   - Obsidian →「Open folder as vault」→ 選這個 `obsidian/` 資料夾。
3. **裝 Claude Panel 外掛**：
   - 設定 → Community plugins → Browse → 搜尋 **「Claude Panel」**（作者 ryukyuhub）→ Install → Enable。
   - 外掛頁：https://community.obsidian.md/plugins/claude-panel-ryukyuhub
   - 第一次啟用時若第三方外掛被關，先開啟「Community plugins」。
4. **打開右側 Claude 面板開始問**。它會自動吃 `CLAUDE.md` 的規則。

## 試玩：驗證它真的只答 vault

vault 裡已放了三份範例筆記（`knowledge-base/`）。開面板後可以這樣測：

**應該答得出（vault 裡有）：**
- 「綠野鮮蔬餐廳的營業時間？」→ 應引用 `knowledge-base/restaurant-faq.md`
- 「未開封的咖啡豆可以退貨嗎？」→ 應引用 `knowledge-base/ecommerce-return-sop.md`
- 「跟耶加雪菲同一個供應商的還有哪些豆？」→ 應引用 `knowledge-base/coffee-catalog-relationships.md`

**應該明說沒有（vault 裡沒有）：**
- 「今天台北天氣如何？」→ 應回「這個 vault 裡沒有相關資料」，而**不是**去猜或上網。
- 「幫我寫一首詩」→ 同上，並提醒它是唯讀 vault 問答，不做 vault 以外的事。

若上面「應該沒有」的問題它竟然答了，代表規則沒被讀到——檢查 `CLAUDE.md` 是否在 vault 根目錄、外掛是否確實把這個資料夾當工作目錄。

## 沒有 Claude 訂閱？

Claude Panel 綁 Anthropic（需 Claude 訂閱或 Anthropic key）。沒有訂閱的人，最省事的免費做法是
**NotebookLM**（免安裝、免 key、會附出處、找不到會說沒有）——見 `internal-trial-guide.md` 的「路徑 A」。

## 裡面有什麼

```
obsidian/
├── CLAUDE.md                 ← 助理規則（只答 vault、找不到就說沒有、標出處、唯讀）
├── README.md                 ← 本說明
├── internal-trial-guide.*    ← 給 internal user 的試用指南（.md/.html/.pdf；NotebookLM／Claude Panel 兩條路）
├── .claude/settings.json     ← 權限鎖：禁寫檔／改檔／上網／執行指令
├── .gitignore                ← 排除 .obsidian/ 與含 key 的檔
└── knowledge-base/           ← 三份範例筆記（工作坊教材，可自行刪除換成你的）
    ├── restaurant-faq.md
    ├── ecommerce-return-sop.md
    └── coffee-catalog-relationships.md
```

## 換成你自己的資料

把 `knowledge-base/` 裡的範例刪掉、放進你自己的筆記即可（`.md` 最佳）。規則不用改，
助理一律只根據當下 vault 裡的內容回答。
