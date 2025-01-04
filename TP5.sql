-- Cree una tabla de `directors` con las columnas: Nombre, Apellido, Número de Películas.
CREATE TABLE directors(
Nombre VARCHAR(100),
Apellido VARCHAR(100),
NumPeliculas INT);

-- El top 5 de actrices y actores de la tabla `actors` que tienen la mayor experiencia (i.e. el mayor número de películas filmadas) son también directores 
-- de las películas en las que participaron. Basados en esta información, inserten, utilizando una subquery los valores correspondientes en la tabla `directors`.

INSERT INTO directors (Nombre, Apellido, NumPeliculas)
SELECT actor.first_name, actor.last_name , count(film_id) as cant_movies 
FROM actor
INNER JOIN film_actor ON film_actor.actor_id = actor.actor_id
GROUP BY actor.actor_id
ORDER BY cant_movies DESC
LIMIT 5;

/* 3
 * Agregue una columna `premium_customer` que tendrá un valor 'T' o 'F' de acuerdo a 
 * si el cliente es "premium" o no. Por defecto ningún cliente será premium.
 * */

ALTER TABLE customer ADD premium_customer VARCHAR(1) DEFAULT 'F'

-- Modifique la tabla customer. Marque con 'T' en la columna `premium_customer` 
-- de los 10 clientes con mayor dinero gastado en la plataforma.


UPDATE customer INNER JOIN 
	(SELECT c.customer_id, SUM(payment.amount) as sum_payment FROM customer c 
	INNER JOIN payment ON payment.customer_id = c.customer_id
	GROUP BY c.customer_id
	ORDER BY sum_payment
	LIMIT 10) as top_customers
ON customer.customer_id = top_customers.customer_id
SET customer.premium_customer = 'T'

-- Listar, ordenados por cantidad de películas (de mayor a menor), los distintos ratings de las películas existentes
-- (Hint: rating se refiere en este caso a la clasificación según edad: G, PG, R, etc).

SELECT rating, COUNT(rating) as count_r
FROM film
GROUP BY rating
ORDER BY count_r DESC

-- ¿Cuáles fueron la primera y última fecha donde hubo pagos?

SELECT MAX(payment_date), MIN(payment_date)
FROM payment

-- Calcule, por cada mes, el promedio de pagos
-- (Hint: vea la manera de extraer el nombre del mes de una fecha).

SELECT AVG(amount), MONTHNAME(payment_date) as avgmonth
FROM payment
GROUP BY avgmonth

-- Listar los 10 distritos que tuvieron 
-- mayor cantidad de alquileres (con la cantidad total de alquileres).

SELECT a.district, SUM(rental_table.rental_count)
FROM address a
INNER JOIN (SELECT f.staff_id, f.address_id as dir, COUNT(r.rental_id) as rental_count
		FROM staff f
		INNER JOIN rental r ON r.staff_id = f.staff_id
		GROUP BY f.staff_id ) as rental_table
ON a.address_id = rental_table.dir
GROUP BY district
LIMIT 10;



-- Modifique la table `inventory_id` agregando una columna `stock` que sea un número entero y representa la cantidad de copias de una misma película que
-- tiene determinada tienda. El número por defecto debería ser 5 copias.
ALTER TABLE inventory 
ADD stock INTEGER Default 5


-- Cree un trigger `update_stock` que, cada vez que se agregue un nuevo registro a la tabla rental,
 -- haga un update en la tabla `inventory` restando una copia al stock de la película rentada 
 -- (Hint: revisar que el rental no tiene información directa sobre la tienda, 
-- sino sobre el cliente, que está asociado a una tienda en particular).


DELIMITER // 
CREATE TRIGGER update_stock AFTER INSERT ON rental 
FOR EACH ROW
BEGIN 
	UPDATE inventory
	SET stock = stock-1
	WHERE (inventory_id = NEW.inventory_id)
END //
	
DELIMITER;
	
CREATE TRIGGER update_stock AFTER INSERT ON rental
        FOR EACH ROW
    UPDATE inventory
        SET inventory.stock = (inventory.stock - 1)
        WHERE
            NEW.inventory_id = inventory.inventory_id;
           

-- Cree una tabla `fines` que tenga dos campos: `rental_id` y `amount`. El primero es una clave foránea 
-- a la tabla rental y el segundo es un valor numérico con dos decimales.
           
CREATE TABLE fines(
rental_id INT,
amount decimal(5,2),
Primary key(rental_id)
Foreign key (rental_id) references rental(rental_id))

-- Cree un procedimiento `check_date_and_fine` que revise la tabla `rental` y cree un registro en la tabla `fines` por cada `rental` cuya devolución (return_date) haya tardado más de 3 días (comparación con rental_date).
-- El valor de la multa será el número de días de retraso multiplicado por 1.5.



-- Crear un rol `employee` que tenga acceso de inserción, eliminación y actualización a la tabla `rental`.
create role employee;
grant insert, update, delete 
on rental
to employee

-- Revocar el acceso de eliminación a `employee` y crear un rol `administrator` que tenga todos los privilegios sobre la BD `sakila`.
revoke delete
on rental
from employee

create role administrator;
grant select, insert, update, delete
on sakila.*
to administrator

-- Crear dos roles de empleado. A uno asignarle los permisos de `employee` y al otro de `administrator`.
create role fulanito;
grant administrator TO fulanito;
create role fulanita;
grant employee TO fulanita

-- mostrar
SHOW grants FOR employee
