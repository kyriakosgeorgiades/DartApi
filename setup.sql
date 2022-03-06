CREATE DATABASE IF NOT EXISTS games_reviews;
DROP TABLE users;
DROP TABLE reviews;
DROP TABLE games;

CREATE TABLE IF NOT EXISTS users(
username varchar(255) NOT NULL PRIMARY KEY,
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
uploader varchar(255) NOT NULL,
CONSTRAINT FK_username FOREIGN KEY (uploader)
REFERENCES users(username)
);

CREATE TABLE reviews(
id_review INT AUTO_INCREMENT PRIMARY KEY,
id_game INT NOT NULL,
CONSTRAINT FK_id_game FOREIGN KEY (id_game)
REFERENCES games(id_game),
rate INT NOT NULL,
reviewer varchar(255) NOT NULL,
CONSTRAINT FK_reviewer FOREIGN KEY (reviewer)
REFERENCES users(username),
reveiw_date DATE NOT NULL,
description TEXT NOT NULL
);
