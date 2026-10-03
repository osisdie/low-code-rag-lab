# 講師總覽與節奏表

> **本資料夾為講師教案，不對學員公開。** 學員手冊在 `../student/`。
> 課程：<DATE>（<WEEKDAY>）<START>–<END>｜講師：Kevin Wu（AI 顧問）｜場地：<VENUE>｜限額 <CAPACITY> 人

---

## 課程設計理念（先對自己講清楚）

- 對象是 **PM / 主管 / 老闆**，不是工程師 → 教「決策 + 動手做出雛形」，不教 prompt 花式技巧。
- 動手前先有 **Stage 0 觀念地基**（20m，純講解）：把今天的專有名詞、為什麼用、解決什麼問題先講清楚，學員之後看到「向量 / Top K / 工具 / 外部知識庫」才不會卡。
- 主軸是**三階段循序**：No-Code → Low-Code → Advanced，每一階段都在前一階段的**天花板**上往上長。
- **每段 what / why / how-to**：先講「為什麼需要」，再「怎麼做」，最後「它的天花板 → 帶出下一段」。
- 進階（Stage 3）**只做講師示範**（PM/主管「看懂、講得出、知道何時要用」即可，不要求動手）；想自架的人有**選讀附錄**可帶回家（需 Docker / API key）。

> ⚠️ **對學員的用語**：講三種做法時用「**ChatGPT 做法 / Dify 做法 / 工程做法**」，
> 不要講「第一招／第二招／第三招」（太武俠味、勸退新手）。本教案內部保留代號方便對齊。

---

## 收斂後時間表（Opening + Stage 0 + 3 階段 + 收尾）

```
13:30  Opening：定調 + 自評 worksheet（憑直覺先填）      (20m)
13:50  Stage 0 觀念地基：名詞 / 為什麼 / 解決什麼問題    (20m)   ← 純講解，不開電腦
14:10  Stage 1 No-Code：用 ChatGPT 做 AI 客服 (動手)    (40m)
14:50  Stage 2 Low-Code：用 Dify 串 LINE (動手)         (70m)
16:00  休息                                            (15m)
16:15  Stage 3 Advanced：向量 + 圖譜 RAG (純講師示範)    (60m)
17:15  收尾：正式導入決策 + 預算 + 行動清單              (15m)
17:30  END
```

> 與前一版的差異：①新增 **Stage 0 觀念地基（20m）**，動手前先把名詞與「為什麼」講清楚；
> 經費來自 Opening 30→20、Stage 1 45→40、Stage 2 75→70（名詞先預載，後面動手更快）。
> ②**Stage 3 改為純講師示範**（原為 demo + 帶回家動手）——不要求學員當場或回家自架，
> 想動手的人有選讀附錄；好處是課堂節奏穩、不卡在環境問題，PM「看懂會講」即達標。

### 每段內部節奏（細流程見各 stage 教案）
| 段落 | 內部分配 |
|------|----------|
| Opening (20m) | 定調 5｜worksheet 憑直覺自評 5+8+2（三做法落點放到 Stage 0 講完再對答）｜*（選用）開場先跑 6–8 題暖身測驗抓程度＋破冰，見 `quiz-warm-up.md`* |
| Stage 0 (20m) | 一句話框今天 4｜LLM 兩個天生毛病 6｜三個補丁＝今天三段 6｜三做法是組裝法 2｜接 Stage 1 2 |
| Stage 1 (40m) | 建 bot 5+5+5｜兩人互測 10｜分享 8｜天花板總結 7 |
| Stage 2 (70m) | 登入 10｜建知識庫 10｜檢索旋鈕對比 10｜prompt+tool demo 10｜串通路 10｜探索 Q&A 20 |
| Stage 3 (60m，純示範) | 為何要圖譜 10｜架構 5｜灌資料/起服務 demo 10｜對照查詢 Q2–Q5 20｜何時該用圖譜 + Q&A 15 |
| 收尾 (15m) | 預算單 6｜升降級信號 4｜1週/1月/3月 清單 5 |

---

## 講師備品 checklist（上課前一天）

- [ ] ChatGPT / Gemini 範例帳號（Stage 1）— 登入測試
- [ ] **Stage 0 名詞地圖投影**就緒（`docs/student/student-stage-0-concepts.md` 內容，或對應投影片 Stage 0 頁）
- [ ] Dify cloud demo 帳號開好、登入畫面投影測試（Stage 2）
- [ ] 三份範例知識庫就緒：`restaurant-faq.md`、`ecommerce-return-sop.md`、`coffee-catalog-relationships.md`
- [ ] Mock 訂單 API endpoint（tool calling demo）
- [ ] **Stage 3 示範環境**（純講師示範，學員不動手）：`lab-assets/graphrag/` 已 `ingest.py` 灌好、adapter 跑起來、`/health` 正常；
      或備援的託管 GraphRAG（InfraNodus）連線測過
- [ ] Stage 3 對照查詢先跑過一遍（`graphrag/sample-queries.md` Q2–Q5），確認圖譜答案正確
- [ ] **Stage 3 離線備援截圖**（Q2–Q5「向量 vs 圖譜」對照）備妥——示範環境若掛掉直接投影
- [ ] 投影片 `slides/index.html` 投影測試（翻頁、字級、深色對比）
- [ ] worksheet 紙本 25 份（備用 5）
- [ ] **開場暖身題庫就緒**（`quiz-warm-up.md`）— Kahoot 建好題（已建範例：「AI 客服工作坊｜開場暖身測驗」5 題）／或決定分組共答（免費版人數上限約 10–15，見該檔）
- [ ] LLM API 額度確認（20 人 × ~50 query）
- [ ] 課後 Discord / LINE 群組連結
- [ ] 簽到表 + 名牌

---

## 學員帶走清單（課程價值錨點，開場先講一次）

1. 一個自己做出來的 AI 客服 bot 雛形（ChatGPT + Dify）
2. 「公司適合哪種做法」判斷工具（worksheet）
3. 三層次 system prompt 範本（`lab-assets/prompts/`）
4. 一張**名詞地圖**（Stage 0），回公司 brief 老闆/工程師用得上
5. （選讀）想自己動手的人：可帶回家自架的**向量 + 圖譜 RAG 實驗室**（`lab-assets/graphrag/`）
6. 四套預算範本 + 1 週 / 1 個月 / 3 個月 行動清單
7. **課後繼續練習的免費工具清單**（`../student/student-free-tools-menu.md`）＋ Dify Cloud 免費版接續指南（附在 Stage 2 lab 末尾）
