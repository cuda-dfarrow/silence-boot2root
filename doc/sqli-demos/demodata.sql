DROP TABLE users;

CREATE TABLE users (
  id        serial        PRIMARY KEY,
  name      varchar (50)  NOT NULL,
  password  varchar (50)  NOT NULL,
  cellnum   varchar (12)  NOT NULL
);

INSERT INTO users (name, password, cellnum) VALUES
  ('sally', 'supersal99', '559-575-1337'),
  ('craig', 'craig_is_crAzY', '559-575-1338'),
  ('yusuf', 'c@tzCr@dl3', '559-575-1339')
;

\d

SELECT name, '***REDACTED ;)' as password, cellnum from users;
