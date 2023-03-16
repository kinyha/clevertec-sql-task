--Вывести к каждому самолету класс обслуживания и количество мест этого класса
SELECT DISTINCT model           AS Модель_самолета,
                fare_conditions AS Класс_обслуживания,
                COUNT(seat_no)  AS Количество_мест
FROM aircrafts
         JOIN seats s ON aircrafts.aircraft_code = s.aircraft_code
GROUP BY model, fare_conditions
ORDER BY model;

--Найти 3 самых вместительных самолета (модель + кол-во мест)
SELECT DISTINCT model          AS Модель_самолета,
                COUNT(seat_no) AS Количество_мест

FROM aircrafts
         JOIN seats s on aircrafts.aircraft_code = s.aircraft_code
GROUP BY model
ORDER BY COUNT(seat_no) DESC LIMIT 3;

--Вывести код,модель самолета и места не эконом класса для самолета 'Аэробус A321-200' с сортировкой по местам
SELECT airport_code, airport_name, city
FROM airports
WHERE city IN (SELECT city
               FROM airports
               GROUP BY city
               HAVING COUNT(*) > 1);

-- Найти ближайший вылетающий рейс из Екатеринбурга в Москву, на который еще не завершилась регистрация
SELECT *
FROM flights
WHERE departure_airport = 'SVX'
  AND arrival_airport IN ('DME', 'SVO', 'DKO')
  AND status IN ('Delayed', 'On Time')
ORDER BY scheduled_departure LIMIT 1;

--Вывести самый дешевый и дорогой билет и стоимость ( в одном результирующем ответе)
SELECT max(amount) as max_cost,
       min(amount) as min_cost
FROM ticket_flights;


-- Написать DDL таблицы Customers , должны быть поля id , firstName, LastName, email , phone. Добавить ограничения на поля ( constraints) .
CREATE TABLE Customers
(
    Id        SERIAL PRIMARY KEY,
    firstName VARCHAR(30) NOT NULL,
    LastName  VARCHAR(30) NOT NULL,
    email     VARCHAR(30) NOT NULL,
    phone     VARCHAR(30) NOT NULL
);
-- Написать DDL таблицы Orders , должен быть id, customerId,	quantity. Должен быть внешний ключ на таблицу customers + ограничения
CREATE TABLE Orders
(
    Id         SERIAL PRIMARY KEY,
    CustomerId INTEGER REFERENCES Customers (Id),
    quantity   INT CHECK (quantity > 0)
);

-- Написать 5 insert в эти таблицы
INSERT INTO Customers
VALUES (1, 'Uladzislau', 'Bratchykau', 'kinihaha@gmail.com', '2322323');
INSERT INTO Customers
VALUES (2, 'Elon', 'Musk', 'selltwittercheap@gmail.com', '654321');
INSERT INTO Customers
VALUES (3, 'Lex', 'Fridman', 'alexa@gmail.com', '12346');
INSERT INTO Orders
VALUES (1, 2, 1);
INSERT INTO Orders
VALUES (2, 2, 3);

-- удалить таблицы
DROP TABLE Orders;
DROP TABLE Customers;

--Пассажир который потратил больше всего денег
SELECT passenger_name, contact_data, sum(b.total_amount)
FROM tickets
         JOIN bookings b ON tickets.book_ref = b.book_ref
GROUP BY passenger_name, contact_data
ORDER BY sum(b.total_amount) DESC LIMIT 1;