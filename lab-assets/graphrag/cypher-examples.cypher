// ============================================================
// Stage 3 · Neo4j / Cypher 範例（教學用）
// ============================================================
// 重要觀念：本課的圖是 LightRAG「自動」從文件抽出來建的，
//          你「不需要手寫 Cypher 去建圖」。Cypher 在這裡的用途有兩個：
//   (A) 到 Neo4j Browser 檢視 / 視覺化 LightRAG 建好的圖。
//   (B) 教學示範：若「手工建模」這份關係，Cypher 長怎樣、多跳查詢怎麼寫。
//
// 開 Neo4j Browser：http://<lab-svc-ip>:7474 → 登入 → 左上選自己的 database。
// 資料同 ../knowledge-base/coffee-catalog-relationships.md。
// ============================================================


// ============================================================
// (A) 檢視 LightRAG 自動建好的圖（跑過 ingest.py 後）
// ============================================================
// LightRAG 的節點/邊屬性名依版本而定，常見 entity_id / description。
// 先看實際屬性名，再調整下面查詢：
//   MATCH (n) RETURN n LIMIT 25;

// A1. 看整張圖（實體 + 關係）
MATCH (n)-[r]->(m) RETURN n, r, m LIMIT 100;

// A2. 找某實體與它的鄰居（多跳的起點）——例：耶加雪菲
MATCH (p)-[r]-(x)
WHERE toLower(p.entity_id) CONTAINS '耶加雪菲'
RETURN p, r, x;

// A3. 兩個實體之間的最短關係路徑（LightRAG 圖上「怎麼相連」）
MATCH path = shortestPath(
  (a)-[*..5]-(b))
WHERE toLower(a.entity_id) CONTAINS '耶加雪菲'
  AND toLower(b.entity_id) CONTAINS '西達摩'
RETURN path;


// ============================================================
// (B) 手工建模版（自成一體，可直接貼進空白 database 示範乾淨的 Cypher）
//     這不是 LightRAG 的圖，是「若人工建這份關係圖」的樣子——
//     用來教「知識圖譜 + Cypher 多跳查詢」的直覺。
// ============================================================

// --- B0. 清空（只在示範用的空 database 執行！）---
// MATCH (n) DETACH DELETE n;

// --- B1. 建節點與關係 ---
// 商品
MERGE (p1:Product {id:'P1', name:'耶加雪菲 日曬', roast:'淺焙'})
MERGE (p2:Product {id:'P2', name:'西達摩 日曬', roast:'淺焙'})
MERGE (p3:Product {id:'P3', name:'薇拉甜橙 水洗', roast:'淺焙'})
MERGE (p4:Product {id:'P4', name:'哥倫比亞 低因', roast:'中焙'})
MERGE (p5:Product {id:'P5', name:'安提瓜 火山', roast:'中深焙'})
MERGE (p6:Product {id:'P6', name:'阿里山 水洗', roast:'中深焙'})
MERGE (p7:Product {id:'P7', name:'冷萃黑咖啡', roast:'即飲'})
MERGE (p8:Product {id:'P8', name:'氮氣冷萃拿鐵', roast:'即飲'})
// 供應商
MERGE (sSid:Supplier {name:'Sidama Union'})
MERGE (sLa:Supplier  {name:'La Esperanza Estate'})
MERGE (sFin:Supplier {name:'Finca El Injerto'})
MERGE (sAli:Supplier {name:'阿里山咖啡合作社'})
// 產區
MERGE (oEth:Origin {name:'衣索比亞'})
MERGE (oCol:Origin {name:'哥倫比亞 Huila'})
MERGE (oGua:Origin {name:'瓜地馬拉 Antigua'})
MERGE (oTw:Origin  {name:'台灣阿里山'})
// 產線
MERGE (l1:Line {name:'淺焙線 L1'})
MERGE (l2:Line {name:'中深焙線 L2'})
MERGE (l3:Line {name:'低因專線 L3'})
MERGE (l4:Line {name:'冷萃線 L4'})
// 政策
MERGE (paA:Policy {name:'退貨政策 A'})
MERGE (paB:Policy {name:'退貨政策 B'})
MERGE (paC:Policy {name:'退貨政策 C'})
// 促銷組合
MERGE (b1:Bundle {name:'非洲日曬組 B1'})
MERGE (b2:Bundle {name:'入門淺焙組 B2'})
MERGE (b3:Bundle {name:'醇厚中深焙組 B3'})
MERGE (b4:Bundle {name:'夏日冷萃組 B4'})

// 商品 → 供應商
MERGE (p1)-[:SUPPLIED_BY]->(sSid)  MERGE (p2)-[:SUPPLIED_BY]->(sSid)
MERGE (p3)-[:SUPPLIED_BY]->(sLa)   MERGE (p4)-[:SUPPLIED_BY]->(sLa)
MERGE (p5)-[:SUPPLIED_BY]->(sFin)  MERGE (p7)-[:SUPPLIED_BY]->(sFin)
MERGE (p6)-[:SUPPLIED_BY]->(sAli)  MERGE (p8)-[:SUPPLIED_BY]->(sAli)
// 供應商 → 產區
MERGE (sSid)-[:LOCATED_IN]->(oEth) MERGE (sLa)-[:LOCATED_IN]->(oCol)
MERGE (sFin)-[:LOCATED_IN]->(oGua) MERGE (sAli)-[:LOCATED_IN]->(oTw)
// 商品 → 產線
MERGE (p1)-[:ROASTED_ON]->(l1) MERGE (p2)-[:ROASTED_ON]->(l1) MERGE (p3)-[:ROASTED_ON]->(l1)
MERGE (p5)-[:ROASTED_ON]->(l2) MERGE (p6)-[:ROASTED_ON]->(l2)
MERGE (p4)-[:ROASTED_ON]->(l3)
MERGE (p7)-[:ROASTED_ON]->(l4) MERGE (p8)-[:ROASTED_ON]->(l4)
// 商品 → 政策
MERGE (p1)-[:RETURN_POLICY]->(paA) MERGE (p2)-[:RETURN_POLICY]->(paA) MERGE (p3)-[:RETURN_POLICY]->(paA)
MERGE (p5)-[:RETURN_POLICY]->(paA) MERGE (p6)-[:RETURN_POLICY]->(paA)
MERGE (p4)-[:RETURN_POLICY]->(paB)
MERGE (p7)-[:RETURN_POLICY]->(paC) MERGE (p8)-[:RETURN_POLICY]->(paC)
// 組合 → 商品
MERGE (b1)-[:CONTAINS]->(p1) MERGE (b1)-[:CONTAINS]->(p2)
MERGE (b2)-[:CONTAINS]->(p1) MERGE (b2)-[:CONTAINS]->(p3)
MERGE (b3)-[:CONTAINS]->(p5) MERGE (b3)-[:CONTAINS]->(p6)
MERGE (b4)-[:CONTAINS]->(p7) MERGE (b4)-[:CONTAINS]->(p8);

// --- B2. 多跳查詢（對應 sample-queries.md 的 Q2–Q5）---

// Q2 同供應商：和「耶加雪菲」同供應商的還有哪些豆？（純向量常漏）
MATCH (:Product {name:'耶加雪菲 日曬'})-[:SUPPLIED_BY]->(s)<-[:SUPPLIED_BY]-(other:Product)
RETURN s.name AS 供應商, collect(other.name) AS 同供應商商品;

// Q3 雙條件 join：和「冷萃黑咖啡」同產線「且」同政策的？
MATCH (x:Product {name:'冷萃黑咖啡'})-[:ROASTED_ON]->(l)<-[:ROASTED_ON]-(o:Product),
      (x)-[:RETURN_POLICY]->(pol)<-[:RETURN_POLICY]-(o)
WHERE o <> x
RETURN o.name AS 同產線且同政策, l.name AS 產線, pol.name AS 政策;

// Q4 斷貨影響（供應商→商品→組合）：La Esperanza 斷貨影響哪些商品與組合？
MATCH (s:Supplier {name:'La Esperanza Estate'})<-[:SUPPLIED_BY]-(p:Product)
OPTIONAL MATCH (b:Bundle)-[:CONTAINS]->(p)
RETURN p.name AS 受影響商品, collect(DISTINCT b.name) AS 受影響組合;

// Q5 組合溯源（組合→商品→產區）：「夏日冷萃組」用到哪些產區的豆？
MATCH (:Bundle {name:'夏日冷萃組 B4'})-[:CONTAINS]->(p:Product)
      -[:SUPPLIED_BY]->(:Supplier)-[:LOCATED_IN]->(o:Origin)
RETURN p.name AS 商品, o.name AS 產區;

// 視覺化：整張手工圖
MATCH (n)-[r]->(m) RETURN n, r, m;
