-- Student Number(s):	10471321, 10469175
-- Student Name(s):		Aaron, Gareth

USE movieTheatre;

/*	Query 1 – Child Friendly Movies (2 marks)
	Write a query that selects the movie name, duration and classification of all movies that have a duration of less than 100 minutes 
	and a classification of “G” or “PG”.  Order the results by duration.
*/

-- Write Query 1 here
SELECT name, duration, classification
FROM movies
WHERE duration < 100 AND classification IN('G', 'PG') ORDER BY duration;

/*	Query 2 – Movie Search (2 marks)
	Write a query that selects the movie name, session date/time, cinema type name and cost of all upcoming sessions (i.e. session date/time is later than the current date/time) 
	showing movies that have “star wars” anywhere in the movie name.  Order the results by session date/time.  Using the Session View in this query is recommended.
*/
-- Write Query 2 here
SELECT movieName, sessionDTime, cinemaName, ticketCost
FROM sessionView WHERE movieName LIKE '%star wars%' ORDER BY sessionDTime;

/*	Query 3 – Review Details (2 marks)
	Write a query that selects the details of all reviews for the movie with a movie ID number of 5. 
	The results should include the text of the review, the date/time the review was posted, the rating given, 
	and the first name and age (calculated from the date of birth) of the customer who posted the review.
	Order the results by the review date, in descending order.
*/
-- Write Query 3 here

SELECT text AS 'reviewText', dTime, rating, firstName, DATEDIFF(year, DOB, GETDATE()) AS 'Age'
FROM reviews INNER JOIN customers
ON reviews.customerIDNumber = customers.customerIDNumber
WHERE movieIDNumber = 5 ORDER BY dTime DESC;

/*	Query 4 – Genre Count (3 marks)
	Write a query that selects the name of all genres in the genre table, and the number of movies of each genre.  
	Be sure to show all genres, even if there are no movies of that genre in the database.

    Hint:  This will involve using an OUTER JOIN, GROUP BY and COUNT.
*/
-- Write Query 4 here
SELECT name AS 'genreName', COUNT(movieIDNumber) AS 'counts' FROM
genres LEFT OUTER JOIN movieGenre
ON movieGenre.genreIDNumber = genres.genreIDNumber GROUP BY name;

/*	Query 5 – Movie Review Stats (3 marks)
	Write a query that selects the names of all movies in the movie table, how many reviews have been posted per movie, and the average star rating of the reviews per movie.  
	Be sure to include all movies, even if they have not been reviewed.
	Round the average rating to one decimal place, and order the results by the average rating, in descending order.
*/
-- Write Query 5 here
SELECT name AS 'movieName', COUNT(reviewIDNumber) AS 'numReviews', ROUND(AVG(CAST(rating AS FLOAT)), 1) AS 'averageRating'
FROM movies LEFT OUTER JOIN reviews
ON movies.movieIDNumber = reviews.movieIDNumber
GROUP BY name ORDER BY averageRating DESC;

/*	Query 6 – Top Selling Movies (3 marks)
	Write a query that selects the name and total number of tickets sold of the three most popular movies (determined by total ticket sales).  
	Using the Session View in this query is recommended.

    Hint:  Join the session view/table to the ticket table and group the results by movie.
*/
-- Write Query 6
SELECT TOP 3 movieName, COUNT(ticketIDNumber) AS 'ticketSold' FROM sessionView
INNER JOIN tickets
ON sessionView.sessionIDNumber = tickets.sessionIDNumber GROUP BY movieName
ORDER BY ticketSold DESC;

/*	Query 7 – Customer Ticket Stats (4 marks)
	Write a query that that selects the full names (by concatenating their first name and last name) of all customers in the customer table, 
	how many tickets they have each purchased, and the total cost of these tickets.
	Be sure to include all customers, even if they have never purchased a ticket.  Order the results by total ticket cost, in descending order.

    Hint:  This will involve using OUTER JOINs, GROUP BY, COUNT and SUM.
*/
-- Write Query 7 here
SELECT CONCAT(firstName, ' ', lastName) AS 'fullName', COUNT(ticketIDNumber) AS 'numTickets',
SUM(ticketCost) AS 'totalCost' FROM customers
LEFT OUTER JOIN tickets
ON customers.customerIDNumber = tickets.customerIDNumber
LEFT OUTER JOIN sessions
ON tickets.sessionIDNumber = sessions.sessionIDNumber GROUP BY firstName, lastName ORDER BY totalCost DESC;

/*	Query 8 – Age Appropriate Movies (4 marks)
	Write a query that selects the name, duration and description of all movies that a certain customer (chosen by you) can legally watch, 
	based on the customer’s date of birth and the minimum age required by the movie’s classification.  
	Select a customer whose date of birth makes them 15-17 years old for this query, so that the results include all movies except those classified “R”.

    Hint:  Use a subquery to select the age of your chosen customer, which will then be compared to the minimum age in the classification table (that will have been joined to the movie table).
*/
-- Write Query 8 here
SELECT name, duration, desc_details FROM movies INNER JOIN classifications
ON movies.classification = classifications.classification
WHERE minAge <= (SELECT DATEDIFF(year, DOB, GETDATE()) FROM customers WHERE customerIDNumber = 2) OR minAge IS NULL;

/*	Query 9 – Session Revenue (4 marks)
	Write a query that selects the session ID, session date/time, movie name, cinema name, tickets sold and total revenue of all sessions that occurred in the past.  
	Total revenue is the session cost multiplied by the number of tickets sold.  Ensure that sessions that had no tickets sold appear in the results (with 0 tickets sold and 0 revenue).  
	Order the results by total revenue, in descending order.
*/
-- Write Query 9 here
SELECT s.sessionIDNumber, dTime, m.name AS 'movieName', c.name AS 'cinemaName',
COUNT(m.movieIDNumber) AS 'ticketSold', s.ticketCost * COUNT(m.movieIDNumber) AS 'totalRevenue'
FROM sessions AS s INNER JOIN movies AS m
ON s.movieIDNumber = m.movieIDNumber
INNER JOIN cinemas AS c
ON s.cinemaIDNumber = c.cinemaIDNumber
INNER JOIN tickets AS t
ON s.sessionIDNumber = t.sessionIDNumber
GROUP BY s.sessionIDNumber, dTime, m.name, c.name, s.ticketCost
ORDER BY totalRevenue DESC;







