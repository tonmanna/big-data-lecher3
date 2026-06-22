# CLAUDE.md — บริบทสำหรับ Claude Code

repo นี้คือ **Workshop สอน Big Data สำหรับผู้เริ่มต้น** ธีมร้านค้าออนไลน์ (E-commerce)
เมื่อช่วยผู้เรียน ให้ยึดหลักด้านล่างนี้

## กลุ่มเป้าหมาย
- **ผู้เริ่มต้น** — อาจไม่เคยใช้ Docker / SQL / NoSQL มาก่อน
- อธิบายเป็นภาษาง่ายๆ ทีละขั้น มีคำสั่งที่ copy-paste ได้
- เลี่ยงศัพท์เทคนิคที่ไม่จำเป็น ถ้าใช้ให้ขยายความสั้นๆ

## Stack และพอร์ต
| บริการ | พอร์ต | หมายเหตุ |
|--------|------|---------|
| PostgreSQL | 5432 | db: `shop` user/pass ดูใน `.env` |
| Adminer | 8080 | หน้าเว็บจัดการ Postgres |
| MongoDB | 27017 | db: `shop` |
| Mongo Express | 8081 | หน้าเว็บจัดการ Mongo |
| ElasticSearch | 9200 | ปิด security ไว้ (workshop เท่านั้น) |
| Kibana | 5601 | หน้าเว็บ query ES |

## โครงสร้างข้อมูล (E-commerce)
- **PostgreSQL** : `customers`, `categories`, `products`, `orders`, `order_items`
  (ดู schema ที่ `data/seed/postgres/01_schema.sql`)
- **MongoDB** (db `shop`) : collection `reviews`, `product_catalog`
- **ElasticSearch** : index `products` (โหลดด้วย `data/seed/elasticsearch/load.sh`)
- `product_id` ใช้เชื่อมโยงข้อมูลข้ามทั้ง 3 ระบบ

## คำสั่งที่ใช้บ่อย
```bash
docker compose up -d            # เปิด stack
docker compose ps               # เช็คสถานะ
docker compose logs <service>   # ดู log
docker compose down -v          # ลบทุกอย่างเริ่มใหม่
bash data/seed/elasticsearch/load.sh   # โหลดข้อมูลเข้า ES

# เข้า psql ใน container
docker exec -it workshop-postgres psql -U shopadmin -d shop
# เข้า mongosh ใน container
docker exec -it workshop-mongodb mongosh -u shopadmin -p shop1234
```

## แนวทางตอบ
- เวลาเขียน query ให้ใส่คอมเมนต์อธิบายสั้นๆ ว่าแต่ละบรรทัดทำอะไร
- เวลามี error ให้ช่วยอ่าน log แล้วอธิบายสาเหตุก่อนเสนอวิธีแก้
- ถ้าผู้เรียนถามเชิงเปรียบเทียบ (เช่น SQL vs NoSQL) ให้ตอบแบบ trade-off ไม่ฟันธงด้านเดียว
- โค้ดทั้งหมดควรรันได้จริงกับ stack นี้ และทดสอบกับข้อมูลตัวอย่างที่ให้ไว้
