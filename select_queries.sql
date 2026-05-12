-- Створення користувачів
CREATE ROLE logistics_admin WITH LOGIN PASSWORD 'admin_pass' SUPERUSER;
CREATE ROLE logistics_moderator WITH LOGIN PASSWORD 'mod_pass';
CREATE ROLE logistics_user WITH LOGIN PASSWORD 'user_pass';

-- Надання базових прав
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO logistics_admin;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO logistics_moderator;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO logistics_user;

CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100)
);

CREATE TABLE drivers (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    license_category VARCHAR(10),
    experience_years INT
);

CREATE TABLE vehicles (
    id SERIAL PRIMARY KEY,
    make VARCHAR(50),
    model VARCHAR(50),
    license_plate VARCHAR(20) UNIQUE,
    capacity_kg INT
);

CREATE TABLE cargo_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE deliveries (
    id SERIAL PRIMARY KEY,
    client_id INT REFERENCES clients(id),
    driver_id INT REFERENCES drivers(id),
    vehicle_id INT REFERENCES vehicles(id),
    cargo_type_id INT REFERENCES cargo_types(id),
    weight_kg NUMERIC(10, 2),
    destination_city VARCHAR(100),
    order_date DATE,
    expected_date DATE,
    delivery_date DATE,
    delivery_cost NUMERIC(10, 2),
    status VARCHAR(20)
);

INSERT INTO clients (full_name, phone, email) VALUES 
('Іваненко Іван', '+380501234567', 'ivan@mail.com'),
('Петренко Петро', '+380671234567', 'petro@mail.com');

INSERT INTO drivers (full_name, license_category, experience_years) VALUES 
('Сидоренко Сергій', 'CE', 5),
('Коваленко Микола', 'C', 3);

INSERT INTO vehicles (make, model, license_plate, capacity_kg) VALUES 
('Mercedes-Benz', 'Sprinter', 'AA1111BB', 3000),
('Volvo', 'FH16', 'BC2222CX', 20000);

INSERT INTO cargo_types (name, description) VALUES 
('Будівельні матеріали', 'Цегла, цемент, дошки'),
('Електроніка', 'Крихкий вантаж, побутова техніка');

INSERT INTO deliveries (client_id, driver_id, vehicle_id, cargo_type_id, weight_kg, destination_city, order_date, expected_date, delivery_date, delivery_cost, status) VALUES 
(1, 1, 1, 2, 500.00, 'Київ', '2023-09-01', '2023-09-03', '2023-09-03', 1500.00, 'delivered'),
(2, 2, 2, 1, 15000.00, 'Львів', '2023-09-10', '2023-09-12', '2023-09-15', 8500.00, 'delivered'), -- доставлено з порушенням термінів
(1, 1, 2, 1, 12000.00, 'Одеса', '2023-10-01', '2023-10-05', NULL, 6000.00, 'in_transit');

-- 1. Які вантажі доставлені за останній місяць? (Припустимо, поточний місяць жовтень 2023)
SELECT * FROM deliveries 
WHERE status = 'delivered' AND delivery_date >= '2023-09-01';

-- 2. Скільки вантажів було доставлено вчасно?
SELECT COUNT(*) AS on_time_deliveries 
FROM deliveries 
WHERE status = 'delivered' AND delivery_date <= expected_date;

-- 3. Які машини використовуються для доставки? (JOIN)
SELECT DISTINCT v.make, v.model, v.license_plate 
FROM vehicles v 
JOIN deliveries d ON v.id = d.vehicle_id;

-- 4. Яка середня вартість доставки для кожного типу вантажу? (GROUP BY + JOIN)
SELECT ct.name AS cargo_type, AVG(d.delivery_cost) AS avg_cost 
FROM deliveries d 
JOIN cargo_types ct ON d.cargo_type_id = ct.id 
GROUP BY ct.name;

-- 5. Яка кількість доставлених вантажів перевищує певний ваговий поріг (наприклад, 1000 кг)?
SELECT COUNT(*) AS heavy_deliveries 
FROM deliveries 
WHERE weight_kg > 1000 AND status = 'delivered';

-- 6. Скільки водіїв працює в компанії?
SELECT COUNT(*) AS total_drivers FROM drivers;

-- 7. Яка кількість вантажів була доставлена в межах міста (наприклад, Київ)?
SELECT COUNT(*) AS city_deliveries 
FROM deliveries 
WHERE destination_city = 'Київ' AND status = 'delivered';

-- 8. Які записи містять інформацію про доставку з порушенням термінів?
SELECT id, client_id, expected_date, delivery_date 
FROM deliveries 
WHERE delivery_date > expected_date;

-- 9. Скільки клієнтів зробили замовлення на доставку за певний період (вересень)?
SELECT COUNT(DISTINCT client_id) AS active_clients 
FROM deliveries 
WHERE order_date BETWEEN '2023-09-01' AND '2023-09-30';

-- 10. Яка загальна сума витрат (доходів компанії) на доставку вантажів? (Маємо на увазі вартість доставки)
SELECT SUM(delivery_cost) AS total_revenue FROM deliveries;