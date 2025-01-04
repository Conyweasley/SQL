CREATE TABLE IF NOT EXISTS city(
ID int PRIMARY KEY,
Name varchar(100),
CountryCode varchar(100),
District varchar(100),
Population int,
Foreign key (CountryCode) references country(Code));

CREATE TABLE IF NOT EXISTS country(
Code varchar(100) PRIMARY KEY,
Name varchar(100),
Continent varchar(100),
Region varchar(100),
SurfaceArea float,
IndepYear int,
Population int,
LifeExpectancy int,
GNP float,
GNPOld float,
LocalName varchar(100),
GovernmentForm varchar(100),
HeadOfState varchar(100),
Capital int,
Code2 varchar(100)
);

CREATE TABLE countrylanguage(
CountryCode varchar(100),
Language varchar(100),
IsOficcial varchar(100),
Percentage float,
primary key (CountryCode, Language),
Foreign key (CountryCode) references country(Code));

CREATE TABLE Continent(
Name varchar(100) PRIMARY KEY,
Area int,
PercentTotalMass float,
MostPopulousCity varchar(100)
);

//ALTER TABLE countrylanguage MODIFY COLUMN Percentage float;

INSERT INTO Continent VALUES('Antarctica', 14000000, 9.2, 'McMurdo Station'),('Asia', 44579000, 29.5, 'Mumbai, India');

INSERT INTO Continent VALUES
('Europe', 10180000, 6.8, 'Instanbul, Turquia'),
('North America', 24709000, 16.5, 'Ciudad de México, Mexico'),
('Oceania', 8600000, 5.9, 'Sydney, Australia'),
('South America', 17840000, 12.0, 'São Paulo, Brazil');

SELECT * FROM Continent;

	SELECT * FROM countrylanguage c ;
DELETE FROM country ;


ALTER TABLE country MODIFY COLUMN LifeExpectancy float;

ALTER TABLE country ADD CONSTRAINT fk_continent
FOREIGN KEY (Continent) references Continent(Name);

ALTER TABLE city ADD CONSTRAINT fk_city
FOREIGN KEY (CountryCode) references country(Code);

SELECT Name, Region FROM country ORDER BY Name;

SELECT Name, Population FROM country
ORDER BY Population DESC
LIMIT 10;


SELECT * FROM country;

SELECT Name FROM country c 
WHERE IndepYear IS NULL;


SELECT Language, Percentage FROM countrylanguage c 
WHERE IsOficcial = 'T';

//Lista el nombre de la ciudad, nombre del país, región y forma de gobierno de las 
//10 ciudades más pobladas del mundo.
SELECT city.Name, country.Name, country.Region, country.GovernmentForm
FROM city 
INNER JOIN country on city.countrycode = country.Code
ORDER BY Population DESC
Limit 10;


//Listar los 10 países con menor población del mundo, junto a sus ciudades capitales 
//(Hint: puede que uno de estos países no tenga ciudad capital asignada, en este caso deberá mostrar "NULL").

SELECT country.Name, city.name, country.Capital
from country
LEFT JOIN city on city.id = country.capital
ORDER BY Population
Limit 10;

//Listar el nombre, continente y todos los lenguajes oficiales de cada país. 
//(Hint: habrá más de una fila por país si tiene varios idiomas oficiales).

SELECT country.Name, country.Continent, countrylanguage.Language
from country
INNER JOIN countrylanguage on countrylanguage.CountryCode = country.Code;

//Listar el nombre del país y nombre de capital, de los 20 países con mayor superficie del mundo.

SELECT country.Name, city.name
FROM country
INNER JOIN city on city.id = country.capital
ORDER BY SurfaceArea DESC
Limit 20;

//Listar las ciudades junto a sus idiomas oficiales (ordenado por la población de la ciudad) 
//y el porcentaje de hablantes del idioma.

SELECT city.name, countrylanguage.Language, countrylanguage.Percentage
FROM city
INNER JOIN countrylanguage on city.countrycode = countrylanguage.CountryCode
ORDER BY city.population;
//acá habria que ordenarlo adentro?

