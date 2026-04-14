-------------------------------------------------------------------------
-- ЛАБОРАТОРНА РОБОТА №1: Бази даних та інформаційні системи 
-- Тема: Ознайомлення з PostgreSQL 
-- Варіант: 23 (Агентство нерухомості) 
-- Студентка групи МІТ-31: Дар'я Г.
-------------------------------------------------------------------------

-- КРОК 1: СТВОРЕННЯ БАЗИ ДАНИХ
-- Створюємо окрему базу даних для проекту[cite: 12].
-- Примітка: Виконайте цей запит першим, після чого підключіться до бази real_estate_gds.
-- CREATE DATABASE real_estate_gds; 

-------------------------------------------------------------------------
-- КРОК 2: ВИЗНАЧЕННЯ СХЕМИ ДАНИХ (Створення таблиць) -- Створюємо три пов'язані таблиці з первинними та зовнішніми ключами.
-------------------------------------------------------------------------

-- 1. Таблиця Клієнти (clients): зберігає персональні дані потенційних покупців/орендарів.
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE
);

-- 2. Таблиця Об'єкти нерухомості (properties): зберігає дані про об'єкти (квартири, офіси тощо).
CREATE TABLE properties (
    property_id SERIAL PRIMARY KEY,
    address VARCHAR(255) NOT NULL,
    property_type VARCHAR(50) NOT NULL, -- Наприклад: Apartment, House, Office
    price DECIMAL(12, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Available' -- Статус: Available (Доступно), Sold (Продано)
);

-- 3. Таблиця Угоди (deals): фіксує операції, пов'язуючи клієнтів із об'єктами.
CREATE TABLE deals (
    deal_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    property_id INT NOT NULL,
    deal_date DATE DEFAULT CURRENT_DATE,
    deal_amount DECIMAL(12, 2) NOT NULL,
    deal_type VARCHAR(50) NOT NULL, -- Тип угоди: Purchase (Купівля), Rent (Оренда)
    CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE CASCADE,
    CONSTRAINT fk_property FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE
);

-------------------------------------------------------------------------
-- КРОК 3: МАНІПУЛЯЦІЯ ДАНИМИ (Операції CRUD)
-------------------------------------------------------------------------

-- 1. INSERT: Додавання тестових даних у таблиці.
INSERT INTO clients (full_name, phone_number, email) VALUES
('Ivanenko Ivan', '+380501234567', 'ivanenko@example.com'),
('Petrenko Maria', '+380671234567', 'petrenko@example.com');

INSERT INTO properties (address, property_type, price, status) VALUES
('1 Khreshchatyk St, Kyiv', 'Apartment', 150000.00, 'Available'),
('15 Vasylkivska St, Kyiv', 'Office', 85000.00, 'Available');

-- Реєстрація угоди: Клієнт №1 купує Об'єкт №2.
INSERT INTO deals (client_id, property_id, deal_amount, deal_type) VALUES
(1, 2, 85000.00, 'Purchase');

-- 2. UPDATE: Зміна статусу об'єкта нерухомості після успішної угоди.
UPDATE properties 
SET status = 'Sold' 
WHERE property_id = 2;

-- 3. SELECT: Перегляд усіх угод з іменами клієнтів та адресами об'єктів (через JOIN).
SELECT 
    d.deal_id, 
    c.full_name AS client_name, 
    p.address AS property_address, 
    d.deal_amount, 
    d.deal_date
FROM deals d
JOIN clients c ON d.client_id = c.client_id
JOIN properties p ON d.property_id = p.property_id;

-- 4. DELETE: Видалення клієнта (каскадне видалення обробить пов'язані угоди).
DELETE FROM clients 
WHERE client_id = 2;

