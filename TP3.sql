// TP3 JOINSS


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


//Listar los 10 países con mayor población y los 10 
//países con menor población (que tengan al menos 100 habitantes) en la misma consulta.


(SELECT Name, Population FROM country  WHERE Population >= 100 ORDER BY Population Limit 10)
UNION (Select Name, Population FROM country ORDER BY Population DESC LIMIT 10)

// Listar aquellos países cuyos lenguajes oficiales son el Inglés y el Francés (hint: no debería haber filas duplicadas).

(SELECT country.name 
FROM country
INNER JOIN countrylanguage on countrylanguage.CountryCode = country.Code
WHERE (countrylanguage.Language = 'English' AND countrylanguage.IsOficcial = 'T')
) 
INTERSECT
(SELECT country.name
FROM country
INNER JOIN countrylanguage on countrylanguage.CountryCode = country.Code
WHERE (countrylanguage.Language = 'French' AND countrylanguage.IsOficcial = 'T')
)
//Me da solo 3: Canada, Seychelles Vanuatu

//Listar aquellos países que tengan hablantes del Inglés pero no del Español en su población.

(SELECT country.Name
FROM country
INNER JOIN countrylanguage on countrylanguage.CountryCode = country.Code
WHERE (countrylanguage.Language = 'English')
)
EXCEPT
(
SELECT country.Name
FROM country
INNER JOIN countrylanguage ON country.Code = countrylanguage.CountryCode
WHERE (countrylanguage.Language = 'Spanish')
)
