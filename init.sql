-- 1. Створення таблиць вимірів та фактів
CREATE TABLE products (id SERIAL PRIMARY KEY, product_name VARCHAR(100), category VARCHAR(50));
CREATE TABLE regions (id SERIAL PRIMARY KEY, region_name VARCHAR(50), country VARCHAR(50));
CREATE TABLE customers (id SERIAL PRIMARY KEY, customer_name VARCHAR(100), segment VARCHAR(50));

CREATE TABLE sales (
    id SERIAL PRIMARY KEY, 
    sale_date DATE, 
    product_id INT REFERENCES products(id), 
    region_id INT REFERENCES regions(id), 
    customer_id INT REFERENCES customers(id), 
    quantity INT, 
    revenue NUMERIC(10,2)
);

-- 2. Наповнення бази тестовими даними
INSERT INTO products (product_name, category) VALUES ('Laptop', 'Electronics'), ('Phone', 'Electronics'), ('Desk', 'Furniture'), ('Monitor', 'Electronics');
INSERT INTO regions (region_name, country) VALUES ('Kyiv', 'Ukraine'), ('Lviv', 'Ukraine'), ('Odesa', 'Ukraine');
INSERT INTO customers (customer_name, segment) VALUES ('Dasha', 'Student');

INSERT INTO sales (sale_date, product_id, region_id, customer_id, quantity, revenue)
SELECT 
    current_date - (random() * 365)::int, 
    (random() * 3 + 1)::int, 
    (random() * 2 + 1)::int, 
    1, 
    (random() * 10 + 1)::int, 
    (random() * 1000 + 500)::numeric(10,2) 
FROM generate_series(1, 50);

-- 3. Створення представлення (VIEW) для експорту в Excel
CREATE OR REPLACE VIEW orders_summary AS
SELECT 
    s.sale_date, 
    EXTRACT(YEAR FROM s.sale_date) AS sale_year, 
    EXTRACT(MONTH FROM s.sale_date) AS sale_month, 
    p.product_name, 
    p.category, 
    r.region_name, 
    s.quantity, 
    s.revenue
FROM sales s 
JOIN products p ON s.product_id = p.id 
JOIN regions r ON s.region_id = r.id;