---- step 1 : creating tables------
-- Create the 'Web' table to store website information
CREATE TABLE Web (
    id_site INT PRIMARY KEY, 
    nom_site VARCHAR(255), 
    url_site VARCHAR(255) 
);

-- Create the 'Localisation' table to store location information
CREATE TABLE Localisation (
    id_location INT PRIMARY KEY, 
    city VARCHAR(255), 
    district VARCHAR(255) NULL 
);

-- Create the 'House' table to store house information
CREATE TABLE House (
    id_house INT PRIMARY KEY, 
    price DECIMAL(10, 2),
    number_of_rooms INT NULL,
    area INT, 
	id_site INT, 
    id_location INT, 
    FOREIGN KEY (id_site) REFERENCES Web(id_site), 
    FOREIGN KEY (id_location) REFERENCES Localisation(id_location) 
);

----- Step 2 : Data Cleaning-----
-- Delete rows from 'House' where 'id_location' matches an 'id_location' in 'Localisation' with NULL city and district
DELETE FROM House
WHERE id_location IN (
    SELECT id_location
    FROM Localisation
    WHERE city IS NULL AND district IS NULL
);

-- Delete rows from 'Localisation' where both city and district are NULL
DELETE FROM Localisation
WHERE city IS NULL AND district IS NULL;

--------- Number of rooms --------
-- Create a Common Table Expression (CTE) to find the most common number of rooms
WITH RoomMode AS (
    SELECT TOP 1 number_of_rooms
    FROM House
    WHERE number_of_rooms IS NOT NULL
    GROUP BY number_of_rooms
    ORDER BY COUNT(*) DESC 
)
-- Update 'House' to set 'number_of_rooms' to the most common value where it is currently NULL
UPDATE House
SET number_of_rooms = (SELECT price FROM RoomMode)
WHERE number_of_rooms IS NULL;

------------ district --------
-- Update 'Localisation' to set 'district' to 'Inconnu' where it is currently NULL
UPDATE Localisation
SET district = 'Inconnu'
WHERE district IS NULL;

-- Create a stored procedure to update house prices
CREATE PROCEDURE UpdateHousePrices
AS
BEGIN
    DECLARE @house_id INT; 
    DECLARE @city_name VARCHAR(255); 
    DECLARE @avg_price DECIMAL(10, 2); 

    DECLARE cur CURSOR LOCAL FOR
        SELECT h.id_house, l.city
        FROM House h
        JOIN Localisation l ON h.id_location = l.id_location
        WHERE h.price = 0;

    OPEN cur;

    FETCH NEXT FROM cur INTO @house_id, @city_name;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT @avg_price = AVG(h2.price)
        FROM House h2
        JOIN Localisation l2 ON h2.id_location = l2.id_location
        WHERE l2.city = @city_name AND h2.price > 0;

        UPDATE House
        SET price = @avg_price
        WHERE id_house = @house_id;

        FETCH NEXT FROM cur INTO @house_id, @city_name;
    END

    CLOSE cur;
    DEALLOCATE cur;
END;

EXEC UpdateHousePrices;



