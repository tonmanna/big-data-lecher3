<!-- 🌐 ภาษา: ไทย (ไฟล์นี้) · [English](README.en.md) -->

# 🗃️ Big Data Workshop — สร้าง Mini Data Platform ด้วยตัวเอง

Workshop สอน Big Data สำหรับ **ผู้เริ่มต้น** ผ่านการลงมือทำจริง โดยใช้ธีม **ร้านค้าออนไลน์ (E-commerce)**
เราจะค่อยๆ ประกอบฐานข้อมูล 3 แบบเข้าด้วยกัน แล้วเชื่อมข้อมูลให้ไหลถึงกันด้วยเครื่องมือ data integration

> 🤖 ทุกโมดูลออกแบบมาให้ใช้คู่กับ **Claude Code** — แทนที่จะจำคำสั่ง ให้ "สั่งงานเป็นภาษาคน" แล้วให้ Claude ช่วยเขียน query / config / แก้ปัญหา

---

## 🧩 Stack ที่ใช้ และทำไมต้องมีแต่ละตัว

| เครื่องมือ | คืออะไร | ใช้ทำอะไรใน workshop |
|-----------|---------|---------------------|
| 🐘 **PostgreSQL** | ฐานข้อมูลเชิงสัมพันธ์ (relational) | เก็บข้อมูลหลักของร้าน: ลูกค้า สินค้า ออเดอร์ |
| 🍃 **MongoDB** | ฐานข้อมูลแบบเอกสาร (document / NoSQL) | เก็บรีวิวและแคตตาล็อกที่โครงสร้างยืดหยุ่น |
| 🔎 **ElasticSearch** | เครื่องมือค้นหา (search engine) | ค้นหาสินค้าแบบ full-text ค้นเร็ว จัดอันดับได้ |
| 🔄 **Airbyte** | เครื่องมือ ELT / ย้ายข้อมูล | ดึงข้อมูลจาก Postgres → ไปเก็บที่อื่นอัตโนมัติ |
| 🐳 **Docker** | ตัวรัน service ทั้งหมด | ยกทั้ง stack ขึ้นด้วยคำสั่งเดียว ไม่ต้องลงทีละตัว |
| 🤖 **Claude Code** | ผู้ช่วย AI | ช่วยเขียน query, แก้ config, debug, อธิบาย |

---

## 🗺️ ภาพรวมสถาปัตยกรรม

![Architecture](docs/architecture.svg)

```
   ┌──────────────┐        ┌──────────┐        ┌─────────────────┐
   │  PostgreSQL  │        │          │        │                 │
   │ customers /  │───────▶│ Airbyte  │───────▶│  ElasticSearch  │
   │ products /   │        │  (ELT)   │        │  (ค้นหาสินค้า)    │
   │ orders       │        │          │        │                 │
   └──────────────┘        └──────────┘        └─────────────────┘
   ┌──────────────┐
   │   MongoDB    │   เก็บรีวิว + แคตตาล็อก (document)
   │ reviews /    │
   │ catalog      │
   └──────────────┘
        🐳 ทุกอย่างรันบน Docker   •   🤖 มี Claude Code เป็นผู้ช่วย
```

---

## 🚀 เริ่มต้นใช้งาน (Quick Start)

ต้องมี **Docker Desktop** ติดตั้งไว้ก่อน ([ดาวน์โหลด](https://www.docker.com/products/docker-desktop/))

```bash
# 1) คัดลอกไฟล์ตั้งค่า
cp .env.example .env

# 2) เปิดทั้ง stack (Postgres + MongoDB + ElasticSearch + เครื่องมือหน้าเว็บ)
docker compose up -d

# 3) เช็คว่าทุก service พร้อม
docker compose ps

# 4) โหลดข้อมูลสินค้าเข้า ElasticSearch
bash data/seed/elasticsearch/load.sh
```

> 💡 **ขี้เกียจพิมพ์ยาว?** มี `Makefile` ให้แล้ว — พิมพ์ `make up` → `make load` → `make verify`
> ดูคำสั่งทั้งหมดด้วย `make help`

> PostgreSQL และ MongoDB จะโหลดข้อมูลตัวอย่างให้อัตโนมัติตอนเปิดครั้งแรก

### 🔗 หน้าเว็บที่เปิดได้หลัง `docker compose up`

| บริการ | URL | ใช้ดู |
|--------|-----|------|
| Adminer (Postgres UI) | http://localhost:8080 | จัดการ PostgreSQL |
| Mongo Express | http://localhost:8081 | จัดการ MongoDB |
| Kibana | http://localhost:5601 | query ElasticSearch |
| ElasticSearch API | http://localhost:9200 | เรียกผ่าน curl/REST |

ข้อมูลล็อกอิน Adminer → System: `PostgreSQL`, Server: `postgres`, Username/Password/DB ตามไฟล์ `.env`

---

## 🖥️ สไลด์ประกอบการสอน

เปิดไฟล์ [`slides.html`](slides.html) ในเบราว์เซอร์ (ดับเบิลคลิกได้เลย ไม่ต้องต่อเน็ต)
ใช้ลูกศร ← → หรือ Spacebar เลื่อนสไลด์ — เหมาะสำหรับฉายในคลาส

🌐 **รองรับ 3 ภาษา: EN / TH / 中文** — กดปุ่มสลับภาษามุมบนขวา (จำค่าที่เลือกไว้ให้อัตโนมัติ)

---

## 📚 เนื้อหา 8 โมดูล

| # | โมดูล | เรียนรู้ |
|---|-------|---------|
| 0 | [การเตรียมเครื่อง](modules/00-setup/README.md) | ติดตั้ง Docker + Claude Code |
| 1 | [Docker เบื้องต้น](modules/01-docker/README.md) | ยก stack ขึ้น เข้าใจ container |
| 2 | [PostgreSQL](modules/02-postgresql/README.md) | SQL, join, ออกแบบตาราง |
| 3 | [MongoDB](modules/03-mongodb/README.md) | document model, aggregation |
| 4 | [ElasticSearch](modules/04-elasticsearch/README.md) | full-text search, query DSL |
| 5 | [เปรียบเทียบ 3 ฐานข้อมูล](modules/05-compare/README.md) | ใช้อันไหนเมื่อไหร่ |
| 6 | [Airbyte](modules/06-airbyte/README.md) | ย้ายข้อมูลระหว่างระบบ |
| 7 | [End-to-End Pipeline](modules/07-pipeline/README.md) | ต่อทุกอย่างเป็น flow เดียว |
| 8 | [โปรเจกต์จบ](modules/08-project/README.md) | สร้าง mini data platform เอง |

---

## 🧰 ของแถมในรีโป

| ไฟล์ / โฟลเดอร์ | ใช้ทำอะไร |
|----------------|----------|
| `Makefile` | คำสั่งลัด (`make up/down/load/verify/quality/...`) |
| `scripts/verify.sh` | ตรวจว่าทุกบริการพร้อมและข้อมูลครบ |
| `scripts/data_quality.sh` | ตรวจคุณภาพข้อมูลใน PostgreSQL |
| `queries/` | ชุด query พร้อมรันของทั้ง 3 ฐานข้อมูล |
| `submissions/` | ที่ส่งงานโปรเจกต์จบของผู้เรียน |
| [`INSTRUCTOR.md`](INSTRUCTOR.md) | คู่มือผู้สอน (แผนเวลา + แก้ปัญหาที่เจอบ่อย) |

---

## 🛑 จบ workshop / เคลียร์เครื่อง

```bash
docker compose down       # ปิด service (ข้อมูลยังอยู่)
docker compose down -v    # ปิด + ลบข้อมูลทั้งหมด เริ่มใหม่สะอาดๆ
```

---

## 💡 เคล็ดลับการใช้ Claude Code ตลอด workshop

ลองพิมพ์คำสั่งพวกนี้กับ Claude Code ดู:
- *"เขียน SQL หายอดขายรวมของลูกค้าแต่ละคน เรียงจากมากไปน้อย"*
- *"แปลง aggregation pipeline ของ MongoDB อันนี้ให้หาคะแนนรีวิวเฉลี่ยต่อสินค้า"*
- *"เขียน ElasticSearch query หาสินค้าหมวด Electronics ราคาต่ำกว่า 2000"*
- *"docker compose ขึ้น error อันนี้ ช่วยดูให้หน่อย"*

ดูรายละเอียดเพิ่มเติมที่ [`CLAUDE.md`](CLAUDE.md)
