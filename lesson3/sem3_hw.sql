-- Таблица staff для заданий

CREATE DATABASE IF NOT EXISTS lesson_3;
USE lesson_3;

DROP TABLE IF EXISTS staff;
CREATE TABLE staff
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(45),
    lastname VARCHAR(45),
    post VARCHAR(45),
    seniority INT, 
    salary DECIMAL(8,2),
    age INT
);

INSERT INTO staff (firstname, lastname, post, seniority, salary, age)
VALUES
 ('Вася', 'Петров', 'Начальник', 40, 100000, 60),
 ('Петр', 'Власов', 'Начальник', 8, 70000, 30),
 ('Катя', 'Катина', 'Инженер', 2, 70000, 25),
 ('Саша', 'Сасин', 'Инженер', 12, 50000, 35),
 ('Иван', 'Иванов', 'Рабочий', 40, 30000, 59),
 ('Петр', 'Петров', 'Рабочий', 20, 25000, 40),
 ('Сидр', 'Сидоров', 'Рабочий', 10, 20000, 35),
 ('Антон', 'Антонов', 'Рабочий', 8, 19000, 28),
 ('Юрий', 'Юрков', 'Рабочий', 5, 15000, 25),
 ('Максим', 'Максимов', 'Рабочий', 2, 11000, 22),
 ('Юрий', 'Галкин', 'Рабочий', 3, 12000, 24),
 ('Людмила', 'Маркина', 'Уборщик', 10, 10000, 49);
 
SELECT * FROM staff; 

-- 1. Отсортируйте данные по полю заработная плата (salary) в порядке: 
-- убывания;
SELECT * FROM staff
ORDER BY salary DESC; 

-- возрастания
SELECT * FROM staff
ORDER BY salary ASC;

-- 2. Выведите 5 максимальных заработных плат (saraly)
SELECT
	id,
    salary,
    post,
    CONCAT(firstname," ", lastname) AS fullname
FROM staff
ORDER BY salary DESC
LIMIT 5;

-- 3. Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
SELECT
	post,
    SUM(salary) AS `sum`
FROM staff
GROUP BY post;

-- 4. Найдите кол-во сотрудников со специальностью (post) «Рабочий» в возрасте от 24 до 49 лет включительно.
SELECT
	post,
    COUNT(post) AS `count`
FROM staff
WHERE post = "Рабочий"
AND age >= 24 
AND age <= 49
GROUP BY post;

-- 5. Найдите количество специальностей
SELECT 
	COUNT(DISTINCT post) as post_count
FROM staff;

-- 6. Выведите специальности, у которых средний возраст сотрудников меньше либо равен 30 лет
SELECT
	post,
    AVG(age) AS avg_age
FROM staff
GROUP BY post
HAVING avg_age <= 30;
