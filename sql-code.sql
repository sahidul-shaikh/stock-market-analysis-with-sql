-- Using the assignment schema
use assignment;

-- Changing the column type to Date as it was imported as text
UPDATE bajaj SET `Date` = str_to_date(`Date`, '%e-%M-%Y');
UPDATE eicher SET `Date` = str_to_date(`Date`, '%e-%M-%Y');
UPDATE hero SET `Date` = str_to_date(`Date`, '%e-%M-%Y');
UPDATE infosys SET `Date` = str_to_date(`Date`, '%e-%M-%Y');
UPDATE tcs SET `Date` = str_to_date(`Date`, '%e-%M-%Y');
UPDATE tvs SET `Date` = str_to_date(`Date`, '%e-%M-%Y');

----------------------------------------------------------------------------------------------

-- Creating tables for 20 Day MA and 50 Day MA

-- Creating bajaj1 

CREATE TABLE bajaj1 AS
SELECT Date, ROUND(`Close Price`,2) as `Close Price`, 
ROUND(AVG(`Close Price`) OVER(ORDER BY `Date` ROWS 19 PRECEDING),2) AS `20 Day MA`,
ROUND(AVG(`Close Price`) OVER(ORDER BY `Date` ROWS 49 PRECEDING),2) AS `50 Day MA`
FROM bajaj;

-- Creating eicher1 

CREATE TABLE eicher1 AS
SELECT Date, ROUND(`Close Price`,2) as `Close Price`, 
ROUND(AVG(`Close Price`) OVER(ORDER BY `Date` ROWS 19 PRECEDING),2) AS `20 Day MA`,
ROUND(AVG(`Close Price`) OVER(ORDER BY `Date` ROWS 49 PRECEDING),2) AS `50 Day MA`
FROM eicher;

-- Creating hero1 

CREATE TABLE hero1 AS
SELECT Date, ROUND(`Close Price`,2) as `Close Price`, 
ROUND(AVG(`Close Price`) OVER(ORDER BY `Date` ROWS 19 PRECEDING),2) AS `20 Day MA`,
ROUND(AVG(`Close Price`) OVER(ORDER BY `Date` ROWS 49 PRECEDING),2) AS `50 Day MA`
FROM hero;

-- Creating infosys1 

CREATE TABLE infosys1 AS
SELECT Date, ROUND(`Close Price`,2) as `Close Price`, 
ROUND(AVG(`Close Price`) OVER(ORDER BY `Date` ROWS 19 PRECEDING),2) AS `20 Day MA`,
ROUND(AVG(`Close Price`) OVER(ORDER BY `Date` ROWS 49 PRECEDING),2) AS `50 Day MA`
FROM infosys;

-- Creating tcs1 

CREATE TABLE tcs1 AS
SELECT Date, ROUND(`Close Price`,2) as `Close Price`, 
ROUND(AVG(`Close Price`) OVER(ORDER BY `Date` ROWS 19 PRECEDING),2) AS `20 Day MA`,
ROUND(AVG(`Close Price`) OVER(ORDER BY `Date` ROWS 49 PRECEDING),2) AS `50 Day MA`
FROM tcs;

-- Creating tvs1 

CREATE TABLE tvs1 AS
SELECT Date, ROUND(`Close Price`,2) as `Close Price`, 
ROUND(AVG(`Close Price`) OVER(ORDER BY `Date` ROWS 19 PRECEDING),2) AS `20 Day MA`,
ROUND(AVG(`Close Price`) OVER(ORDER BY `Date` ROWS 49 PRECEDING),2) AS `50 Day MA`
FROM tvs;

----------------------------------------------------------------------------------------------

-- Creating master table

CREATE TABLE master_stocks AS
SELECT `Date`, bajaj.`Close Price` AS Bajaj, eicher.`Close Price` AS Eicher,
hero.`Close Price` AS Hero, infosys.`Close Price` AS Infosys, 
tcs.`Close Price` AS TCS, tvs.`Close Price` AS TVS
FROM bajaj
INNER JOIN eicher
USING(`Date`)
INNER JOIN hero
USING(`Date`)
INNER JOIN infosys
USING(`Date`)
INNER JOIN tcs
USING(`Date`)
INNER JOIN tvs
USING(`Date`);

---------------------------------------------------------------------------------------

-- Creating table with signal baja2

CREATE TABLE bajaj2 AS
SELECT `Date`, `Close Price`,
(CASE	
	-- First 50 rows keeping Hold because the actual analysis start from 50th row.
	WHEN ROW_NUMBER() OVER() <=50 THEN 'Hold'
    -- If the difference of short term and long term MA of any day and previous day is positive, then keeping the stocks on Hold
	WHEN (`20 Day MA` - `50 Day MA` > 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() > 0 ) THEN 'Hold'
    -- If the difference of short term and long term MA of any day and previous day is negative, then keeping the stocks on Hold
    WHEN (`20 Day MA` - `50 Day MA` < 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() < 0 ) THEN 'Hold'
    -- If there is no difference of short term and long term MA of any day and previous day, then keeping the stocks on Hold
    WHEN (`20 Day MA` - `50 Day MA` = 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() = 0 ) THEN 'Hold'
    -- If the difference of short term and long term MA of any day is greater than the previous day, then buy the stocks (Golder cross)
    WHEN (`20 Day MA` - `50 Day MA` > 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() < 0 ) THEN 'Buy'
    -- If the difference of short term and long term MA of any day is less than the previous day, then sell the stocks (Death cross)
    WHEN (`20 Day MA` - `50 Day MA` < 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() > 0 ) THEN 'Sell'
END) AS `Signal`
from bajaj1;

-- Creating table with signal eicher2

CREATE TABLE eicher2 AS
SELECT `Date`, `Close Price`,
(CASE	
	-- First 50 rows keeping Hold because the actual analysis start from 50th row.
	WHEN ROW_NUMBER() OVER() <=50 THEN 'Hold'
    -- If the difference of short term and long term MA of any day and previous day is positive, then keeping the stocks on Hold
	WHEN (`20 Day MA` - `50 Day MA` > 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() > 0 ) THEN 'Hold'
    -- If the difference of short term and long term MA of any day and previous day is negative, then keeping the stocks on Hold
    WHEN (`20 Day MA` - `50 Day MA` < 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() < 0 ) THEN 'Hold'
    -- If there is no difference of short term and long term MA of any day and previous day, then keeping the stocks on Hold
    WHEN (`20 Day MA` - `50 Day MA` = 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() = 0 ) THEN 'Hold'
    -- If the difference of short term and long term MA of any day is greater than the previous day, then buy the stocks (Golder cross)
    WHEN (`20 Day MA` - `50 Day MA` > 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() < 0 ) THEN 'Buy'
    -- If the difference of short term and long term MA of any day is less than the previous day, then sell the stocks (Death cross)
    WHEN (`20 Day MA` - `50 Day MA` < 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() > 0 ) THEN 'Sell'
END) AS `Signal`
from eicher1;

-- Creating table with signal hero2

CREATE TABLE hero2 AS
SELECT `Date`, `Close Price`,
(CASE	
	-- First 50 rows keeping Hold because the actual analysis start from 50th row.
	WHEN ROW_NUMBER() OVER() <=50 THEN 'Hold'
    -- If the difference of short term and long term MA of any day and previous day is positive, then keeping the stocks on Hold
	WHEN (`20 Day MA` - `50 Day MA` > 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() > 0 ) THEN 'Hold'
    -- If the difference of short term and long term MA of any day and previous day is negative, then keeping the stocks on Hold
    WHEN (`20 Day MA` - `50 Day MA` < 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() < 0 ) THEN 'Hold'
    -- If there is no difference of short term and long term MA of any day and previous day, then keeping the stocks on Hold
    WHEN (`20 Day MA` - `50 Day MA` = 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() = 0 ) THEN 'Hold'
    -- If the difference of short term and long term MA of any day is greater than the previous day, then buy the stocks (Golder cross)
    WHEN (`20 Day MA` - `50 Day MA` > 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() < 0 ) THEN 'Buy'
    -- If the difference of short term and long term MA of any day is less than the previous day, then sell the stocks (Death cross)
    WHEN (`20 Day MA` - `50 Day MA` < 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() > 0 ) THEN 'Sell'
END) AS `Signal`
from hero1;

-- Creating table with signal infosys2

CREATE TABLE infosys2 AS
SELECT `Date`, `Close Price`,
(CASE	
	-- First 50 rows keeping Hold because the actual analysis start from 50th row.
	WHEN ROW_NUMBER() OVER() <=50 THEN 'Hold'
    -- If the difference of short term and long term MA of any day and previous day is positive, then keeping the stocks on Hold
	WHEN (`20 Day MA` - `50 Day MA` > 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() > 0 ) THEN 'Hold'
    -- If the difference of short term and long term MA of any day and previous day is negative, then keeping the stocks on Hold
    WHEN (`20 Day MA` - `50 Day MA` < 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() < 0 ) THEN 'Hold'
    -- If there is no difference of short term and long term MA of any day and previous day, then keeping the stocks on Hold
    WHEN (`20 Day MA` - `50 Day MA` = 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() = 0 ) THEN 'Hold'
    -- If the difference of short term and long term MA of any day is greater than the previous day, then buy the stocks (Golder cross)
    WHEN (`20 Day MA` - `50 Day MA` > 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() < 0 ) THEN 'Buy'
    -- If the difference of short term and long term MA of any day is less than the previous day, then sell the stocks (Death cross)
    WHEN (`20 Day MA` - `50 Day MA` < 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() > 0 ) THEN 'Sell'
END) AS `Signal`
from infosys1;

-- Creating table with signal tcs2

CREATE TABLE tcs2 AS
SELECT `Date`, `Close Price`,
(CASE	
	-- First 50 rows keeping Hold because the actual analysis start from 50th row.
	WHEN ROW_NUMBER() OVER() <=50 THEN 'Hold'
    -- If the difference of short term and long term MA of any day and previous day is positive, then keeping the stocks on Hold
	WHEN (`20 Day MA` - `50 Day MA` > 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() > 0 ) THEN 'Hold'
    -- If the difference of short term and long term MA of any day and previous day is negative, then keeping the stocks on Hold
    WHEN (`20 Day MA` - `50 Day MA` < 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() < 0 ) THEN 'Hold'
    -- If there is no difference of short term and long term MA of any day and previous day, then keeping the stocks on Hold
    WHEN (`20 Day MA` - `50 Day MA` = 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() = 0 ) THEN 'Hold'
    -- If the difference of short term and long term MA of any day is greater than the previous day, then buy the stocks (Golder cross)
    WHEN (`20 Day MA` - `50 Day MA` > 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() < 0 ) THEN 'Buy'
    -- If the difference of short term and long term MA of any day is less than the previous day, then sell the stocks (Death cross)
    WHEN (`20 Day MA` - `50 Day MA` < 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() > 0 ) THEN 'Sell'
END) AS `Signal`
from tcs1;

-- Creating table with signal tvs2

CREATE TABLE tvs2 AS
SELECT `Date`, `Close Price`,
(CASE	
	-- First 50 rows keeping Hold because the actual analysis start from 50th row.
	WHEN ROW_NUMBER() OVER() <=50 THEN 'Hold'
    -- If the difference of short term and long term MA of any day and previous day is positive, then keeping the stocks on Hold
	WHEN (`20 Day MA` - `50 Day MA` > 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() > 0 ) THEN 'Hold'
    -- If the difference of short term and long term MA of any day and previous day is negative, then keeping the stocks on Hold
    WHEN (`20 Day MA` - `50 Day MA` < 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() < 0 ) THEN 'Hold'
    -- If there is no difference of short term and long term MA of any day and previous day, then keeping the stocks on Hold
    WHEN (`20 Day MA` - `50 Day MA` = 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() = 0 ) THEN 'Hold'
    -- If the difference of short term and long term MA of any day is greater than the previous day, then buy the stocks (Golder cross)
    WHEN (`20 Day MA` - `50 Day MA` > 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() < 0 ) THEN 'Buy'
    -- If the difference of short term and long term MA of any day is less than the previous day, then sell the stocks (Death cross)
    WHEN (`20 Day MA` - `50 Day MA` < 0 AND LAG(`20 Day MA` - `50 Day MA`) OVER() > 0 ) THEN 'Sell'
END) AS `Signal`
from tvs1;

--------------------------------------------------------------------------------------

-- Creating function for bajaj signal

DELIMITER $$

CREATE FUNCTION bajaj_signal(trade_date Date)
RETURNS VARCHAR(10) DETERMINISTIC
BEGIN
	DECLARE trade_signal VARCHAR(10);
    SELECT `Signal` 
    FROM bajaj2 
    WHERE Date = trade_date 
    INTO trade_signal; 
	RETURN trade_signal;
END $$

DELIMITER ;

-- Applying the function
 SELECT bajaj_signal('2015-10-19') AS `Signal`;
 
 

 

