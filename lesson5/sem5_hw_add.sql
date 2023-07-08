-- Создание базы в vk_db_seed.sql
USE vk;

-- Получите друзей пользователя с id=1 (решение задачи с помощью представления “друзья”)
CREATE OR REPLACE VIEW view_friends AS
SELECT *
FROM users u
JOIN friend_requests fr
ON u.id = initiator_user_id OR u.id = target_user_id
WHERE fr.`status` = 'approved'
ORDER BY u.id;

SELECT 
	id,
	firstname,
    lastname,
    email
FROM view_friends
WHERE initiator_user_id = 1 OR target_user_id = 1
HAVING id != 1;

-- Создайте представление, в котором будут выводится все сообщения, в которых принимал участие пользователь с id = 1.
CREATE OR REPLACE VIEW view_messages AS
SELECT *
FROM messages
WHERE from_user_id = 1 OR to_user_id = 1
ORDER BY created_at;

SELECT * FROM view_messages;

-- Получите список медиафайлов пользователя с количеством лайков (media m, likes l, users u)
SELECT 
    u.id,
    CONCAT(u.firstname, ' ', u.lastname) AS fullname,
    u.email,
    media_likes.filename,
    media_likes.count_likes
FROM
    users u
        JOIN
    (SELECT 
        m.id,
		m.filename AS filename,
		m.user_id AS m_id,
		COUNT(l.id) AS count_likes
    FROM
        media m
    LEFT JOIN likes l ON m.id = l.media_id
    GROUP BY m.id) media_likes ON u.id = media_likes.m_id
ORDER BY u.id;

-- Получите количество групп у пользователей
SELECT
	u.id,
    CONCAT(u.firstname, ' ', u.lastname) AS fullname,
    u.email,
    COUNT(c.user_id) AS count_communities
FROM users u
LEFT JOIN users_communities c
ON u.id = c.user_id
GROUP BY u.id;

-- 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет.
CREATE OR REPLACE VIEW sample1 AS
SELECT 
	u.firstname,
    u.lastname,
    p.hometown,
    p.gender,
    (YEAR(CURRENT_DATE) - YEAR(p.birthday)) - 
	(DATE_FORMAT(CURRENT_DATE, '%m%d') < DATE_FORMAT(p.birthday, '%m%d')) AS age
FROM users u
JOIN `profiles` p
ON u.id = p.user_id
HAVING age <= 20;
    
SELECT * FROM sample1;

-- 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователей, 
-- указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
-- (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)
SELECT
	u.id,
    CONCAT(u.firstname, ' ', u.lastname) AS fullname,
    COUNT(m.from_user_id) AS message_count,
    DENSE_RANK() OVER(ORDER BY COUNT(m.from_user_id) DESC) AS `dense_rank`
FROM users u
LEFT JOIN messages m
ON u.id = m.from_user_id
GROUP BY u.id;

-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) 
-- и найдите разницу дат отправления между соседними сообщениями, получившегося списка. (используйте LEAD или LAG)
SELECT 
	m.*,
    0 - DATEDIFF(LAG(created_at) OVER t, created_at) AS date_diff
FROM messages m
WINDOW t AS (
	ORDER BY m.created_at
);