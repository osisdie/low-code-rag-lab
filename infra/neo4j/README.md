# Neo4j（Stage 3 圖譜 + 視覺化）

共用一台 Neo4j Enterprise，每人一個 database + 一組帳密（隔離）。LightRAG 把抽出的
「商品─供應商─產線─政策」實體關係寫進各自的 database，課堂可在 Neo4j Browser 現場拉圖。

## 初始化帳號
見 `init-users.cypher`（對 `system` database 執行）。老師 = admin，學員只能存取自己的 db。

## 連線資訊（填到各人 graphrag 的 .env）
```
NEO4J_URI=bolt://<lab-svc-ip>:7687
NEO4J_USERNAME=student1
NEO4J_PASSWORD=（見帳密矩陣 ../accounts.md）
NEO4J_DATABASE=lab_student_1
```

## Neo4j Browser（視覺化 demo）
- 開 `http://<lab-svc-ip>:7474`，用自己的帳密登入，左上角選自己的 database。
- 課堂 demo 用查詢（先跑過 graphrag 的 ingest，圖譜才有資料）：

```cypher
// 看整張圖（實體 + 關係）
MATCH (n)-[r]->(m) RETURN n, r, m LIMIT 100;

// 「和耶加雪菲同供應商的商品」這類多跳，在圖上一眼看出
MATCH (p)-[r]-(x) WHERE toLower(p.entity_id) CONTAINS '耶加雪菲'
RETURN p, r, x;
```
> LightRAG 的節點/關係欄位名稱依版本而定（常見 `entity_id`、`description`）。
> demo 前先用 `MATCH (n) RETURN n LIMIT 25;` 看實際屬性名再調整查詢。

## 對照教學
Neo4j Browser 拉出的「關係圖」正好對應 `../../lab-assets/graphrag/sample-queries.md`
的 Q2–Q5：向量檢索看不到這些邊，圖譜沿邊走就答得齊。
