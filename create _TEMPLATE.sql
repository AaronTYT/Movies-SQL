-- Student Number(s): 10471321, 10469175
-- Student Name(s):	Aaron, Gareth

/*	Database Creation & Population Script (8 marks)
	Produce a script to create the database you designed in Task 1 (incorporating any changes you have made since then).  
	Be sure to give your columns the same data types, properties and constraints specified in your data dictionary, and be sure to name tables and columns consistently.  
	Include any logical and correct default values and any check or unique constraints that you feel are appropriate.

	Make sure this script can be run multiple times without resulting in any errors (hint: drop the database if it exists before trying to create it).  
	You can use/adapt the code at the start of the creation scripts of the sample databases available in the unit materials to implement this.

	See the assignment brief for further information. 
	movieTheatre
*/
--  Setting the active database to the built in 'master' database ensures that we are not trying to drop the currently active database.
--  Setting the database to 'single user' mode ensures that any other scripts currently using the database will be disconnectetd.
--  This allows the database to be deleted, instead of giving a 'database in use' error when trying to delete it.

IF DB_ID('movieTheatre') IS NOT NULL             
	BEGIN
		PRINT 'Database exists - dropping.';
		
		USE master;		
		ALTER DATABASE movieTheatre SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		
		DROP DATABASE movieTheatre;
	END

GO

--  Now that we are sure the database does not exist, we create it.
PRINT 'Creating database.';
CREATE DATABASE movieTheatre;
GO

--  Now that an empty database has been created, we will make it the active one.
--  The table creation statements that follow will therefore be executed on the newly created database.

USE movieTheatre;

GO

-- Creating the tables in their table of creation order.

CREATE TABLE cinemaTypes
(
	cinemaTypeID INT NOT NULL CONSTRAINT cinemaTypeID_pk PRIMARY KEY IDENTITY,
	name VARCHAR(20) NOT NULL
);

INSERT INTO cinemaTypes
VALUES ('2D'), ('3D'), ('Gold Class 2D'), ('Gold Class 3D');


CREATE TABLE cinemas
(
	cinemaIDNumber INT NOT NULL CONSTRAINT cinemaIDNumber_pk PRIMARY KEY IDENTITY,
	cinemaTypeID INT NOT NULL CONSTRAINT cinemaTypeID_fk FOREIGN KEY
							REFERENCES cinemaTypes(cinemaTypeID),
	name VARCHAR(30) NOT NULL,
	seatCapacity SMALLINT NOT NULL
);	

INSERT INTO cinemas
VALUES(1,'Cinema 1', 200), (2, 'Cinema 2', 300), (3, 'Cinema 3', 150), (4, 'Cinema 4', 100);

CREATE TABLE classifications
(
	classification VARCHAR(2) NOT NULL CONSTRAINT classifiction_pk PRIMARY KEY CHECK(classification IN ('G', 'PG', 'M', 'MA', 'R')),
	className VARCHAR(20) NOT NULL,
	minAge TINYINT NULL
);
/*  The following statement inserts the details of 5 classifications into a table named "classification".
    It specifies values for 3 columns - the classification's abbreviation, name and minimum age restriction (where appropriate).
	Make sure that the columns in your classification table are suitable to contain the values below (e.g. the classification name column is long enough to contain the longest classification name).
	If required, make any necessary changes to the design of your database or the statement below so that the data can be inserted into your database.
*/
INSERT INTO classifications
VALUES ('G',  'General', NULL),
       ('PG', 'Parental Guidance', NULL),
       ('M',  'Mature', NULL),
       ('MA', 'Mature Audiences', 15),
       ('R',  'Restricted', 18);

CREATE TABLE movies
(
	movieIDNumber INT NOT NULL CONSTRAINT movieIDNumber_pk PRIMARY KEY IDENTITY,
	name VARCHAR(50) NOT NULL,
	duration INT NOT NULL,
	desc_details VARCHAR(250) NOT NULL,
	classification VARCHAR(2) CONSTRAINT classification_fk FOREIGN KEY
									REFERENCES classifications(classification)
)

/*	The following statement inserts the details of 10 movies into a table named "movie". 
    It specifies values for 4 columns:  The movie name, its duration in minutes, a description of the movie, and its classification.
	Movie ID numbers numbers are not specified since it is assumed that an auto-incrementing integer is being used as the primary key for this table.
	If required, make any necessary changes to the design of your database or the statement below so that the data can be inserted into your database.
	The data in this table was retrieved from IMDB (http://www.imdb.com/).
*/
INSERT INTO movies
VALUES ('The Shawshank Redemption', 142, 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.', 'MA'),
       ('Pulp Fiction', 154, 'The lives of two mob hit men, a boxer, a gangster''s wife, and a pair of diner bandits intertwine in four tales of violence and redemption.', 'R'),
       ('Forrest Gump', 142, 'Forrest Gump, while not intelligent, has accidentally been present at many historic moments, but his true love, Jenny Curran, eludes him.', 'M'),
       ('Star Wars: Episode IV - A New Hope', 121, 'Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a wookiee and two droids to save the universe from the Empire''s world-destroying battle-station.', 'PG'),
       ('WALL-E', 98, 'In the distant future, a small waste collecting robot inadvertently embarks on a space journey that will ultimately decide the fate of mankind.', 'G'),
       ('Eternal Sunshine of the Spotless Mind', 108, 'When their relationship turns sour, a couple undergoes a procedure to have each other erased from their memories. But it is only through the process of loss that they discover what they had to begin with.', 'M'),
       ('Monty Python and the Holy Grail', 91, 'King Arthur and his knights embark on a low-budget search for the Grail, encountering many very silly obstacles.', 'PG'),
       ('Up', 96, 'Seventy-eight year old Carl Fredricksen travels to Paradise Falls in his home equipped with balloons, inadvertently taking a young stowaway.', 'PG'),
       ('Gran Torino', 116, 'Disgruntled Korean War veteran Walt Kowalski sets out to reform his neighbor, a Hmong teenager who tried to steal Kowalski''s prized possession: a 1972 Gran Torino.', 'M'),
       ('Metropolis', 153, 'In a futuristic city sharply divided between the working class and the city planners, the son of the city''s mastermind falls in love with a working class prophet who predicts the coming of a savior to mediate their differences.', 'PG');

CREATE TABLE sessions
(
	sessionIDNumber INT NOT NULL CONSTRAINT sessionIDNumber_pk PRIMARY KEY IDENTITY,
	cinemaIDNumber INT NOT NULL CONSTRAINT cinemaIDNumber_fk FOREIGN KEY
								REFERENCES cinemas(cinemaIDNumber),
	movieIDNumber INT NOT NULL CONSTRAINT movieIDNumber_fk FOREIGN KEY
								REFERENCES movies(movieIDNumber),
	dTime DATETIME NOT NULL,
	ticketCost MONEY NOT NULL
);

INSERT INTO sessions
VALUES (1, 1, '2018-06-09 12:00:00', 20),
		(2, 3, '2018-06-09 02:00:00', 18),
		(3, 4, '2018-06-09 04:00:00', 19),
		(4, 5, '2018-06-09 06:00:00', 21);

-- Create customer details and ensure that their email is unique. Cannot be the same.
CREATE TABLE customers
(
	customerIDNumber INT NOT NULL CONSTRAINT customerIDNumber_pk PRIMARY KEY IDENTITY,
	emailaddress VARCHAR(35) NOT NULL UNIQUE,
	pwrd VARCHAR(25) NOT NULL,
	firstName VARCHAR(30) NOT NULL,
	lastName VARCHAR (30) NOT NULL,
	DOB DATE NULL
);

INSERT INTO customers
VALUES ('ben.@gmail.com.au', 'abcd1234', 'Ben', 'Ten', '1998-05-02'), 
	('luffy@yahoo.com.au', 'onepieceLol', 'Luffy', 'Monkey', '2001-06-05'),
	('mario@gmail.com.au', 'marioBros', 'Mario', 'Mario', '1980-07-01'),
	('peach@gmail.com.au', 'peachisafruit', 'Peach', 'Fruit', '1988-08-08'),
	('frank@outlook.com.au', 'frankisgreat', 'Frank', 'Person', '1997-05-08'),
	('justicehero@hotmail.com.au', 'acbd123', 'Justice', 'Rick', '2001-08-22'),
	('bird127@hotmail.com.au', 'birds', 'Sam', 'Bird', '2003-07-02');

CREATE TABLE tickets
(	
	ticketIDNumber INT NOT NULL CONSTRAINT ticketIDNumber_pk PRIMARY KEY IDENTITY,
	customerIDNumber INT NOT NULL CONSTRAINT customerIDNumber_fk FOREIGN KEY
									REFERENCES customers(customerIDNumber),
	sessionIDNumber INT NOT NULL CONSTRAINT sessionIDNumber_fk FOREIGN KEY
									REFERENCES sessions(sessionIDNumber)
);

INSERT INTO tickets
VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 1), (4, 3), (3, 1);

-- Create a review table for customers to select the moviename, give comments and give it rating.
CREATE TABLE reviews
(
	reviewIDNumber INT NOT NULL CONSTRAINT reviewIDNumber_pk PRIMARY KEY IDENTITY,
	customerIDNumber INT NOT NULL CONSTRAINT customerReviewIDNumber_fk FOREIGN KEY
									REFERENCES customers(customerIDNumber),
	movieIDNumber INT NOT NULL CONSTRAINT movieReviewIDNumber_fk FOREIGN KEY
									REFERENCES movies(movieIDNumber),
	text VARCHAR(200) NULL,
	rating SMALLINT NOT NULL CHECK(rating BETWEEN 1 AND 5),
	dTime DATETIME NOT NULL DEFAULT(GETDATE())
);

INSERT INTO reviews
VALUES(1, 1, 'This movie is awesome', 5, '2018-04-09 13:04:10'),
		(2, 2, 'This movie is somewhat terrible', 2, '2018-06-28 16:06:22'),
		(3, 3, 'This movie is alright. It needs more drama and romantic moments.', 3, '2018-07-11 21:12:15'),
		(4, 4, 'This movie is the worst I have ever seen! Too much romance. Need more fightining scenes.', 1, '2018-08-24 21:30:30'),
		(4, 5, 'This movie is somewhat alright', 3, '2018-09-14 14:25:00'),
		(6, 2, 'This movie is somewhat alright', 3, '2018-09-14 14:25:00'),
		(3, 3, 'This movie is boring', 1, '2018-09-14 14:25:00'),
		(5, 1, 'This movie is boring and stupid', 2, '2018-08-17 12:55:22');

CREATE TABLE genres
(
	genreIDNumber INT NOT NULL CONSTRAINT genreIDNumber_pk PRIMARY KEY IDENTITY,
	name VARCHAR(20) NOT NULL
);

/*	The following statement inserts the details of 10 genres into a table named "genre". 
    It specifies values for 1 column:  The genre name.
	Genre ID numbers numbers are not specified since it is assumed that an auto-incrementing integer is being used as the primary key for this table.
	If required, make any necessary changes to the design of your database or the statement below so that the data can be inserted into your database.
*/

INSERT INTO genres
VALUES ('Action'),     -- Genre 1
       ('Adventure'),  -- Genre 2
       ('Animation'),  -- Genre 3
       ('Comedy'),     -- Genre 4
       ('Crime'),      -- Genre 5
       ('Drama'),      -- Genre 6
       ('Fantasy'),    -- Genre 7
       ('Horror'),     -- Genre 8
       ('Romance'),    -- Genre 9
       ('Sci-Fi');     -- Genre 10

CREATE TABLE movieGenre
(
	movieIDNumber INT NOT NULL FOREIGN KEY REFERENCES movies(movieIDNumber),
	genreIDNumber INT NOT NULL FOREIGN KEY REFERENCES genres(genreIDNumber)
	PRIMARY KEY(movieIDNumber, genreIDNumber)
);

/*	The following statement inserts the details of which genres apply to which movies into a table named "movie_genre". 
    It specifies values for 2 columns:  A movie ID number, followed by a genre ID number.
    For clarity and conciseness, the values have been grouped by movie.
	If required, make any necessary changes to the design of your database or the statement below so that the data can be inserted into your database.
*/

INSERT INTO movieGenre
VALUES (1, 5), (1, 6),           -- Shawshank: Crime & Drama
       (2, 5), (2, 6),           -- Pulp Fiction: Crime & Drama
       (3, 6), (3, 9),           -- Forrest Gump: Drama & Romance
       (4, 1), (4, 2), (4, 7),   -- Star Wars: Action & Adventure & Fantasy
       (5, 2), (5, 3),           -- Wall-E: Adventure & Animation
       (6, 6), (6, 9), (6, 10),  -- Eternal Sunshine: Drama & Romance & Sci-Fi
       (7, 2), (7, 4), (7, 7),   -- Holy Grail: Adventure & Comedy & Fantasy
       (8, 2), (8, 3),           -- Up: Adventure & Animation
       (9, 6),                   -- Gran Torino: Drama
       (10, 6), (10, 10);        -- Metropolis: Drama & Sci-Fi
