-- ============================================================
--  ข้อมูลตัวอย่าง (seed data) ร้านค้าออนไลน์
-- ============================================================

-- ----- หมวดสินค้า -----
INSERT INTO categories (name) VALUES
    ('Electronics'),
    ('Books'),
    ('Home & Kitchen'),
    ('Fashion'),
    ('Sports');

-- ----- ลูกค้า -----
INSERT INTO customers (full_name, email, city) VALUES
    ('Somchai Jaidee',    'somchai@example.com',  'Bangkok'),
    ('Suda Rakdee',       'suda@example.com',     'Chiang Mai'),
    ('Anan Pongsak',      'anan@example.com',     'Bangkok'),
    ('Malee Sukjai',      'malee@example.com',    'Khon Kaen'),
    ('John Smith',        'john@example.com',     'Phuket'),
    ('Ploy Wattana',      'ploy@example.com',     'Bangkok'),
    ('Kitti Boonmee',     'kitti@example.com',    'Chiang Mai'),
    ('Nicha Charoen',     'nicha@example.com',    'Rayong');

-- ----- สินค้า -----
INSERT INTO products (name, category_id, price, stock) VALUES
    ('Wireless Headphones',        1, 1290.00, 50),
    ('USB-C Charger 65W',          1,  690.00, 120),
    ('Mechanical Keyboard',        1, 2490.00, 30),
    ('4K Webcam',                  1, 1990.00, 25),
    ('The Pragmatic Programmer',   2,  890.00, 40),
    ('Clean Code',                 2,  790.00, 35),
    ('Designing Data-Intensive Apps', 2, 1290.00, 20),
    ('Ceramic Coffee Mug',         3,  250.00, 200),
    ('Stainless Water Bottle',     3,  450.00, 80),
    ('Non-stick Frying Pan',       3,  690.00, 60),
    ('Cotton T-Shirt',             4,  390.00, 150),
    ('Running Shoes',              4, 1890.00, 45),
    ('Denim Jacket',               4, 1490.00, 25),
    ('Yoga Mat',                   5,  590.00, 70),
    ('Dumbbell Set 10kg',          5,  990.00, 40);

-- ----- ออเดอร์ -----
INSERT INTO orders (customer_id, order_date, status) VALUES
    (1, '2026-05-01 10:15', 'shipped'),
    (2, '2026-05-02 14:30', 'paid'),
    (1, '2026-05-05 09:05', 'shipped'),
    (3, '2026-05-10 18:45', 'cancelled'),
    (4, '2026-05-12 11:20', 'paid'),
    (5, '2026-05-15 16:00', 'shipped'),
    (6, '2026-05-18 13:10', 'paid'),
    (2, '2026-05-20 19:30', 'shipped'),
    (8, '2026-06-01 08:50', 'paid'),
    (1, '2026-06-10 12:00', 'paid');

-- ----- รายการในออเดอร์ -----
-- order 1 (Somchai)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (1, 1, 1, 1290.00),
    (1, 2, 2,  690.00),
-- order 2 (Suda)
    (2, 5, 1,  890.00),
    (2, 8, 3,  250.00),
-- order 3 (Somchai)
    (3, 3, 1, 2490.00),
-- order 4 (Anan - cancelled)
    (4, 12, 1, 1890.00),
-- order 5 (Malee)
    (5, 11, 2,  390.00),
    (5, 14, 1,  590.00),
-- order 6 (John)
    (6, 4, 1, 1990.00),
    (6, 2, 1,  690.00),
-- order 7 (Ploy)
    (7, 7, 1, 1290.00),
    (7, 6, 1,  790.00),
-- order 8 (Suda)
    (8, 9, 2,  450.00),
    (8, 8, 4,  250.00),
-- order 9 (Nicha)
    (9, 12, 1, 1890.00),
    (9, 15, 1,  990.00),
-- order 10 (Somchai)
    (10, 1, 1, 1290.00),
    (10, 10, 1, 690.00);
