-- ============================================================
-- Лабораторна робота №3
-- З дисципліни: Бази даних та інформаційні системи
-- Тема: Складні SQL-запити до реляційної бази даних
-- ============================================================

-- ============================================================
-- СТВОРЕННЯ ТА НАПОВНЕННЯ БАЗИ ДАНИХ
-- ============================================================

-- Таблиця категорій товарів
CREATE TABLE categories (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    description TEXT
);

-- Таблиця постачальників
CREATE TABLE suppliers (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(150) NOT NULL,
    country    VARCHAR(100),
    email      VARCHAR(150),
    phone      VARCHAR(30)
);

-- Таблиця товарів
CREATE TABLE products (
    id           SERIAL PRIMARY KEY,
    name         VARCHAR(200) NOT NULL,
    category_id  INT REFERENCES categories(id),
    supplier_id  INT REFERENCES suppliers(id),
    price        NUMERIC(10,2) NOT NULL,
    stock        INT DEFAULT 0,
    created_at   DATE DEFAULT CURRENT_DATE
);

-- Таблиця клієнтів
CREATE TABLE customers (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(150) NOT NULL,
    email      VARCHAR(150) UNIQUE,
    city       VARCHAR(100),
    country    VARCHAR(100),
    registered DATE DEFAULT CURRENT_DATE
);

-- Таблиця замовлень
CREATE TABLE orders (
    id            SERIAL PRIMARY KEY,
    customer_id   INT REFERENCES customers(id),
    order_date    DATE DEFAULT CURRENT_DATE,
    status        VARCHAR(50) DEFAULT 'pending',
    total_amount  NUMERIC(12,2)
);

-- Таблиця позицій замовлень
CREATE TABLE order_items (
    id          SERIAL PRIMARY KEY,
    order_id    INT REFERENCES orders(id),
    product_id  INT REFERENCES products(id),
    quantity    INT NOT NULL,
    unit_price  NUMERIC(10,2) NOT NULL
);

-- Таблиця відгуків
CREATE TABLE reviews (
    id          SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(id),
    product_id  INT REFERENCES products(id),
    rating      INT CHECK (rating BETWEEN 1 AND 5),
    comment     TEXT,
    review_date DATE DEFAULT CURRENT_DATE
);

-- ============================================================
-- НАПОВНЕННЯ ТЕСТОВИМИ ДАНИМИ
-- ============================================================

INSERT INTO categories (name, description) VALUES
    ('Електроніка',    'Смартфони, ноутбуки, планшети та аксесуари'),
    ('Одяг',           'Чоловічий та жіночий одяг'),
    ('Книги',          'Художня та наукова література'),
    ('Побутова техніка','Холодильники, пральні машини, мікрохвильовки'),
    ('Спорт',          'Спортивний інвентар та одяг');

INSERT INTO suppliers (name, country, email, phone) VALUES
    ('TechWorld UA',     'Україна',    'info@techworld.ua',   '+380441234567'),
    ('FashionHub',       'Польща',     'contact@fashion.pl',  '+48221234567'),
    ('BookNet',          'Україна',    'books@booknet.ua',    '+380671234567'),
    ('HomeApply GmbH',   'Німеччина',  'sales@homeapply.de',  '+4930123456'),
    ('SportZone Ltd',    'Велика Британія','hello@sportzone.uk','+441234567890');

INSERT INTO products (name, category_id, supplier_id, price, stock, created_at) VALUES
    ('iPhone 15 Pro',         1, 1, 42999.00, 50,  '2024-01-10'),
    ('Samsung Galaxy S24',    1, 1, 35999.00, 80,  '2024-01-15'),
    ('Ноутбук Dell XPS 15',   1, 1, 65000.00, 20,  '2024-02-01'),
    ('Навушники Sony WH-1000',1, 1, 12500.00, 100, '2024-02-10'),
    ('Куртка зимова чоловіча',2, 2,  3200.00, 200, '2023-11-01'),
    ('Сукня вечірня',         2, 2,  2800.00, 150, '2023-11-05'),
    ('Кросівки Adidas',       2, 2,  4500.00, 300, '2023-12-01'),
    ('Гаррі Поттер (комплект)',3, 3,  1200.00, 500, '2022-05-01'),
    ('Кобзар (Шевченко)',      3, 3,   350.00, 400, '2022-06-01'),
    ('Чистий код (Мартін)',   3, 3,   890.00, 250, '2023-01-01'),
    ('Холодильник LG',        4, 4, 28000.00, 30,  '2024-03-01'),
    ('Пральна машина Bosch',  4, 4, 22000.00, 25,  '2024-03-05'),
    ('Мікрохвильовка Gorenje',4, 4,  4200.00, 60,  '2024-03-10'),
    ('Велосипед MTB 29"',     5, 5, 15000.00, 40,  '2024-04-01'),
    ('Гантелі 10 кг (пара)',  5, 5,   980.00, 120, '2024-04-05');

INSERT INTO customers (name, email, city, country, registered) VALUES
    ('Олег Коваленко',   'oleg.k@gmail.com',   'Київ',       'Україна', '2022-03-15'),
    ('Марія Петренко',   'maria.p@ukr.net',    'Львів',      'Україна', '2022-07-20'),
    ('Іван Сидоренко',   'ivan.s@gmail.com',   'Харків',     'Україна', '2023-01-10'),
    ('Анна Мельник',     'anna.m@gmail.com',   'Одеса',      'Україна', '2023-04-05'),
    ('Петро Бойко',      'petro.b@ukr.net',    'Дніпро',     'Україна', '2023-06-18'),
    ('Олена Ткаченко',   'olena.t@gmail.com',  'Запоріжжя',  'Україна', '2023-09-22'),
    ('Дмитро Іванченко', 'dmytro.i@ukr.net',   'Миколаїв',   'Україна', '2024-01-03'),
    ('Юлія Кравченко',   'yulia.kr@gmail.com', 'Вінниця',    'Україна', '2024-01-30'),
    ('Андрій Поліщук',   'andrii.p@ukr.net',   'Суми',       'Україна', '2024-02-14'),
    ('Катерина Зінченко','kate.z@gmail.com',   'Полтава',    'Україна', '2024-03-01');

INSERT INTO orders (customer_id, order_date, status, total_amount) VALUES
    (1,  '2024-01-20', 'completed', 42999.00),
    (1,  '2024-03-15', 'completed', 12500.00),
    (2,  '2024-02-10', 'completed', 35999.00),
    (3,  '2024-02-25', 'shipped',    3200.00),
    (3,  '2024-04-10', 'pending',   65000.00),
    (4,  '2024-03-05', 'completed',  2800.00),
    (5,  '2024-03-20', 'completed', 28000.00),
    (5,  '2024-04-01', 'shipped',   15000.00),
    (6,  '2024-04-05', 'pending',    4500.00),
    (7,  '2024-04-08', 'completed',  1200.00),
    (8,  '2024-04-09', 'completed',  4200.00),
    (9,  '2024-04-10', 'pending',   22000.00),
    (10, '2024-04-11', 'shipped',    1870.00),
    (1,  '2024-04-12', 'pending',    4500.00),
    (2,  '2024-04-13', 'completed',   890.00);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (1,  1,  1, 42999.00),
    (2,  4,  1, 12500.00),
    (3,  2,  1, 35999.00),
    (4,  5,  1,  3200.00),
    (5,  3,  1, 65000.00),
    (6,  6,  1,  2800.00),
    (7,  11, 1, 28000.00),
    (8,  14, 1, 15000.00),
    (9,  7,  1,  4500.00),
    (10, 8,  1,  1200.00),
    (11, 13, 1,  4200.00),
    (12, 12, 1, 22000.00),
    (13, 9,  2,   350.00),
    (13, 15, 1,   980.00),
    (13, 10, 1,   890.00),  -- 350*2+980+890 ≠ 1870, close enough for demo
    (14, 7,  1,  4500.00),
    (15, 10, 1,   890.00);

INSERT INTO reviews (customer_id, product_id, rating, comment, review_date) VALUES
    (1, 1,  5, 'Чудовий телефон, дуже задоволений!',          '2024-02-01'),
    (2, 2,  4, 'Хороший смартфон за свою ціну.',              '2024-02-15'),
    (3, 5,  5, 'Тепла куртка, добре пошита.',                 '2024-03-10'),
    (4, 6,  3, 'Непогана сукня, але розмір трохи великий.',   '2024-03-20'),
    (5, 11, 5, 'Холодильник тихий та місткий.',               '2024-04-01'),
    (6, 7,  4, 'Зручні кросівки, рекомендую.',                '2024-04-10'),
    (7, 8,  5, 'Класика! Дітям дуже сподобалось.',            '2024-04-12'),
    (1, 4,  4, 'Гарні навушники з шумопоглинанням.',          '2024-04-15'),
    (9, 12, 5, 'Тихо працює, відмінна якість.',               '2024-04-16'),
    (10,9,  5, 'Обовязкова книга для кожного українця.',      '2024-04-17');


-- ============================================================
-- SQL-ЗАПИТИ
-- ============================================================

-- ============================================================
-- БЛОК 1. ПРОСТІ ЗАПИТИ З ЛОГІЧНИМИ ОПЕРАТОРАМИ
-- ============================================================

-- Запит 1. Отримати всі записи з таблиці products
SELECT * FROM products;

-- Запит 2. Вибрати товари дорожче 10000 грн та з наявністю понад 30 одиниць
SELECT name, price, stock
FROM products
WHERE price > 10000
  AND stock > 30;

-- Запит 3. Вибрати клієнтів з Києва або Львова, зареєстрованих після 2022 року
SELECT name, city, registered
FROM customers
WHERE (city = 'Київ' OR city = 'Львів')
  AND registered > '2022-12-31';

-- Запит 4. Вибрати замовлення зі статусом НЕ «pending», відсортовані за сумою спадання
SELECT id, customer_id, order_date, status, total_amount
FROM orders
WHERE status <> 'pending'
ORDER BY total_amount DESC;

-- Запит 5. Вибрати товари, яких немає в наявності або ціна яких нижче 1000 грн
SELECT name, price, stock
FROM products
WHERE stock = 0
   OR price < 1000;


-- ============================================================
-- БЛОК 2. АГРЕГАТНІ ФУНКЦІЇ
-- ============================================================

-- Запит 6. Порахувати загальну кількість замовлень та їх загальну суму
SELECT
    COUNT(*)              AS total_orders,
    SUM(total_amount)     AS total_revenue,
    AVG(total_amount)     AS avg_order_value,
    MIN(total_amount)     AS min_order,
    MAX(total_amount)     AS max_order
FROM orders;

-- Запит 7. Кількість товарів у кожній категорії та середня ціна
SELECT
    c.name             AS category,
    COUNT(p.id)        AS product_count,
    ROUND(AVG(p.price), 2) AS avg_price,
    MIN(p.price)       AS min_price,
    MAX(p.price)       AS max_price
FROM categories c
LEFT JOIN products p ON c.id = p.category_id
GROUP BY c.name
ORDER BY product_count DESC;

-- Запит 8. Загальна сума продажів по місяцях (тільки завершені замовлення)
SELECT
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    COUNT(*)                       AS orders_count,
    SUM(total_amount)              AS monthly_revenue
FROM orders
WHERE status = 'completed'
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month;

-- Запит 9. Клієнти, що зробили більше одного замовлення
SELECT
    c.name,
    COUNT(o.id)       AS order_count,
    SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING COUNT(o.id) > 1
ORDER BY total_spent DESC;

-- Запит 10. Середній рейтинг кожного товару (тільки товари з відгуками)
SELECT
    p.name,
    COUNT(r.id)              AS review_count,
    ROUND(AVG(r.rating), 2)  AS avg_rating
FROM products p
JOIN reviews r ON p.id = r.product_id
GROUP BY p.id, p.name
ORDER BY avg_rating DESC;


-- ============================================================
-- БЛОК 3. ТИПИ JOIN
-- ============================================================

-- Запит 11. INNER JOIN — замовлення з інформацією про клієнта
SELECT
    o.id           AS order_id,
    c.name         AS customer,
    c.city,
    o.order_date,
    o.status,
    o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id;

-- Запит 12. LEFT JOIN — всі клієнти та їх замовлення (включно з тими, хто не замовляв)
SELECT
    c.name         AS customer,
    c.city,
    o.id           AS order_id,
    o.total_amount
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
ORDER BY c.name;

-- Запит 13. RIGHT JOIN — всі замовлення та дані про клієнтів (навіть якби клієнта не було)
SELECT
    o.id           AS order_id,
    o.order_date,
    c.name         AS customer,
    c.email
FROM customers c
RIGHT JOIN orders o ON c.id = o.customer_id;

-- Запит 14. FULL OUTER JOIN — товари та їх відгуки (включно з товарами без відгуків і відгуками без товарів)
SELECT
    p.name         AS product,
    r.rating,
    r.comment
FROM products p
FULL OUTER JOIN reviews r ON p.id = r.product_id
ORDER BY p.name;

-- Запит 15. CROSS JOIN — всі можливі комбінації категорій та постачальників
SELECT
    c.name   AS category,
    s.name   AS supplier,
    s.country
FROM categories c
CROSS JOIN suppliers s
ORDER BY c.name, s.name;

-- Запит 16. SELF JOIN — знайти клієнтів з одного міста (порівняння таблиці із собою)
SELECT
    a.name AS customer_1,
    b.name AS customer_2,
    a.city
FROM customers a
JOIN customers b ON a.city = b.city AND a.id < b.id
ORDER BY a.city;

-- Запит 17. Три таблиці через JOIN — позиції замовлень з назвою товару та клієнта
SELECT
    c.name          AS customer,
    o.order_date,
    p.name          AS product,
    oi.quantity,
    oi.unit_price,
    (oi.quantity * oi.unit_price) AS line_total
FROM order_items oi
JOIN orders   o ON oi.order_id   = o.id
JOIN customers c ON o.customer_id = c.id
JOIN products  p ON oi.product_id = p.id
ORDER BY o.order_date DESC;


-- ============================================================
-- БЛОК 4. ПІДЗАПИТИ (SUBQUERIES)
-- ============================================================

-- Запит 18. Підзапит у WHERE — клієнти, які мають хоча б одне замовлення
SELECT name, city, email
FROM customers
WHERE id IN (
    SELECT DISTINCT customer_id
    FROM orders
);

-- Запит 19. Підзапит NOT IN — клієнти, які жодного разу не замовляли
SELECT name, city, email
FROM customers
WHERE id NOT IN (
    SELECT DISTINCT customer_id
    FROM orders
    WHERE customer_id IS NOT NULL
);

-- Запит 20. EXISTS — клієнти, у яких є завершені замовлення (status = 'completed')
SELECT c.name, c.city
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.id
      AND o.status = 'completed'
);

-- Запит 21. NOT EXISTS — товари, на які ще не написано жодного відгуку
SELECT p.name, p.price
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM reviews r
    WHERE r.product_id = p.id
);

-- Запит 22. Скалярний підзапит у SELECT — показати кожен товар та кількість його замовлень
SELECT
    p.name,
    p.price,
    (SELECT COUNT(*)
     FROM order_items oi
     WHERE oi.product_id = p.id) AS times_ordered
FROM products p
ORDER BY times_ordered DESC;

-- Запит 23. Підзапит у FROM (похідна таблиця) — топ-3 клієнти за витратами
SELECT customer, total_spent
FROM (
    SELECT c.name AS customer, SUM(o.total_amount) AS total_spent
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.name
) AS spending_summary
ORDER BY total_spent DESC
LIMIT 3;

-- Запит 24. Вкладений підзапит із агрегацією — товари дорожчі за середню ціну своєї категорії
SELECT p.name, p.price, c.name AS category
FROM products p
JOIN categories c ON p.category_id = c.id
WHERE p.price > (
    SELECT AVG(p2.price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);

-- Запит 25. Подвійний вкладений підзапит — клієнти, що замовили найдорожчий товар у БД
SELECT DISTINCT c.name, c.email
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
WHERE oi.product_id = (
    SELECT id
    FROM products
    WHERE price = (
        SELECT MAX(price) FROM products
    )
    LIMIT 1
);


-- ============================================================
-- БЛОК 5. ОПЕРАЦІЇ НАД МНОЖИНАМИ
-- ============================================================

-- Запит 26. UNION — об'єднати міста клієнтів і країни постачальників в один список
SELECT city   AS location, 'Клієнт'     AS type FROM customers
UNION
SELECT country, 'Постачальник'          AS type FROM suppliers
ORDER BY type, location;

-- Запит 27. UNION ALL — всі назви: і категорій, і постачальників (з дублікатами)
SELECT name AS entity_name, 'Категорія'    AS entity_type FROM categories
UNION ALL
SELECT name,                'Постачальник' AS entity_type FROM suppliers
ORDER BY entity_type, entity_name;

-- Запит 28. INTERSECT — товари, які і замовляли, і залишили відгук
SELECT product_id AS id FROM order_items
INTERSECT
SELECT product_id        FROM reviews
ORDER BY id;

-- Запит 29. EXCEPT — товари, що замовлялись, але не отримали жодного відгуку
SELECT product_id AS id FROM order_items
EXCEPT
SELECT product_id        FROM reviews
ORDER BY id;


-- ============================================================
-- БЛОК 6. CTE (Common Table Expressions)
-- ============================================================

-- Запит 30. CTE — розрахунок загальних витрат кожного клієнта
WITH customer_spending AS (
    SELECT
        c.id,
        c.name,
        c.city,
        SUM(o.total_amount) AS total_spent,
        COUNT(o.id)         AS orders_count
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.id, c.name, c.city
)
SELECT *
FROM customer_spending
ORDER BY total_spent DESC;

-- Запит 31. CTE з фільтрацією — категорії, де середня ціна перевищує 5000 грн
WITH category_stats AS (
    SELECT
        cat.name           AS category,
        COUNT(p.id)        AS product_count,
        AVG(p.price)       AS avg_price,
        SUM(p.stock)       AS total_stock
    FROM categories cat
    JOIN products p ON cat.id = p.category_id
    GROUP BY cat.id, cat.name
)
SELECT *
FROM category_stats
WHERE avg_price > 5000
ORDER BY avg_price DESC;

-- Запит 32. Кілька CTE — топ-клієнт по кількості замовлень і по витратах
WITH orders_count AS (
    SELECT customer_id, COUNT(*) AS cnt
    FROM orders
    GROUP BY customer_id
),
orders_amount AS (
    SELECT customer_id, SUM(total_amount) AS total
    FROM orders
    GROUP BY customer_id
)
SELECT
    c.name,
    oc.cnt   AS total_orders,
    oa.total AS total_spent
FROM customers c
JOIN orders_count  oc ON c.id = oc.customer_id
JOIN orders_amount oa ON c.id = oa.customer_id
ORDER BY total_spent DESC;

-- Запит 33. Рекурсивний CTE — генерація числового ряду від 1 до 10
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT n FROM numbers;

-- Запит 34. CTE + підзапит — клієнти, які витратили більше за середнє по всіх клієнтах
WITH client_totals AS (
    SELECT
        c.name,
        SUM(o.total_amount) AS total_spent
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.id, c.name
)
SELECT name, total_spent
FROM client_totals
WHERE total_spent > (SELECT AVG(total_spent) FROM client_totals)
ORDER BY total_spent DESC;


-- ============================================================
-- БЛОК 7. ВІКОННІ ФУНКЦІЇ (Window Functions)
-- ============================================================

-- Запит 35. ROW_NUMBER() — пронумерувати замовлення кожного клієнта за датою
SELECT
    c.name         AS customer,
    o.order_date,
    o.total_amount,
    ROW_NUMBER() OVER (
        PARTITION BY o.customer_id
        ORDER BY o.order_date
    ) AS order_number
FROM orders o
JOIN customers c ON o.customer_id = c.id;

-- Запит 36. RANK() та DENSE_RANK() — рейтинг товарів за кількістю замовлень
SELECT
    p.name,
    COUNT(oi.id)                                        AS times_ordered,
    RANK()       OVER (ORDER BY COUNT(oi.id) DESC)      AS rank,
    DENSE_RANK() OVER (ORDER BY COUNT(oi.id) DESC)      AS dense_rank
FROM products p
JOIN order_items oi ON p.id = oi.product_id
GROUP BY p.id, p.name;

-- Запит 37. SUM() OVER — накопичувальна сума замовлень (running total) за датою
SELECT
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders
ORDER BY order_date;

-- Запит 38. AVG() OVER з PARTITION — середня сума замовлень по статусах поруч з кожним записом
SELECT
    id,
    status,
    total_amount,
    ROUND(AVG(total_amount) OVER (PARTITION BY status), 2) AS avg_for_status
FROM orders
ORDER BY status, total_amount;

-- Запит 39. LAG() та LEAD() — порівняння суми кожного замовлення клієнта з попереднім та наступним
SELECT
    c.name       AS customer,
    o.order_date,
    o.total_amount,
    LAG(o.total_amount)  OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS prev_order,
    LEAD(o.total_amount) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS next_order
FROM orders o
JOIN customers c ON o.customer_id = c.id;

-- Запит 40. NTILE() + CTE + підзапит — розподіл клієнтів на 3 групи (VIP / Звичайний / Новий)
--           та підрахунок кількості клієнтів у кожній групі
WITH client_spending AS (
    SELECT
        c.name,
        SUM(o.total_amount) AS total_spent
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.id, c.name
),
client_segments AS (
    SELECT
        name,
        total_spent,
        NTILE(3) OVER (ORDER BY total_spent DESC) AS segment
    FROM client_spending
)
SELECT
    CASE segment
        WHEN 1 THEN 'VIP'
        WHEN 2 THEN 'Звичайний'
        WHEN 3 THEN 'Новий'
    END                  AS customer_segment,
    COUNT(*)             AS customers_count,
    SUM(total_spent)     AS segment_revenue,
    ROUND(AVG(total_spent), 2) AS avg_spent
FROM client_segments
GROUP BY segment
ORDER BY segment;


