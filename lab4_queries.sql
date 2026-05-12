-- 1. Створюємо тип ENUM зі списком можливих статусів
CREATE TYPE delivery_status AS ENUM ('pending', 'in_transit', 'delivered', 'canceled');

-- 2. Змінюємо тип існуючої колонки status у таблиці deliveries
ALTER TABLE deliveries 
ALTER COLUMN status TYPE delivery_status USING status::delivery_status;

CREATE OR REPLACE FUNCTION get_client_total_spent(p_client_id INT)
RETURNS NUMERIC AS $$
DECLARE
    total_spent NUMERIC;
BEGIN
    SELECT SUM(delivery_cost) INTO total_spent
    FROM deliveries
    WHERE client_id = p_client_id AND status = 'delivered';
    
    RETURN COALESCE(total_spent, 0);
END;
$$ LANGUAGE plpgsql;

-- Тестовий виклик функції (перевіряємо витрати клієнта з ID = 1)
SELECT get_client_total_spent(1);

-- Таблиця для логів
CREATE TABLE delivery_log (
    log_id SERIAL PRIMARY KEY,
    delivery_id INT,
    operation CHAR(1), -- 'I' (Insert), 'U' (Update), 'D' (Delete)
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Тригерна функція
CREATE OR REPLACE FUNCTION log_delivery_changes() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO delivery_log (delivery_id, operation) VALUES (OLD.id, 'D');
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO delivery_log (delivery_id, operation) VALUES (NEW.id, 'U');
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO delivery_log (delivery_id, operation) VALUES (NEW.id, 'I');
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Прив'язка тригера [cite: 447]
CREATE TRIGGER track_delivery_changes
AFTER INSERT OR UPDATE OR DELETE ON deliveries
FOR EACH ROW EXECUTE FUNCTION log_delivery_changes();

-- Додаємо колонку-лічильник у таблицю клієнтів
ALTER TABLE clients ADD COLUMN total_deliveries INT DEFAULT 0;

-- Функція для автооновлення лічильника
CREATE OR REPLACE FUNCTION update_client_delivery_count() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        UPDATE clients SET total_deliveries = total_deliveries + 1 WHERE id = NEW.client_id;
    ELSIF (TG_OP = 'DELETE') THEN
        UPDATE clients SET total_deliveries = total_deliveries - 1 WHERE id = OLD.client_id;
    END IF;
    RETURN NULL; 
END;
$$ LANGUAGE plpgsql;

-- Прив'язка тригера
CREATE TRIGGER trigger_update_client_count
AFTER INSERT OR DELETE ON deliveries
FOR EACH ROW EXECUTE FUNCTION update_client_delivery_count();