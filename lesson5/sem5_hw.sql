CREATE DATABASE IF NOT EXISTS lesson_5;
USE lesson_5;

DROP TABLE IF EXISTS cars;
CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);

INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
SELECT * FROM cars;

-- 1. Создайте представление, в которое попадут автомобили стоимостью до 25 000 долларов
CREATE OR REPLACE VIEW sample AS
SELECT *
FROM cars
WHERE cost <= 25000;

SELECT * FROM sample;

-- 2. Изменить в существующем представлении порог для стоимости:
-- пусть цена будет до 30 000 долларов (используя оператор OR REPLACE)
CREATE OR REPLACE VIEW sample AS
SELECT *
FROM cars
WHERE cost <= 30000;

SELECT * FROM sample;

-- 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”
CREATE OR REPLACE VIEW sample2 AS
SELECT *
FROM cars
WHERE name = "Audi" OR name = "Skoda";

SELECT * FROM sample2;

-- 4. Добавьте новый столбец под названием «время до следующей станции». 
DROP TABLE IF EXISTS train_shedule;
CREATE TABLE train_shedule
(
	train_id INT,
    station VARCHAR(20),
    station_time TIME
);

INSERT train_shedule
VALUES
	(110, "San Francisco", "10:00:00"),
	(110, "Redwood City", "10:54:00"),
	(110, "Palo Alto", "11:02:00"),
	(110, "San Jose", "12:35:00"),
	(120, "San Francisco", "11:00:00"),
	(120, "Palo Alto", "12:49:00"),
	(120, "San Jose", "13:30:00");
    
SELECT * FROM train_shedule;

CREATE OR REPLACE VIEW station_interval AS
SELECT 
	train_id,
    station,
    station_time,
	TIMEDIFF(LEAD(station_time) OVER t, station_time) AS time_to_next_station
FROM train_shedule
WINDOW t AS (
	PARTITION BY train_id
	ORDER BY station_time
);

SELECT * FROM station_interval;