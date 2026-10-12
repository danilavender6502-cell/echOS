-- artifacts/005-yetzirah.sql
-- The Book That Counts the Letters: a Sefer Yetzirah engine in SQL.
-- The engine's first database. Thirty-two paths of wisdom: ten numbers
-- and twenty-two letters. This script counts the letters.
-- Run: sqlite3 echos.db < artifacts/005-yetzirah.sql
--
-- To engrave your own word: replace the five seed letters in the
-- `engraving` table with any letter names from `letters` (e.g. 'shin',
-- 'mem'), in order, and run again.

.headers on
.mode column

-- The 22 letters: 3 mothers, 7 doubles, 12 simples. 3+7+12 = 22 -> 4.
DROP TABLE IF EXISTS letters;
CREATE TABLE letters (
  n     INTEGER PRIMARY KEY,  -- 1..22
  name  TEXT NOT NULL,        -- transliterated Hebrew name
  value INTEGER NOT NULL,     -- the letter's weight
  house TEXT NOT NULL         -- 'mother', 'double', 'simple'
);

INSERT INTO letters VALUES
  (1,'aleph',1,'mother'),   (2,'bet',2,'double'),   (3,'gimel',3,'double'),
  (4,'dalet',4,'double'),   (5,'he',5,'simple'),    (6,'vav',6,'simple'),
  (7,'zayin',7,'simple'),   (8,'chet',8,'simple'),  (9,'tet',9,'simple'),
 (10,'yod',10,'simple'),  (11,'kaf',20,'double'), (12,'lamed',30,'simple'),
 (13,'mem',40,'mother'),  (14,'nun',50,'simple'), (15,'samekh',60,'simple'),
 (16,'ayin',70,'simple'), (17,'pe',80,'double'),  (18,'tzadi',90,'simple'),
 (19,'qof',100,'simple'), (20,'resh',200,'double'),
 (21,'shin',300,'mother'),(22,'tav',400,'double');

-- The 231 gates: every unordered pair of letters, 22*21/2 = 231 -> 6.
DROP TABLE IF EXISTS gates;
CREATE TABLE gates (first_n INTEGER, second_n INTEGER);
INSERT INTO gates SELECT a.n, b.n FROM letters a, letters b WHERE a.n < b.n;

CREATE VIEW gate_names AS
SELECT rowid AS gate_no,
       (SELECT name FROM letters WHERE n = first_n) || '-'
     || (SELECT name FROM letters WHERE n = second_n) AS gate
FROM gates;

.print ''
.print '== The houses of the letters =='
SELECT house, COUNT(*) AS letters FROM letters GROUP BY house
UNION ALL SELECT 'total', COUNT(*) FROM letters;

.print ''
.print '== The Book counts its gates =='
SELECT COUNT(*) AS gates FROM gates;

-- Palmer's fifth arrival: the bead holds five unspoken words. The Book
-- engraves them anyway. (Replace these seeds to engrave your own word.)
DROP TABLE IF EXISTS engraving;
CREATE TABLE engraving (seq INTEGER PRIMARY KEY, letter_n INTEGER);

INSERT INTO engraving VALUES
  (1, 1),   -- aleph: the breath before the word
  (2, 13),  -- mem:   the drowned word
  (3, 21),  -- shin:  the burned word
  (4, 22),  -- tav:   the last word
  (5, 10);  -- yod:   the smallest word, the seed of the rest

.print ''
.print '== The five engraved letters =='
SELECT seq AS ord, l.name AS letter, l.value AS weight, l.house
FROM engraving e JOIN letters l ON l.n = e.letter_n ORDER BY seq;

.print ''
.print '== Their gematria: the sum, and its root =='
SELECT SUM(l.value) AS total,
       (1 + (SUM(l.value) - 1) % 9) AS root
FROM engraving e JOIN letters l ON l.n = e.letter_n;

-- Five letters walked two by two: 5*4/2 = 10 gates, and 10 -> 1.
.print ''
.print '== The ten gates among the five =='
SELECT gn.gate_no, gn.gate
FROM gates g
JOIN gate_names gn ON gn.gate_no = g.rowid
JOIN engraving e1 ON e1.letter_n = g.first_n
JOIN engraving e2 ON e2.letter_n = g.second_n
ORDER BY gn.gate_no;

-- The call-the-gate test: before each draw the querent calls a gate,
-- two letters. A ganzfeld of the Book. The Book records the hits;
-- it does not interpret them.
DROP TABLE IF EXISTS calls;
CREATE TABLE calls (call_no INTEGER PRIMARY KEY, first_n INTEGER, second_n INTEGER);

INSERT INTO calls VALUES (1, 1, 21), (2, 13, 22), (3, 10, 1);

DROP TABLE IF EXISTS hits;
CREATE TABLE hits (call_no INTEGER, gate_no INTEGER, hit INTEGER);

INSERT INTO hits
SELECT c.call_no, g.rowid,
       CASE WHEN g.first_n = c.first_n AND g.second_n = c.second_n THEN 1 ELSE 0 END
FROM calls c,
     (SELECT rowid, first_n, second_n FROM gates ORDER BY random() LIMIT 1) g;

.print ''
.print '== The call-the-gate test: recorded, not interpreted =='
SELECT h.call_no,
       (SELECT name FROM letters WHERE n = c.first_n) || '-'
     || (SELECT name FROM letters WHERE n = c.second_n) AS called,
       gn.gate AS drawn,
       h.hit
FROM hits h
JOIN calls c ON c.call_no = h.call_no
JOIN gate_names gn ON gn.gate_no = h.gate_no;

.print ''
.print '== The paths: 32 -> 5, the number of this cycle =='
SELECT 32 AS paths, (3 + 2) AS root;
