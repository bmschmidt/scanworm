
USE Printers;
DELETE FROM master_bookcounts;
#ALTER IGNORE TABLE master_bookcounts ADD topic SMALLINT;
LOAD DATA LOCAL INFILE "/tmp/wordcounts.txt" INTO TABLE master_bookcounts (bookid,wordid,topic,count);