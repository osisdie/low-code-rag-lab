# System Prompt 範本（哪一個對應哪一階段？）

> 檔名是「**提示撰寫的層次**」(beginner / advanced / expert)，**不是課程的 Stage 編號**。
> 對照表如下，避免把 `advanced-prompt.txt` 誤當成「Stage 3 Advanced（向量+圖譜）」——它其實是 **Stage 2** 用的。

| 檔案 | 對應課程段落 | 範例公司 | 要替換的 placeholder | 一句話 |
|------|------|------|------|------|
| `beginner-prompt.txt` | **Stage 1 · No-Code**（ChatGPT / Gemini / Claude） | 綠野鮮蔬餐廳 | `[公司名]` | 「四句不要亂答」最小版；重點＝只依文件答 + 情緒/退費轉真人 |
| `advanced-prompt.txt` | **Stage 2 · Low-Code**（Dify）＋ **Stage 3 沿用同一支** | 醇焙手沖咖啡 | `[公司名]`（2 處）、`[3 句話描述…]` | 多了 tool calling（`get_order_status`）、引用格式、轉真人＋防 jailbreak |
| `expert-prompt.txt` | **收尾段 · 正式導入**（給學員「看」，不用寫） | `<COMPANY>` | 一堆 `{{變數}}` | 重點不是 prompt，而是每個 `{{變數}}` 都＝一段工程整合工作（成本所在） |
| `stage1-loose-demo.txt` | **Stage 1 反面教材**（示範用） | 綠野鮮蔬餐廳 | 無（直接用） | 故意「鬆散提示」，用來**可靠地**演出幻覺＋只能講不能做 |

## 為什麼沒有「Stage 3 專用 prompt」？

Stage 3（向量+圖譜）**沿用 Stage 2 的同一個 Dify app 與 `advanced-prompt.txt`**，差別只在「再掛一個 GraphRAG 外部知識庫」，prompt 不變。所以只有 3 支正式 prompt + 1 支示範。

## Stage 1 該用哪一個？

- 正式講解／學員操作 → **`beginner-prompt.txt`**（把 `[公司名]` 換成你的公司，課堂範例＝綠野鮮蔬餐廳）。
- 想**可靠地演出「AI 會亂編」** → 另開一個對話用 **`stage1-loose-demo.txt`**（嚴格版的 beginner-prompt 在現代模型上不一定演得出幻覺，見講師 checklist Lab 1 Demo ①/②）。
