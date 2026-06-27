// Neo4j Enterprise 多租戶初始化：每人一個 database + 一組帳密（隔離）。
// 對 system database 執行：
//   cypher-shell -a bolt://localhost:7687 -u neo4j -p "$NEO4J_INITIAL_PW" -d system -f init-users.cypher
//
// ⚠️ 上線前請改掉所有預設密碼（見 ../accounts.md 的帳密矩陣）。
// admin = 老師（teacher）；學員 student1..8 各自只能存取自己的 database。

// ===== 1. 建立每人的 database =====
CREATE DATABASE lab_teacher   IF NOT EXISTS;
CREATE DATABASE lab_student_1 IF NOT EXISTS;
CREATE DATABASE lab_student_2 IF NOT EXISTS;
CREATE DATABASE lab_student_3 IF NOT EXISTS;
CREATE DATABASE lab_student_4 IF NOT EXISTS;
CREATE DATABASE lab_student_5 IF NOT EXISTS;
CREATE DATABASE lab_student_6 IF NOT EXISTS;
CREATE DATABASE lab_student_7 IF NOT EXISTS;
CREATE DATABASE lab_student_8 IF NOT EXISTS;

// ===== 2. 老師 = 全域 admin =====
CREATE USER teacher SET PASSWORD 'ChangeMe-teacher!' CHANGE NOT REQUIRED SET HOME DATABASE lab_teacher;
GRANT ROLE admin TO teacher;

// ===== 3. 每位學員：自訂 role 僅授權自己的 database（讀寫 + 結構管理）=====
// student1
CREATE ROLE lab_role_1 IF NOT EXISTS;
GRANT ACCESS ON DATABASE lab_student_1 TO lab_role_1;
GRANT ALL DATABASE PRIVILEGES ON DATABASE lab_student_1 TO lab_role_1;
GRANT MATCH {*} ON GRAPH lab_student_1 TO lab_role_1;
GRANT WRITE ON GRAPH lab_student_1 TO lab_role_1;
CREATE USER student1 SET PASSWORD 'ChangeMe-s1!' CHANGE NOT REQUIRED SET HOME DATABASE lab_student_1;
GRANT ROLE lab_role_1 TO student1;

// student2
CREATE ROLE lab_role_2 IF NOT EXISTS;
GRANT ACCESS ON DATABASE lab_student_2 TO lab_role_2;
GRANT ALL DATABASE PRIVILEGES ON DATABASE lab_student_2 TO lab_role_2;
GRANT MATCH {*} ON GRAPH lab_student_2 TO lab_role_2;
GRANT WRITE ON GRAPH lab_student_2 TO lab_role_2;
CREATE USER student2 SET PASSWORD 'ChangeMe-s2!' CHANGE NOT REQUIRED SET HOME DATABASE lab_student_2;
GRANT ROLE lab_role_2 TO student2;

// student3
CREATE ROLE lab_role_3 IF NOT EXISTS;
GRANT ACCESS ON DATABASE lab_student_3 TO lab_role_3;
GRANT ALL DATABASE PRIVILEGES ON DATABASE lab_student_3 TO lab_role_3;
GRANT MATCH {*} ON GRAPH lab_student_3 TO lab_role_3;
GRANT WRITE ON GRAPH lab_student_3 TO lab_role_3;
CREATE USER student3 SET PASSWORD 'ChangeMe-s3!' CHANGE NOT REQUIRED SET HOME DATABASE lab_student_3;
GRANT ROLE lab_role_3 TO student3;

// student4
CREATE ROLE lab_role_4 IF NOT EXISTS;
GRANT ACCESS ON DATABASE lab_student_4 TO lab_role_4;
GRANT ALL DATABASE PRIVILEGES ON DATABASE lab_student_4 TO lab_role_4;
GRANT MATCH {*} ON GRAPH lab_student_4 TO lab_role_4;
GRANT WRITE ON GRAPH lab_student_4 TO lab_role_4;
CREATE USER student4 SET PASSWORD 'ChangeMe-s4!' CHANGE NOT REQUIRED SET HOME DATABASE lab_student_4;
GRANT ROLE lab_role_4 TO student4;

// student5
CREATE ROLE lab_role_5 IF NOT EXISTS;
GRANT ACCESS ON DATABASE lab_student_5 TO lab_role_5;
GRANT ALL DATABASE PRIVILEGES ON DATABASE lab_student_5 TO lab_role_5;
GRANT MATCH {*} ON GRAPH lab_student_5 TO lab_role_5;
GRANT WRITE ON GRAPH lab_student_5 TO lab_role_5;
CREATE USER student5 SET PASSWORD 'ChangeMe-s5!' CHANGE NOT REQUIRED SET HOME DATABASE lab_student_5;
GRANT ROLE lab_role_5 TO student5;

// student6
CREATE ROLE lab_role_6 IF NOT EXISTS;
GRANT ACCESS ON DATABASE lab_student_6 TO lab_role_6;
GRANT ALL DATABASE PRIVILEGES ON DATABASE lab_student_6 TO lab_role_6;
GRANT MATCH {*} ON GRAPH lab_student_6 TO lab_role_6;
GRANT WRITE ON GRAPH lab_student_6 TO lab_role_6;
CREATE USER student6 SET PASSWORD 'ChangeMe-s6!' CHANGE NOT REQUIRED SET HOME DATABASE lab_student_6;
GRANT ROLE lab_role_6 TO student6;

// student7
CREATE ROLE lab_role_7 IF NOT EXISTS;
GRANT ACCESS ON DATABASE lab_student_7 TO lab_role_7;
GRANT ALL DATABASE PRIVILEGES ON DATABASE lab_student_7 TO lab_role_7;
GRANT MATCH {*} ON GRAPH lab_student_7 TO lab_role_7;
GRANT WRITE ON GRAPH lab_student_7 TO lab_role_7;
CREATE USER student7 SET PASSWORD 'ChangeMe-s7!' CHANGE NOT REQUIRED SET HOME DATABASE lab_student_7;
GRANT ROLE lab_role_7 TO student7;

// student8
CREATE ROLE lab_role_8 IF NOT EXISTS;
GRANT ACCESS ON DATABASE lab_student_8 TO lab_role_8;
GRANT ALL DATABASE PRIVILEGES ON DATABASE lab_student_8 TO lab_role_8;
GRANT MATCH {*} ON GRAPH lab_student_8 TO lab_role_8;
GRANT WRITE ON GRAPH lab_student_8 TO lab_role_8;
CREATE USER student8 SET PASSWORD 'ChangeMe-s8!' CHANGE NOT REQUIRED SET HOME DATABASE lab_student_8;
GRANT ROLE lab_role_8 TO student8;

// ===== 4. 驗證 =====
SHOW DATABASES;
SHOW USERS;
