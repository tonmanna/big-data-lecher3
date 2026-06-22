# โมดูล 2 — PostgreSQL (ฐานข้อมูลเชิงสัมพันธ์)

## 🎯 เป้าหมาย
- เข้าใจตาราง (table), ความสัมพันธ์ (relation), และ JOIN
- เขียน SQL query ดึงข้อมูลร้านค้าได้

## 📊 ข้อมูลของเรา
ดู schema เต็มที่ [`data/seed/postgres/01_schema.sql`](../../data/seed/postgres/01_schema.sql)

```
customers ──┐
            ├──< orders ──< order_items >── products >── categories
            │
        (1 คนมีได้หลายออเดอร์)   (1 ออเดอร์มีได้หลายสินค้า)
```

## 🛠️ เข้าใช้งาน
**วิธีที่ 1: หน้าเว็บ Adminer** → http://localhost:8080
(System: `PostgreSQL`, Server: `postgres`, User/Pass/DB ดูใน `.env`)

**วิธีที่ 2: command line**
```bash
docker exec -it workshop-postgres psql -U shopadmin -d shop
```

## 📝 ลองรัน query เหล่านี้

```sql
-- 1) ดูสินค้าทั้งหมด เรียงตามราคา
SELECT name, price FROM products ORDER BY price DESC;

-- 2) สินค้าในหมวด Electronics (ต้อง JOIN กับ categories)
SELECT p.name, p.price
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE c.name = 'Electronics';

-- 3) ยอดขายรวมของแต่ละออเดอร์
SELECT o.order_id, c.full_name,
       SUM(oi.quantity * oi.unit_price) AS total
FROM orders o
JOIN customers c   ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id, c.full_name
ORDER BY total DESC;

-- 4) สินค้าขายดี 5 อันดับแรก (ตามจำนวนชิ้น)
SELECT p.name, SUM(oi.quantity) AS sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY sold DESC
LIMIT 5;
```

## 🤖 ลองกับ Claude Code
> *"เขียน SQL หาว่าลูกค้าคนไหนใช้เงินรวมมากที่สุด 3 อันดับแรก (ไม่นับออเดอร์ที่ cancelled)"*

> *"อธิบายความต่างของ INNER JOIN กับ LEFT JOIN โดยใช้ตาราง customers กับ orders เป็นตัวอย่าง"*

## ✅ เช็ค
- [ ] รัน query ทั้ง 4 ข้อได้
- [ ] เข้าใจว่า JOIN เชื่อมตารางด้วยอะไร

➡️ [โมดูล 3 — MongoDB](../03-mongodb/README.md)
