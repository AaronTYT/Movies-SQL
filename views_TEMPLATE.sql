-- Student Number(s):	10417321, 10469175
-- Student Name(s):		Aaron, Gareth

USE movieTheatre;
GO

/*	Cinema View (1 mark)
	Create a view that selects the cinema ID number, cinema name, seating capacity and the name of the cinema type for all cinemas.
	This will involve joining the cinema and cinema type tables.
*/

-- Write your Cinema View here

CREATE VIEW cinemaView AS
	SELECT c.cinemaIDNumber AS 'cinemaIDNumber', c.name AS 'cinemaName', c.seatCapacity AS 'seatCapacity',
	cType.cinemaTypeID, cType.name AS 'cinemaType'
	FROM cinemas AS c INNER JOIN cinemaTypes AS cType
	ON cType.cinemaTypeID = c.cinemaTypeID;

/*	Session View (2 marks)
	Create a view that selects the following details of all rows in the “session” table:
      • The session ID number, session date/time and cost of the session.
      • The movie ID number, movie name and classification of the movie (e.g. “PG”) being shown.
      • The cinema ID number, cinema name, seating capacity and cinema type name of the cinema that the session is in.

    This statement requires you to use multiple JOINs.  Using the Cinema View in this view is recommended.
*/

-- Write your Session View here
CREATE VIEW sessionView AS
	SELECT s.sessionIDNumber, s.dTime AS 'sessionDTime', s.ticketCost AS 'ticketCost',
	m.movieIDNumber, m.name AS 'movieName', m.classification,
	cView.cinemaIDNumber, cView.cinemaName AS 'cinemaName', cView.seatCapacity, cView.cinemaType
	FROM sessions AS s INNER JOIN movies AS m
	ON s.movieIDNumber = m.movieIDNumber
	INNER JOIN cinemaView AS cView
	ON s.cinemaIDNumber = cView.cinemaIDNumber;

/*	If you wish to create additional views to use in the queries which follow, include them in this file. */


