DROP DATABASE IF EXISTS twitter_db;

CREATE DATABASE twitter_db;

show databases;

USE twitter_db;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
	user_id INT AUTO_INCREMENT,
    user_handle VARCHAR(50) NOT NULL UNIQUE,
    email_address VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phonenumber CHAR(10) UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT (NOW()),
    PRIMARY KEY(user_id)
);

-- INSERT INTO users(user_handle, email_address, first_name, last_name, phonenumber)
-- VALUES ('midudev', 'midudev@gmail.com', 'Miguel', 'Angel', '69999999');
INSERT INTO users(user_handle, email_address, first_name, last_name, phonenumber)
VALUES
('midudev', 'midudev@gmail.com', 'Miguel', 'Angel', '69999999'),
('ferndinandalexa', 'ferndinand@gmail.com', 'Fernando', 'Alexa', '68888899'),
('marta815', 'marta815@gmail.com', 'Marta', 'Garcia', '666666756'),
('itziar', 'itzi@gmail.com', 'Itzi', 'Ar', '75474567'),
('phrealb', 'phrealb@gmail.com', 'Pablo', 'Hdz', '753113515'),
('astrak3', 'astrauegobaby@gmail.com', 'Ivan', 'Jesus', '12345678');

DROP TABLE IF EXISTS followers;

CREATE TABLE followers(
	follower_id INT NOT NULL,
    following_id INT NOT NULL,
    FOREIGN KEY(follower_id) REFERENCES users(user_id),
    FOREIGN KEY(following_id) REFERENCES users(user_id),
    PRIMARY KEY(follower_id, following_id)
);

-- Desde la version 8 de MySQL
-- Se pueden agregar constrains para hacer checks
ALTER TABLE followers
ADD CONSTRAINT check_follower_id
CHECK (follower_id <> following_id);

INSERT INTO followers(follower_id, following_id)
VALUES
(1,2),
(2,1),
(3,1),
(4,1),
(5,6),
(6,5),
(2,5),
(3,5);

/*
-- Recuperar tabla de followers
SELECT follower_id, following_id FROM followers;
SELECT follower_id FROM followers WHERE following_id = 1;
SELECT COUNT(follower_id) AS followers FROM followers WHERE following_id = 1;
*/

-- TOP 3 usuarios con mayor numero de seguidores
/*
SELECT following_id, COUNT(follower_id) AS followers
FROM followers
GROUP BY following_id
ORDER BY followers DESC
LIMIT 3;
*/

-- Top 3 usuarios pero haciendo JOIN
/*
SELECT users.user_id, users.user_handle, users.first_name, following_id, COUNT(follower_id) AS followers
FROM followers
JOIN users ON users.user_id = followers.following_id
GROUP BY following_id
ORDER BY followers DESC
LIMIT 3;
*/

CREATE TABLE tweets(
	tweet_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    tweet_text VARCHAR(280) NOT NULL,
    num_likes INT DEFAULT 0,
    num_retweets INT DEFAULT 0,
    num_comments INT DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT (NOW()),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    PRIMARY KEY (tweet_id) 
);

INSERT INTO tweets(user_id, tweet_text)
VALUES
(1, 'Hola, soy midude! Que tal?🚀'),
(2, 'Entrando en Twitter. Que genial! 🤘'),
(3, 'HTML es un lenguaje de programciontweets'),
(1, 'Sigueme en https://twitch.tv/midudev!!!'),
(2, 'Hoy es un dia soleado! ☀️'),
(3, 'Me encanta la musica'),
(1, 'Programando nuevo proyecto. Emocionado!'),
(1, 'Me cae mal Elon Musk'),
(1, 'Explorando nuevas tecnologias. Hay tanto por aprender!');

-- Cuantos tweets ha hecho un usuario?
SELECT user_id, COUNT(*) AS tweet_count
FROM tweets
WHERE user_id = 1;

-- Sub consulta
-- Obtener los tweets de los usuarios que tienen mas de 2 seguidores
SELECT tweet_id, tweet_text, user_id
FROM tweets
WHERE user_id IN(
	SELECT following_id
	FROM followers
	GROUP BY following_id
	HAVING COUNT(*) > 2
);

-- DELETE
-- DELETE FROM tweets WHERE tweet_id = 1;
-- DELETE FROM tweets WHERE user_id = 1;
-- DELETE FROM tweets WHERE tweet_text LIKE '%Elon Musk%';

-- UPDATE
UPDATE tweets SET num_comments = num_comments + 1 WHERE tweet_id = 2;

-- Reemplazar Texto
SET SQL_SAFE_UPDATES = 0; -- Desactivamos el modo seguro temporalmente

UPDATE tweets 
SET tweet_text = REPLACE(tweet_text, 'Twitter', 'Threads') 
WHERE tweet_text LIKE '%Twitter%' AND tweet_id IS NOT NULL;

SET SQL_SAFE_UPDATES = 1; -- Reactivamos el modo seguro temporalmente

-- Tabla de LIKES
CREATE TABLE tweet_likes(
	user_id INT NOT NULL,
    tweet_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id),
    PRIMARY KEY (user_id, tweet_id)
);

INSERT INTO tweet_likes (user_id, tweet_id)
VALUES (1, 3), (2, 3), (1, 1), (1, 2), (1, 4), (2, 1), (3, 1), (5, 2), (5, 3);
-- VALUES (1,3), (1,6), (3,7), (4, 7), (1,7), (3, 6), (2, 7), (5, 7);

-- Obtener el numero de likes para cada tweet
SELECT tweet_id, COUNT(*) AS like_count
FROM tweet_likes
GROUP BY tweet_id;

/* TRIGGERS */

