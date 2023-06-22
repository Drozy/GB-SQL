/*
	1. Создайте таблицу с мобильными телефонами, используя графический
	интерфейс. Заполните БД данными. Добавьте скриншот на платформу в качестве
	ответа на ДЗ
*/

CREATE DATABASE IF NOT EXISTS lesson1;
USE lesson1;

DROP TABLE IF EXISTS mobile_phone;
CREATE TABLE mobile_phone 
(
	Id INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(40) NOT NULL,
    Manufacturer VARCHAR(40) NOT NULL,
    ProductCount INT(5),
    Price FLOAT(8)
);

INSERT mobile_phone(ProductName, Manufacturer, ProductCount, Price)
VALUES
	("iPhone X", "Apple", 3, 76000),
	("iPhone 8", "Apple", 2, 51000),
	("Galaxy S9", "Samsung", 2, 56000),
    ("Galaxy S8", "Samsung", 1, 41000),
    ("P20 Pro", "Huawei", 5, 36000);
    
SELECT * FROM mobile_phone

/*
	2. Выведите название, производителя и цену для товаров,
	количество которых превышает 2 (SQL - файл, скриншот, либо сам
	код)
*/

SELECT ProductName, Manufacturer, Price
FROM mobile_phone
WHERE ProductCount > 2

-- 3. Выведите весь ассортимент товаров марки “Samsung”

SELECT ProductName, Manufacturer, ProductCount, Price
FROM mobile_phone
WHERE Manufacturer = "Samsung"

/*
	4. Выведите информацию о телефонах, где суммарный чек
	больше 100 000 и меньше 145 000**
*/

SELECT ProductName, Manufacturer, ProductCount, Price
FROM mobile_phone
WHERE (ProductCount * Price) > 100000 AND (ProductCount * Price) < 145000

/*
	4.*** С помощью регулярных выражений найти (можно использовать
	операторы “LIKE”, “RLIKE” для 4.3 ):
		4.1. Товары, в которых есть упоминание "Iphone"
		4.2. "Galaxy"
		4.3. Товары, в которых есть ЦИФРЫ
		4.4. Товары, в которых есть ЦИФРА "8"
*/

-- 4.1
SELECT ProductName, Manufacturer, ProductCount, Price
FROM mobile_phone
WHERE ProductName LIKE "%iphone%"

-- 4.2
SELECT ProductName, Manufacturer, ProductCount, Price
FROM mobile_phone
WHERE ProductName LIKE "%Galaxy%"

-- 4.3
SELECT ProductName, Manufacturer, ProductCount, Price
FROM mobile_phone
WHERE ProductName RLIKE "[0-9]"

-- 4.4
SELECT ProductName, Manufacturer, ProductCount, Price
FROM mobile_phone
WHERE ProductName RLIKE "8"
