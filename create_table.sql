drop table admin_users;
drop table country;
drop table school;
drop table user_reviews;

create table users(
uname varchar(255) NOT NULL,
pw varchar(255),
email varchar(255),
is_admin Boolean,
token varchar(56),
PRIMARY KEY (uname)
);

create table country(
short_name varchar(3) NOT NULL,
full_name varchar(50),
PRIMARY KEY (short_name)
);

create table school(
school_id int NOT NULL,
full_name varchar(100),
short_name varchar(10),
place varchar(50),
zip int,
country varchar(3),
PRIMARY KEY (school_id)
);

create table user_reviews(
school_id INT,
user_id VARCHAR(255) NOT NULL,
review varchar(500)
);

