-- Devuelva la oficina con mayor número de empleados.

SELECT offices.officeCode, COUNT(employees.employeeNumber) as number_employees
FROM offices 
INNER JOIN employees ON employees.officeCode = offices.officeCode
GROUP BY offices.officeCode
ORDER BY number_employees DESC
LIMIT 1;

-- ¿Cuál es el promedio de órdenes hechas por oficina?, ¿Qué oficina vendió la mayor cantidad de productos?

SELECT employees.officeCode, AVG(customer_table.sum_orders)
FROM employees
INNER JOIN (SELECT c.salesRepEmployeeNumber as salesforemp, c.customerNumber as custom, SUM(orders.orderNumber) as sum_orders
	FROM customers c
	INNER JOIN orders ON orders.customerNumber = c.customerNumber
	GROUP BY c.customerNumber ) as customer_table
ON employees.employeeNumber = customer_table.salesforemp
GROUP BY employees.officeCode              

SELECT employees.officeCode, SUM(customer_table.sum_orders) as products
FROM employees
INNER JOIN (SELECT c.salesRepEmployeeNumber as salesforemp, c.customerNumber as custom, SUM(orders.orderNumber) as sum_orders
	FROM customers c
	INNER JOIN orders ON orders.customerNumber = c.customerNumber
	GROUP BY c.customerNumber ) as customer_table
ON employees.employeeNumber = customer_table.salesforemp
GROUP BY employees.officeCode
ORDER BY products DESC
LIMIT 1;

-- Devolver el valor promedio, máximo y mínimo de pagos que se hacen por mes.
SELECT AVG(payments.amount), MAX(payments.amount), MIN(payments.amount), MONTHNAME(paymentDate) as months
FROM payments
GROUP BY months
ORDER BY months

-- Crear un procedimiento "Update Credit" en donde se
-- modifique el límite de crédito de un cliente con un valor pasado por parámetro.
DROP PROCEDURE IF EXISTS update_credit;
DELIMITER //
CREATE PROCEDURE update_credit(IN valor decimal(10,2), IN customNumber INT)
	BEGIN
		ALTER TABLE customers 
			SET creditLimit = valor
			WHERE customerNumber = customNumber
	END
DELIMITER ;

-- Cree una vista "Premium Customers" que devuelva el top 10 de clientes que más dinero han gastado en la plataforma. La vista deberá devolver 
-- el nombre del cliente, la ciudad y el total gastado por ese cliente en la plataforma.

CREATE VIEW premium_customers AS 
	SELECT customers.customerName, customers.city, SUM(payments.amount) as total_gastado
	FROM customers
	INNER JOIN payments ON payments.customerNumber = customers.customerNumber
	GROUP BY customers.customerNumber
	ORDER BY total_gastado DESC
	LIMIT 10;
	
-- Cree una función "employee of the month" que tome un mes y un año y devuelve el empleado (nombre y apellido) 
-- cuyos clientes hayan efectuado la mayor cantidad de órdenes en ese mes.

CREATE FUNCTION employee_of_the_month(my_month INT, my_year INT)
	RETURNS nombre varchar(101) DETERMINISTIC 
	BEGIN
		SELECT employees.firstName, employees.lastName
		FROM employees
		INNER JOIN customers
	END

DELIMITER //
CREATE FUNCTION employee_of_the_month(mes INT, anio INT)
RETURNS varchar(255) DETERMINISTIC 
BEGIN 
	DECLARE res varchar(255);
		SELECT CONCAT(e.firstName," ", e.lastName)
		INTO res
		FROM employees e
		INNER JOIN customers c ON c.salesRepEmployeeNumber = e.employeeNumber 
		INNER JOIN orders o ON o.customerNumber = c.customerNumber
		WHERE MONTH(o.orderDate) = mes AND year(o.orderDate) = anio
		GROUP BY e.employeeNumber
		ORDER BY count(o.orderNumber) DESC 
		LIMIT 1;
	RETURN res;
END;//
DELIMITER ;

-- Crear una nueva tabla "Product Refillment".Deberá tener una relación varios a uno con "products" y los campos: `refillmentID`,
-- `productCode`, `orderDate`, `quantity`.

DROP TABLE ProductRefillment;
CREATE TABLE ProductRefillment(
refillmentID varchar(100) PRIMARY KEY NOT NULL,
productCode varchar(15) NOT NULL,
orderDate date NOT NULL,
quantity int NOT NULL,
Foreign key (productCode) references products(productCode));

-- Definir un trigger "Restock Product" que esté pendiente de los cambios efectuados en `orderdetails` y 
-- cada vez que se agregue una nueva orden revise la cantidad de productos pedidos (`quantityOrdered`) y 
-- compare con la cantidad en stock (`quantityInStock`) y si es menor a 10 genere un pedido en la tabla
--  "Product Refillment" por 10 nuevos productos.

DELIMITER // 
CREATE TRIGGER restock_product AFTER INSERT ON orderdetails
FOR EACH ROW 
	WHEN products.quantityInStock - new.quantityOrdered < 10
	BEGIN 
		UPDATE ProductRefillment 
		SET quantity =+ 10
		WHERE new.productCode = productCode 
	END
DELIMITER;
	