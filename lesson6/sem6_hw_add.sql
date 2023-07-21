USE vk;

-- Создать процедуру, которая решает следующую задачу
-- Выбрать для одного пользователя 5 пользователей в случайной комбинации, которые удовлетворяют хотя бы одному критерию:
-- а) из одного города
-- б) состоят в одной группе
-- в) друзья друзей

DROP PROCEDURE IF EXISTS showfive;
DELIMITER $$ 
CREATE PROCEDURE showfive(IN userid INT)
BEGIN
	-- из одного города
	SELECT id, firstname, lastname, email
	FROM users u
	JOIN `profiles` p
	ON u.id = p.user_id
    WHERE p.hometown = (SELECT hometown FROM profiles WHERE user_id = userid)
    HAVING id != userid
	-- состоят в одной группе
	UNION    
	SELECT DISTINCT id, firstname, lastname, email
	FROM users u
	JOIN users_communities uc
	ON u.id = uc.user_id
	WHERE uc.community_id IN (
		SELECT community_id
		FROM users_communities
		WHERE users_communities.user_id = userid
	)
    HAVING id != userid
	-- друзья друзей
	UNION
	SELECT id, firstname, lastname, email
	FROM users u
	WHERE u.id IN (
		SELECT initiator_user_id
		FROM friend_requests
		WHERE `status`='approved' 
		AND target_user_id IN (
			SELECT initiator_user_id
			FROM friend_requests
			WHERE target_user_id = userid AND `status`='approved'
			UNION
			SELECT target_user_id 
			FROM friend_requests
			WHERE initiator_user_id = userid AND `status`='approved'
		) 
		UNION
		SELECT target_user_id 
		FROM friend_requests
		WHERE `status`='approved' 
		AND initiator_user_id IN (
			SELECT initiator_user_id AS id 
			FROM friend_requests
			WHERE target_user_id = userid AND `status`='approved'
			UNION
			SELECT target_user_id 
			FROM friend_requests
			WHERE initiator_user_id = userid AND `status`='approved'
		)
	)
    HAVING id != userid
    ORDER BY RAND()
    LIMIT 5;
END $$
DELIMITER ;

CALL showfive(1);

-- Создать функцию, вычисляющую коэффициент популярности пользователя (по количеству друзей)

DROP FUNCTION IF EXISTS get_popularity_coefficient;
DELIMITER $$
CREATE FUNCTION get_popularity_coefficient(
	user_id INT
)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE result INT DEFAULT 0;
	SELECT (   
		SELECT count(f.id)
		FROM (
			SELECT fr.initiator_user_id AS id
			FROM friend_requests fr
			WHERE fr.target_user_id = u.id AND fr.`status`='approved'
			UNION
			SELECT fr.target_user_id 
			FROM friend_requests fr
			WHERE fr.initiator_user_id = u.id AND fr.`status`='approved'
		) f
	) AS friends_count INTO result
	FROM users u
    WHERE u.id = user_id;
    RETURN result;
END $$
DELIMITER ;

SELECT get_popularity_coefficient(1); 

-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу 
-- "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello()
RETURNS VARCHAR(20) DETERMINISTIC
BEGIN
    DECLARE ct TIME;
    DECLARE greeting VARCHAR(20);
    SET ct = CURTIME();
    IF ct >= '06:00:00' AND ct < '12:00:00' THEN
        SET greeting = 'Доброе утро';
    ELSEIF ct >= '12:00:00' AND ct < '18:00:00' THEN
        SET greeting = 'Добрый день';
    ELSEIF ct >= '18:00:00' AND ct < '00:00:00' THEN
        SET greeting = 'Добрый вечер';
    ELSE
        SET greeting = 'Доброй ночи';
    END IF;
    RETURN greeting;
END //
DELIMITER ;

SELECT hello();

-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, communities и messages 
-- в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа. (Триггеры)

-- Создание таблицы logs

DROP TABLE IF EXISTS logs ;
CREATE TABLE logs (
id INT AUTO_INCREMENT PRIMARY KEY,
table_name VARCHAR(255) NOT NULL,
primary_key_id INT NOT NULL,
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создание триггера для таблицы users
DELIMITER $$
CREATE TRIGGER users_insert_trigger AFTER INSERT ON users
FOR EACH ROW
BEGIN
INSERT INTO logs (primary_key_id, table_name) VALUES (NEW.id, 'users');
END$$
DELIMITER ;

-- Создание триггера для таблицы communities

DELIMITER $$
CREATE TRIGGER communities_insert_trigger AFTER INSERT ON communities
FOR EACH ROW
BEGIN
INSERT INTO logs (primary_key_id, table_name) VALUES (NEW.id, 'communities');
END$$
DELIMITER ;

-- Создание триггера для таблицы messages

DELIMITER $$
CREATE TRIGGER messages_insert_trigger AFTER INSERT ON messages
FOR EACH ROW
BEGIN
INSERT INTO logs (primary_key_id, table_name) VALUES (NEW.id, 'messages');
END$$
DELIMITER ;

SELECT * FROM logs;