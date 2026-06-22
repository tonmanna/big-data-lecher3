-- ============================================================
--  PostgreSQL Schema : ร้านค้าออนไลน์ (E-commerce)
--  ไฟล์นี้จะรันอัตโนมัติตอน docker compose up ครั้งแรก
-- ============================================================

-- ลบตารางเดิมถ้ามี (เผื่อรันซ้ำ)
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-- ----- ลูกค้า -----
CREATE TABLE customers (
    customer_id   SERIAL PRIMARY KEY,
    full_name     VARCHAR(120) NOT NULL,
    email         VARCHAR(160) UNIQUE NOT NULL,
    city          VARCHAR(80),
    created_at    TIMESTAMP DEFAULT NOW()
);

-- ----- หมวดสินค้า -----
CREATE TABLE categories (
    category_id   SERIAL PRIMARY KEY,
    name          VARCHAR(80) NOT NULL
);

-- ----- สินค้า -----
CREATE TABLE products (
    product_id    SERIAL PRIMARY KEY,
    name          VARCHAR(160) NOT NULL,
    category_id   INT REFERENCES categories(category_id),
    price         NUMERIC(10,2) NOT NULL,
    stock         INT NOT NULL DEFAULT 0
);

-- ----- ออเดอร์ (หัวบิล) -----
CREATE TABLE orders (
    order_id      SERIAL PRIMARY KEY,
    customer_id   INT REFERENCES customers(customer_id),
    order_date    TIMESTAMP DEFAULT NOW(),
    status        VARCHAR(20) DEFAULT 'paid'   -- paid / shipped / cancelled
);

-- ----- รายการในออเดอร์ (รายบรรทัด) -----
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id      INT REFERENCES orders(order_id),
    product_id    INT REFERENCES products(product_id),
    quantity      INT NOT NULL,
    unit_price    NUMERIC(10,2) NOT NULL   -- ราคา ณ ตอนซื้อ (snapshot)
);
