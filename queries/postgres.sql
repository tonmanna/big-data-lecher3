-- ============================================================
--  ชุด query ตัวอย่าง — PostgreSQL
--  รันทั้งไฟล์:
--    docker exec -i workshop-postgres psql -U shopadmin -d shop < queries/postgres.sql
--  หรือ copy ทีละ query ไปวางใน Adminer (http://localhost:8080)
-- ============================================================

-- [1] สินค้าทั้งหมด เรียงตามราคาแพงสุด
SELECT name, price FROM products ORDER BY price DESC;

-- [2] สินค้าในหมวด Electronics
SELECT p.name, p.price
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE c.name = 'Electronics';

-- [3] ยอดขายรวมต่อออเดอร์ (เฉพาะที่ไม่ถูกยกเลิก)
SELECT o.order_id, cu.full_name,
       SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN customers cu   ON o.customer_id = cu.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'cancelled'
GROUP BY o.order_id, cu.full_name
ORDER BY order_total DESC;

-- [4] สินค้าขายดี 5 อันดับแรก (ตามจำนวนชิ้นที่ขายได้)
SELECT p.name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY units_sold DESC
LIMIT 5;

-- [5] ยอดขายรวมแยกตามหมวดสินค้า
SELECT c.name AS category,
       SUM(oi.quantity * oi.unit_price) AS revenue
FROM order_items oi
JOIN products p   ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN orders o     ON oi.order_id = o.order_id
WHERE o.status <> 'cancelled'
GROUP BY c.name
ORDER BY revenue DESC;

-- [6] ลูกค้าที่ใช้เงินมากที่สุด 3 อันดับแรก
SELECT cu.full_name,
       SUM(oi.quantity * oi.unit_price) AS lifetime_value
FROM customers cu
JOIN orders o       ON cu.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status <> 'cancelled'
GROUP BY cu.full_name
ORDER BY lifetime_value DESC
LIMIT 3;

-- [7] จำนวนออเดอร์แยกตามสถานะ
SELECT status, COUNT(*) AS orders
FROM orders
GROUP BY status
ORDER BY orders DESC;
