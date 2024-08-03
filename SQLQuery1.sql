---- step 1 : creating tables------
CREATE TABLE Web (
    id_site INT PRIMARY KEY,
    nom_site VARCHAR(255),
    url_site VARCHAR(255)
);

CREATE TABLE Localisation (
    id_location INT PRIMARY KEY,
    city VARCHAR(255),
    district VARCHAR(255) NULL
);

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
-- Supprimer les lignes dans House où id_location correspond à un id_location dans Localisation où city et district sont NULL
DELETE FROM House
WHERE id_location IN (
    SELECT id_location
    FROM Localisation
    WHERE city IS NULL AND district IS NULL
);

-- Supprimer les lignes dans Localisation où city et district sont NULL
DELETE FROM Localisation
WHERE city IS NULL AND district IS NULL;
--------- Number of rooms --------
WITH RoomMode AS (
    SELECT TOP 1 number_of_rooms
    FROM House
    WHERE number_of_rooms IS NOT NULL
    GROUP BY number_of_rooms
    ORDER BY COUNT(*) DESC
)
UPDATE House
SET number_of_rooms = (SELECT price FROM RoomMode)
WHERE number_of_rooms IS NULL;

------------ district --------
UPDATE Localisation
SET district = 'Inconnu'
WHERE district IS NULL;
SELECT * FROM Localisation;