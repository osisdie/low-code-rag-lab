# 綠野鮮蔬 AI 客服 — 內部試用指南

> 我們在測一個「**只根據我們給的文件回答**」的 AI 客服（範例是「綠野鮮蔬餐廳」FAQ）。
> 有兩條路，**依你有沒有 Claude 訂閱二選一**。**答錯沒關係——是在測工具，不是考你。**

---

## 先選你的路徑

| 你的情況 | 用哪條 | 門檻 |
|----------|--------|------|
| 沒有 Claude 訂閱 / 只想快速試 | **路徑 A：NotebookLM** | 最低：點連結、登入 Google 即可 |
| 有 Claude 訂閱、想在本機試 | **路徑 B：Obsidian + Claude Panel** | 要裝 Obsidian ＋ Claude CLI |

> 你會體驗到：問 FAQ 裡**有**的 → 答得出來並**標出處**；問 FAQ 裡**沒有**的 → 會說「資料裡沒有」，**不亂編**。

---

## 路徑 A：NotebookLM（推薦，零安裝）

1. 打開負責人分享給你的 **NotebookLM 連結**（用你的 Google 帳號登入）。
2. 下方輸入框**直接打問題** → 送出。
3. 它會根據來源（餐廳 FAQ）回答、每句**附出處**；FAQ 沒寫的會**說沒有**。

> 想自己建一個？到 https://notebooklm.google.com → New notebook → **Add sources** → 貼上或上傳 FAQ → 就能問。免費、免 API key。

---

## 路徑 B：Obsidian + Claude Panel（需 Claude 訂閱）

**前置**：本機先裝好 `claude` CLI 並登入一次（Claude Pro/Max 或 Anthropic key）。

1. 安裝 **Obsidian**（https://obsidian.md ，免費）。
2. 拿到「綠野鮮蔬 vault」資料夾 → Obsidian「**Open folder as vault**」→ 選它。
3. 若跳出提示 → **信任並啟用社群外掛**。
4. 確認 **Claude Panel** 外掛已啟用（設定 → Community plugins）。
5. 開右側 **Claude 面板**（命令面板 `Ctrl/Cmd+P` 搜 "Claude Panel"，或點側欄圖示）。
6. 在面板**直接打問題**——它會讀**整個 vault** 和規則檔 `CLAUDE.md`（只答 vault、找不到說沒有、標出處、唯讀）。

> Claude Panel 是**真正的聊天面板**（不像之前的 chatgpt-md 要在筆記裡跑指令），也會自動讀整個 `knowledge-base/`。

---

## 試打這 5 題（兩條路都適用）

| # | 問題 | 應該回答 |
|---|------|----------|
| 1 | 營業時間？ | 週二至週日 11:30–14:30、17:30–21:00，週一公休 |
| 2 | 有素食嗎？ | 蛋奶素友善，多數純素、部分含蛋奶 |
| 3 | 假日有低消嗎？ | 平日無；假日每人低消 NT$250 |
| 4 | 可以刷卡嗎？ | 可，VISA/Master/JCB、LINE Pay、街口、Apple Pay |
| **5** | **可以帶寵物進餐廳嗎？** | **FAQ 沒寫 → 應說「資料裡沒有，建議來電洽詢」（不該亂編）** |

> 第 5 題是**幻覺測試**：若它掰出「可以／不可以」就是沒守規則——這正是要觀察的。
> 請回報：哪題答對、哪題亂編、你走哪條路徑。

---

## 疑難排解

- **NotebookLM 連結打不開**：請負責人確認已把 notebook 分享給你的 Google 帳號。
- **Claude Panel 沒反應**：確認 `claude` CLI 已安裝且登入；可先在終端機跑一次 `claude` 完成登入再回 Obsidian。
- **答得不準**：確認 FAQ 真有該內容；兩條路都是「只根據來源回答」，FAQ 沒寫就會說沒有。

---

## 提醒

- 這是**虛構範例 FAQ**，隨意試無妨。
- 隱私：NotebookLM 資料存在 Google；Claude Panel 走 Claude／Anthropic。換公司真實資料前先評估。
- 核心目標：「**只答 vault、找不到就說沒有**」——請特別注意它有沒有守住。

---

*範例資料為虛構，僅供工具試用。*
