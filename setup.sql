-- CREATE DATABASE IF NOT EXISTS games_reviews;
-- DROP TABLE users;
-- DROP TABLE reviews;
-- DROP TABLE games;

CREATE TABLE IF NOT EXISTS users(
id INT AUTO_INCREMENT PRIMARY KEY,
username varchar(255) NOT NULL,
pass varchar(255),
salt varchar(255),
avatar LONGTEXT NULL
);


CREATE TABLE IF NOT EXISTS games(
id_game INT AUTO_INCREMENT PRIMARY KEY,
game_name varchar(255) UNIQUE NOT NULL,
cover LONGTEXT NOT NULL,
publisher varchar(255) NOT NULL,
year INT NOT NULL,
description varchar(255) NOT NULL,
upload_date_time DATETIME NOT NULL,
id_user varchar(255) NOT NULL,
CONSTRAINT FK_id_user FOREIGN KEY (id_user)
REFERENCES users(id)
);

CREATE TABLE reviews(
id_review INT AUTO_INCREMENT PRIMARY KEY,
id_game INT NOT NULL,
CONSTRAINT FK_id_game FOREIGN KEY (id_game)
REFERENCES games(id_game),
rate INT NOT NULL,
id_reviewer varchar(255) NOT NULL,
CONSTRAINT FK_reviewer_id FOREIGN KEY (id_reviewer)
REFERENCES users(id),
reveiw_date DATE NOT NULL,
description TEXT NOT NULL
);
