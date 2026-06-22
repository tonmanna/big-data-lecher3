# โมดูล 1 — Docker เบื้องต้น

## 🎯 เป้าหมาย
- เข้าใจว่า "container" คืออะไร
- ยกฐานข้อมูลทั้ง stack ขึ้นด้วยคำสั่งเดียว

## 💡 Container คืออะไร (แบบบ้านๆ)
ลองนึกว่า container = "กล่องสำเร็จรูป" ที่มีโปรแกรม + ทุกอย่างที่มันต้องใช้ บรรจุมาให้พร้อมรัน
แทนที่เราจะลง PostgreSQL, MongoDB, ElasticSearch ทีละตัวให้ปวดหัว เราแค่บอก Docker ว่า
"เอ่อ ขอกล่องพวกนี้หน่อย" แล้วมันจัดให้

ไฟล์ `docker-compose.yml` คือ "ใบสั่งของ" ที่บอกว่าเราต้องการ container อะไรบ้าง

## 🛠️ ลงมือทำ
```bash
# เปิดทั้ง stack
docker compose up -d

# ดูว่ามี container อะไรทำงานอยู่บ้าง
docker compose ps

# ดู log ของบริการใดบริการหนึ่ง (เช่น postgres)
docker compose logs postgres

# ปิดทั้งหมด (ข้อมูลยังอยู่)
docker compose down
```

## 🔍 ลองเปิดหน้าเว็บ
- http://localhost:8080 — Adminer (Postgres)
- http://localhost:8081 — Mongo Express
- http://localhost:5601 — Kibana (ES)

## 🤖 ลองกับ Claude Code
> *"docker compose ps แล้วบริการ elasticsearch ขึ้น unhealthy ช่วยดู log แล้วบอกสาเหตุหน่อย"*

> *"อธิบายว่าในไฟล์ docker-compose.yml บรรทัด ports: \"5432:5432\" หมายความว่าอะไร"*

## ✅ เช็ค
- [ ] `docker compose ps` เห็น 6 บริการ status เป็น running/healthy
- [ ] เปิดหน้าเว็บทั้ง 3 ได้

➡️ [โมดูล 2 — PostgreSQL](../02-postgresql/README.md)
