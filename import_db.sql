CREATE TABLE users (
	id INTEGER PRIMARY KEY,
	fname VARCHAR(255) NOT NULL,
	lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
	id INTEGER PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	body TEXT NOT NULL,
	author_id INTEGER NOT NULL,
	FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,
	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	reply_id INTEGER,
	reply_user_id INTEGER NOT NULL,
	body TEXT NOT NULL,
	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (reply_id) REFERENCES replies(id),
	FOREIGN KEY (reply_user_id) REFERENCES users(id)

);

CREATE TABLE question_likes (
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE tags (
	id INTEGER PRIMARY KEY,
	name TEXT NOT NULL
);

CREATE TABLE question_tags (
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	tag_id INTEGER,
	FOREIGN KEY (question_id) REFERENCES questions(id),
	FOREIGN KEY (tag_id) REFERENCES tags(id)
);

INSERT INTO
	users (fname, lname)
VALUES
	('Travis' , 'Randolph'),
	('Brent', 'Smith'),
	('John', 'Doe'),
	('Santos', 'Helper'),
	('Foo', 'Bar');

INSERT INTO
	questions (title, body, author_id)
VALUES
	('Question', 'Why is SQL so boring', (SELECT id FROM users WHERE fname = 'Travis' AND lname = 'Randolph' )),
	('Question2', 'Why is SQL so boring? For reals?', (SELECT id FROM users WHERE fname = 'Travis' AND lname = 'Randolph' )),
	('Question3', 'Why is SQL so freaking boring? For reals?', (SELECT id FROM users WHERE fname = 'Travis' AND lname = 'Randolph' ));

INSERT INTO
  replies (question_id, reply_user_id, body)
VALUES
	((SELECT id FROM questions WHERE title = 'Question'), (SELECT id FROM users WHERE fname = 'Brent' AND lname = 'Smith'), "AWesome question");

INSERT INTO
	question_followers (question_id, user_id)
VALUES
	((SELECT id FROM questions WHERE title = 'Question'), (SELECT id FROM users WHERE fname = 'Travis' AND lname = 'Randolph'));

INSERT INTO
	question_likes (question_id, user_id)
VALUES
	(1, 2), (1, 3), (1, 4), (2, 2), (2, 4), (3, 2);

INSERT INTO
tags (name)
VALUES
("html"), ("javascript");

INSERT INTO
question_tags (question_id, tag_id)
VALUES
(1,1) , (3,1), (2,2);

