# โมดูล 7 — ต่อทุกอย่างเป็น Pipeline เดียว

## 🎯 เป้าหมาย
เห็นภาพรวมว่าข้อมูลไหลจากต้นทางถึงปลายทางอย่างไรในระบบจริง

## 🗺️ Flow ที่เราจะสร้าง

```
  [PostgreSQL]                    [Airbyte]                 [ElasticSearch]
  ลูกค้าสั่งซื้อ → บันทึกออเดอร์ ──▶ ดึงข้อมูล products ──▶ ทำ index ค้นหา
       │                                                          ▲
       │                                                          │
       └──────────── ผู้ใช้ค้นหาสินค้าบนหน้าเว็บ ────────────────────┘

  [MongoDB] เก็บรีวิว/แคตตาล็อก ─── เสริมข้อมูลให้หน้าสินค้า
```

## 🛠️ ขั้นตอนรวมทุกอย่าง

1. **เปิด stack หลัก**
   ```bash
   docker compose up -d
   bash data/seed/elasticsearch/load.sh
   ```

2. **ตรวจว่าข้อมูลครบทั้ง 3 ที่**
   ```bash
   # Postgres: นับสินค้า
   docker exec -it workshop-postgres psql -U shopadmin -d shop -c "SELECT COUNT(*) FROM products;"
   # Mongo: นับรีวิว
   docker exec -it workshop-mongodb mongosh -u shopadmin -p shop1234 --quiet --eval "db.getSiblingDB('shop').reviews.countDocuments()"
   # Elastic: นับ index
   curl -s "localhost:9200/products/_count"
   ```

3. **เปิด Airbyte แล้ว sync** `products` จาก Postgres (ดูโมดูล 6)

4. **สถานการณ์จำลอง:** เพิ่มสินค้าใหม่ใน Postgres แล้วดูว่ามันไหลไปปลายทางไหม
   ```sql
   INSERT INTO products (name, category_id, price, stock)
   VALUES ('Smart Watch', 1, 3500.00, 15);
   ```
   จากนั้นสั่ง sync ใน Airbyte อีกครั้ง → ข้อมูลใหม่จะตามไป

## 🧩 ภาพที่ผู้เรียนควรเข้าใจ
- **Postgres** = แหล่งความจริง (source of truth) ของข้อมูลธุรกิจ
- **Airbyte** = สายพานลำเลียงข้อมูล
- **ElasticSearch** = ชั้นสำหรับค้นหา (อัปเดตตาม Postgres)
- **MongoDB** = ที่เก็บข้อมูลเสริมที่ยืดหยุ่น
- **Docker** = พื้นที่ที่ทุกอย่างรันอยู่ด้วยกัน
- **Claude Code** = ผู้ช่วยตลอดทาง

## 🤖 ลองกับ Claude Code
> *"ช่วยเขียนสคริปต์เช็คว่าจำนวนสินค้าใน Postgres กับใน ElasticSearch ตรงกันไหม"*

➡️ [โมดูล 8 — โปรเจกต์จบ](../08-project/README.md)
