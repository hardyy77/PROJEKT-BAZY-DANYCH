--1
--Wyświetl wszystkie ciężarówki.
SELECT * FROM trucks;  

--Wyświetl ciężarówki marki Mercedes-benz.
SELECT * FROM trucks
	WHERE marka ="Mercede-Benz";   

--Wyświetl wszystkie ciężarówki w kolejności od najmniejszego przebiegu.
SELECT * FROM trucks
	ORDER BY Przebieg;  

--Wyświetl 10 ciężarówek z najmniejszym spalaniem.
SELECT * FROM trucks
	ORDER BY Spalanie ASC
	LIMIT 10;

--2
--Wyświetl wszystkich klientów, którym kotrakt kończy się w całym okresie trwania 2023 roku.
SELECT *
    FROM customers
    INNER JOIN contracts 
    ON customers.customer_id = contracts.customer_id
    WHERE contracts.Okres_do 
    BETWEEN '2023-01-01' AND '2023-12-31';
	
--Wyświetl wszystkich pracowników, którzy są zatrudnieni jako pracownicy magazynu.
SELECT employees.*
    FROM employees
    INNER JOIN job_positions
    ON employees.job_position_id = job_positions.Job_position_ID
    WHERE job_positions.nazwa = 'pracownik magazynu';
	
	
--Wyświetl opis incydentu oraz id trasy dla zamówienia o id 10.
SELECT incidents.Opis, track_details.track_id 
    FROM incidents 
    INNER JOIN track_details 
    ON incidents.track_id = track_details.track_id 
    INNER JOIN orders 
    ON incidents.order_id = orders.Order_ID 
    WHERE orders.Order_ID = 10;
	
--3
--Wyświetl nazwisko kierowcy i model ciężarówki, którzy brał udział w zamówieniu o id 20.
 SELECT drivers.Nazwisko, trucks.model
    FROM orders
    LEFT JOIN drivers
    ON orders.driver_id = drivers.Driver_ID
    LEFT JOIN trucks
    ON orders.truck_id = trucks.Truck_ID
    WHERE orders.Order_ID = 20;
	
--Wyświetl przewidywaną pogodę, stan asfaltu, punkt startowy, imie i numer telefonu kierowcy dla zamówienia o id 50. 
SELECT track_details.Przewidywana_pogoda,
        track_details.sredni_stan_asfaltu, 
        track_details.Punkt_startowy,
        drivers.Imie, drivers.Nr_tel
    FROM orders
    LEFT JOIN track_details
    ON orders.track_id = track_details.track_id
    LEFT JOIN drivers
    ON orders.driver_id = drivers.Driver_ID
    WHERE orders.Order_ID = 50;
	
--Wyświetl wszystkie ciężarówki, które były w serwisie przed rokiem 2015 sortując je od najstarszej daty.
SELECT trucks.model, trucksinservice.data_wydania 
    FROM trucks 
    LEFT JOIN trucksinservice 
    ON trucks.Truck_ID = trucksinservice.truck_id 
    WHERE trucksinservice.data_wydania < '2015-01-01' 
    ORDER BY trucksinservice.data_wydania ASC;
	
--4
--Wyświetl tylko te zamówienia które mają status "w drodze".
SELECT orders.*, 
        ( SELECT delivery_status.Status 
        FROM delivery_status 
        WHERE delivery_status.Status_ID = orders.Delivery_status_ID 
        AND delivery_status.Status = 'w drodze' ) AS delivery_status 
    FROM orders 
    WHERE Delivery_status_ID IS NOT NULL;
	
--Wyświetł na których regałach znajdują się dane materiały.
SELECT types_of_package.*, 
        (SELECT GROUP_CONCAT(warehouse.Regal SEPARATOR ',')
        FROM warehouse
        WHERE warehouse.package_id = types_of_package.Package_ID) 
        AS regaly_o_numerze
    FROM types_of_package
	
--Wyświetl łączną liczbę oraz kwotę faktur z 2018 roku i nazwę klienta.
SELECT customers.Nazwa AS 'Nazwa firmy', 
        (SELECT COUNT(invoice_id) 
        FROM invoices 
        WHERE invoices.customer_id = customers.Customer_ID 
        AND invoices.Data 
        BETWEEN '2018-01-01' AND '2018-12-31') AS 'Liczba faktur', 
        (SELECT SUM(kwota) 
        FROM invoices 
        WHERE invoices.customer_id = customers.Customer_ID 
        AND invoices.data 
        BETWEEN '2018-01-01' AND '2018-12-31') AS 'Suma kwot faktur' 
    FROM customers;
	
--5
--Wyświetl typ naczep plandeka i zamówienia w których ona występowała.
SELECT t.typ, o.Order_ID 
    FROM orders AS o 
    INNER JOIN (SELECT trailer_id, typ 
        FROM trailers WHERE typ = 'plandeka') AS t 
    ON o.trailer_id = t.trailer_id;
	
--Wyświetl wszystkich klientówm, którzy mieli conajmniej 1 zamówienie w przeciągu roku.
SELECT c.nazwa
    FROM (SELECT o.customer_id FROM orders AS o 
        WHERE o.Data_realizacji 
        BETWEEN CURRENT_DATE - INTERVAL 1 YEAR AND CURRENT_DATE 
        GROUP BY o.customer_id) AS podzapytanie
    INNER JOIN customers AS c 
    ON c.Customer_ID = podzapytanie.customer_id;
	
--Wyświetl ciężarówkę i naczepę, które zostały użyte podczas co najmniej jednego zamówienia.
SELECT o.order_ID, t.Typ AS typ_naczepy,
        tr.model, tr.Marka AS marka
    FROM (SELECT trailer_id, truck_id, order_id 
        FROM orders) AS o
    INNER JOIN trailers AS t 
    ON t.Trailer_ID = o.trailer_id
    INNER JOIN trucks AS tr 
    ON tr.Truck_ID = o.truck_id;
	
--6
--Wyświetl zamówienia, w których występuje ciężarówka marki volvo lub podczas którego była deszczowa pogoda.
SELECT * 
    FROM orders AS o 
    WHERE o.truck_id IN (SELECT truck_id 
        FROM trucks 
        WHERE model = 'volvo') 
        OR EXISTS (SELECT * 
        FROM track_details 
        WHERE track_id = o.track_id 
        AND przewidywana_pogoda = 'deszczowa');
		
--Wyświetl kierowców którzy nie mieli żadnego zlecenia od 2020 do 2022 roku.
SELECT drivers.*
    FROM drivers
    WHERE NOT EXISTS (
        SELECT 1 FROM orders
        WHERE orders.driver_id = drivers.Driver_ID
        AND YEAR(orders.Data_realizacji) >= 2020 
        AND YEAR(orders.Data_realizacji) <= 2022)
		
--Wyświetl wszystkie zakończone zlecenia i ich id, które mają rodzaj ładunku "towary sypkie" i wyświetl nazwę naczepy, w której był przewożony ładunek.

SELECT orders.Order_ID, orders.Delivery_status_ID,
        trailers.Typ
    FROM orders
    JOIN trailers ON orders.trailer_id = trailers.Trailer_ID
    JOIN types_of_cargo 
    ON orders.Cargo_ID = types_of_cargo.Cargo_ID
    WHERE (SELECT delivery_status.Status 
        FROM delivery_status 
        WHERE delivery_status.Status_ID 
        = orders.delivery_status_id) = 'w drodze' 
    AND types_of_cargo.Typ = 'towary sypkie'
    GROUP BY orders.trailer_id
    HAVING COUNT(DISTINCT orders.Order_ID) > 0