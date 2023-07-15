DROP DATABASE IF EXISTS lesson_6;
CREATE DATABASE lesson_6;
USE lesson_6;

-- Создайте функцию, которая принимает кол-во сек и переводит их в кол-во дней, часов, минут и секунд.
-- Пример: 123456 -> '1 days 10 hours 17 minutes 36 seconds'

DROP FUNCTION IF EXISTS sectotime;
DELIMITER $$ 
CREATE FUNCTION sectotime(val INT)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
	DECLARE d CHAR(3);
	DECLARE h, m, s CHAR(2);
	DECLARE res VARCHAR(50);
    IF val = 0
	THEN SET res = 0;
    ELSE
		SET d = CAST(FLOOR(val/60/60/24) AS CHAR(3));
		SET h = CAST(FLOOR(MOD(val/60/60/24,1)*24) AS CHAR(2));
		SET m = CAST(FLOOR(MOD(MOD(val/60/60/24,1)*24,1)*60) AS CHAR(2));
		SET s = CAST(FLOOR(MOD(MOD(MOD(val/60/60/24,1)*24,1)*60,1)*60 + 1) AS CHAR(2));
		SET res = CONCAT(d, ' days ', h, ' hours ', m, ' minutes ', s, ' seconds');
	END IF;
	RETURN res;
END $$
DELIMITER ;

SELECT sectotime(123456);

-- Выведите только четные числа от 1 до 10 (Через цикл).
-- Пример: 2,4,6,8,10

DROP PROCEDURE IF EXISTS showeven;
DELIMITER $$ 
CREATE PROCEDURE showeven(val INT)
BEGIN
	DECLARE num INT;
    DECLARE res VARCHAR(200);
    SET res = '';
 	SET num = 2;
    WHILE num <= val DO
		IF num = 2
			THEN SET res = CAST(num AS CHAR);
			ELSE SET res = CONCAT(res, ', ', num);
        END IF;
		SET num = num + 2;
    END WHILE;
	SELECT res;
END $$
DELIMITER ;

CALL showeven(10);