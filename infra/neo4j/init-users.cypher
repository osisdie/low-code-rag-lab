// Neo4j Enterprise 多租戶初始化：每人一個 database + 一組帳密（隔離）。
// 對 system database 執行：
//   cypher-shell -a bolt://localhost:7687 -u neo4j -p "$NEO4J_INITIAL_PW" -d system -f init-users.cypher
//
// ⚠️ Neo4j database 名稱不可含底線；用無底線名稱（labteacher / labstudentN）。
// ⚠️ 上線前請改掉所有預設密碼（見 ../accounts.md 的帳密矩陣）。
// admin = 老師（teacher）；學員 studentN 各自只能存取自己的 database。

// ===== 1. 建立每人的 database =====
CREATE DATABASE labteacher  IF NOT EXISTS;
CREATE DATABASE labstudent1 IF NOT EXISTS;
CREATE DATABASE labstudent2 IF NOT EXISTS;
CREATE DATABASE labstudent3 IF NOT EXISTS;
CREATE DATABASE labstudent4 IF NOT EXISTS;
CREATE DATABASE labstudent5 IF NOT EXISTS;
CREATE DATABASE labstudent6 IF NOT EXISTS;
CREATE DATABASE labstudent7 IF NOT EXISTS;
CREATE DATABASE labstudent8 IF NOT EXISTS;

// ===== 2. 老師 = 全域 admin =====
CREATE USER teacher SET PASSWORD 'ChangeMe-teacher!' CHANGE NOT REQUIRED SET HOME DATABASE labteacher;
GRANT ROLE admin TO teacher;

// ===== 3. 每位學員：自訂 role 僅授權自己的 database（讀寫 + 結構管理）=====
CREATE ROLE labrole1 IF NOT EXISTS;
GRANT ACCESS ON DATABASE labstudent1 TO labrole1;
GRANT ALL DATABASE PRIVILEGES ON DATABASE labstudent1 TO labrole1;
GRANT MATCH {*} ON GRAPH labstudent1 TO labrole1;
GRANT WRITE ON GRAPH labstudent1 TO labrole1;
CREATE USER student1 SET PASSWORD 'ChangeMe-s1!' CHANGE NOT REQUIRED SET HOME DATABASE labstudent1;
GRANT ROLE labrole1 TO student1;

CREATE ROLE labrole2 IF NOT EXISTS;
GRANT ACCESS ON DATABASE labstudent2 TO labrole2;
GRANT ALL DATABASE PRIVILEGES ON DATABASE labstudent2 TO labrole2;
GRANT MATCH {*} ON GRAPH labstudent2 TO labrole2;
GRANT WRITE ON GRAPH labstudent2 TO labrole2;
CREATE USER student2 SET PASSWORD 'ChangeMe-s2!' CHANGE NOT REQUIRED SET HOME DATABASE labstudent2;
GRANT ROLE labrole2 TO student2;

CREATE ROLE labrole3 IF NOT EXISTS;
GRANT ACCESS ON DATABASE labstudent3 TO labrole3;
GRANT ALL DATABASE PRIVILEGES ON DATABASE labstudent3 TO labrole3;
GRANT MATCH {*} ON GRAPH labstudent3 TO labrole3;
GRANT WRITE ON GRAPH labstudent3 TO labrole3;
CREATE USER student3 SET PASSWORD 'ChangeMe-s3!' CHANGE NOT REQUIRED SET HOME DATABASE labstudent3;
GRANT ROLE labrole3 TO student3;

CREATE ROLE labrole4 IF NOT EXISTS;
GRANT ACCESS ON DATABASE labstudent4 TO labrole4;
GRANT ALL DATABASE PRIVILEGES ON DATABASE labstudent4 TO labrole4;
GRANT MATCH {*} ON GRAPH labstudent4 TO labrole4;
GRANT WRITE ON GRAPH labstudent4 TO labrole4;
CREATE USER student4 SET PASSWORD 'ChangeMe-s4!' CHANGE NOT REQUIRED SET HOME DATABASE labstudent4;
GRANT ROLE labrole4 TO student4;

CREATE ROLE labrole5 IF NOT EXISTS;
GRANT ACCESS ON DATABASE labstudent5 TO labrole5;
GRANT ALL DATABASE PRIVILEGES ON DATABASE labstudent5 TO labrole5;
GRANT MATCH {*} ON GRAPH labstudent5 TO labrole5;
GRANT WRITE ON GRAPH labstudent5 TO labrole5;
CREATE USER student5 SET PASSWORD 'ChangeMe-s5!' CHANGE NOT REQUIRED SET HOME DATABASE labstudent5;
GRANT ROLE labrole5 TO student5;

CREATE ROLE labrole6 IF NOT EXISTS;
GRANT ACCESS ON DATABASE labstudent6 TO labrole6;
GRANT ALL DATABASE PRIVILEGES ON DATABASE labstudent6 TO labrole6;
GRANT MATCH {*} ON GRAPH labstudent6 TO labrole6;
GRANT WRITE ON GRAPH labstudent6 TO labrole6;
CREATE USER student6 SET PASSWORD 'ChangeMe-s6!' CHANGE NOT REQUIRED SET HOME DATABASE labstudent6;
GRANT ROLE labrole6 TO student6;

CREATE ROLE labrole7 IF NOT EXISTS;
GRANT ACCESS ON DATABASE labstudent7 TO labrole7;
GRANT ALL DATABASE PRIVILEGES ON DATABASE labstudent7 TO labrole7;
GRANT MATCH {*} ON GRAPH labstudent7 TO labrole7;
GRANT WRITE ON GRAPH labstudent7 TO labrole7;
CREATE USER student7 SET PASSWORD 'ChangeMe-s7!' CHANGE NOT REQUIRED SET HOME DATABASE labstudent7;
GRANT ROLE labrole7 TO student7;

CREATE ROLE labrole8 IF NOT EXISTS;
GRANT ACCESS ON DATABASE labstudent8 TO labrole8;
GRANT ALL DATABASE PRIVILEGES ON DATABASE labstudent8 TO labrole8;
GRANT MATCH {*} ON GRAPH labstudent8 TO labrole8;
GRANT WRITE ON GRAPH labstudent8 TO labrole8;
CREATE USER student8 SET PASSWORD 'ChangeMe-s8!' CHANGE NOT REQUIRED SET HOME DATABASE labstudent8;
GRANT ROLE labrole8 TO student8;

// ===== 4. 驗證 =====
SHOW DATABASES;
SHOW USERS;
