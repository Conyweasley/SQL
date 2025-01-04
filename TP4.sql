-- Listar el nombre de la ciudad y el nombre del país de todas las ciudades que pertenezcan a países con una población menor a 10000 habitantes.

SELECT city.name, country.Name
FROM city
INNER JOIN country ON city.countrycode = country.Code
WHERE country.Population < 10000

-- Listar todas aquellas ciudades cuya población sea mayor que la población promedio entre todas las ciudades.

SELECT name
FROM city
WHERE population > (SELECT AVG(population) FROM city) 

-- Listar todas aquellas ciudades no asiáticas cuya población sea igual o mayor a la población total de algún país de Asia.

SELECT city.name FROM city
INNER JOIN country ON city.countrycode = country.Code
WHERE country.Continent not in ('Asia') AND city.population >= SOME (select country.population FROM country WHERE country.Continent = 'Asia') 

-- Listar aquellos países junto a sus idiomas no oficiales, que superen en porcentaje de hablantes a cada uno de los idiomas oficiales del país.

SELECT c.Name , countrylanguage.Language, countrylanguage.Percentage 
FROM country c
INNER JOIN countrylanguage ON countrylanguage.CountryCode = c.Code 
WHERE countrylanguage.IsOficcial = 'F' AND countrylanguage.Percentage > 
ALL (SELECT countrylanguage.Percentage FROM countrylanguage cl WHERE cl.CountryCode = c.Code AND cl.IsOficcial = 'T')

-- Listar (sin duplicados) aquellas regiones que tengan países con una superficie menor a 1000 km2 y exista (en el país) al menos una ciudad con más de 100000 habitantes. 
-- (Hint: Esto puede resolverse con o sin una subquery, intenten encontrar ambas respuestas).

SELECT DISTINCT c.Region 
FROM country c
INNER JOIN city on city.countrycode = c.Code 
WHERE (c.SurfaceArea < 1000) AND 100000 < SOME (SELECT city.population FROM city WHERE city.countrycode = c.Code) -- 3

-- otro
SELECT DISTINCT c.Region 
FROM country c
INNER JOIN city on city.countrycode = c.Code 
WHERE (c.SurfaceArea < 1000) AND city.population > 100000

-- Listar el nombre de cada país con la cantidad de habitantes de su ciudad más poblada. 
-- (Hint: Hay dos maneras de llegar al mismo resultado. Usando consultas escalares o usando agrupaciones, encontrar ambas).

SELECT DISTINCT c.Name, city.name, city.population 
FROM country c
INNER JOIN city ON city.countrycode = c.Code 
WHERE city.population = (SELECT MAX(ci.population)FROM city ci WHERE ci.countrycode = c.Code)

-- otra
SELECT country.Name, MAX(city.Population)
FROM country
INNER JOIN  city ON city.CountryCode = country.Code
GROUP BY 
	city.CountryCode;

-- Listar aquellos países y sus lenguajes no oficiales cuyo porcentaje de hablantes sea mayor al promedio de hablantes de los lenguajes oficiales.
SELECT c.Name, countrylanguage.Language, countrylanguage.Percentage
FROM country c
INNER JOIN countrylanguage ON countrylanguage.CountryCode = c.Code 
WHERE (countrylanguage.IsOficcial = 'F') 
AND countrylanguage.Percentage > 
(SELECT AVG(cl.Percentage) FROM countrylanguage cl WHERE cl.IsOficcial = 'T' AND c.Code = cl.CountryCode)

-- Listar la cantidad de habitantes por continente ordenado en forma descendente.

SELECT SUM(country.Population) as sum_population, Continent.Name
FROM country
INNER JOIN Continent ON country.Continent = Continent.Name
GROUP BY Continent.Name
ORDER BY sum_population DESC

-- Listar el promedio de esperanza de vida (LifeExpectancy) por continente con una esperanza de vida entre 40 y 70 años.
SELECT AVG(country.LifeExpectancy) as avgLE, country.Continent 
FROM country
GROUP BY Continent
HAVING avgLE BETWEEN 40 AND 70

-- Listar la cantidad máxima, mínima, promedio y suma de habitantes por continente.

SELECT country.Continent , MAX(country.Population) as max, MIN(country.Population) as min, AVG(country.Population) as avg, SUM(country.Population) as sum
FROM country
GROUP BY Continent

-- Si en la consulta 6 se quisiera devolver, además de las columnas ya solicitadas, el nombre de la ciudad más poblada. 
-- ¿Podría lograrse con agrupaciones? ¿y con una subquery escalar?

-- Listar el nombre de cada país con la cantidad de habitantes de su ciudad más poblada. 
-- (Hint: Hay dos maneras de llegar al mismo resultado. Usando consultas escalares o usando agrupaciones, encontrar ambas).

SELECT DISTINCT c.Name, city.name, city.population 
FROM country c
INNER JOIN city ON city.countrycode = c.Code 
WHERE city.population = (SELECT MAX(ci.population)FROM city ci WHERE ci.countrycode = c.Code)


