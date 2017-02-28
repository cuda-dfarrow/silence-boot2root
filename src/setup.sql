CREATE DATABASE IF NOT EXISTS music;

USE music;

CREATE TABLE IF NOT EXISTS sessions (
    id CHAR(32) UNIQUE NOT NULL,
    a_session TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS users (
    id CHAR(32) UNIQUE NOT NULL,
    pass CHAR(128) NOT NULL
);

DELETE FROM users WHERE id != '';
INSERT INTO users (id, pass) VALUES( 'psimon', 'afgadgaeg34tfgbw' );
INSERT INTO users (id, pass) VALUES( 'agarfunkel', 'gaeg34t$%' );

GRANT SELECT,INSERT,UPDATE,DELETE ON *.* TO 'psimon'@'%' IDENTIFIED BY 'kathy';