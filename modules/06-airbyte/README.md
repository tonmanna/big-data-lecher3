# โมดูล 6 — Airbyte (ย้ายข้อมูลระหว่างระบบ)

## 🎯 เป้าหมาย
- เข้าใจว่า ELT / data integration คืออะไร
- ตั้ง connection ดึงข้อมูลจาก PostgreSQL ไปปลายทางอัตโนมัติ

## 💡 ปัญหาที่ Airbyte แก้
ข้อมูลร้านเราอยู่ใน PostgreSQL แต่เราอยากให้ช่องค้นหา (ElasticSearch) มีข้อมูลสินค้าล่าสุดเสมอ
จะมานั่ง copy เองทุกวันก็ไม่ไหว → **Airbyte ทำหน้าที่ "ท่อส่งข้อมูล" อัตโนมัติ**
ตั้งครั้งเดียว มันดึงข้อมูลให้ตามรอบที่กำหนด (เรียกว่า **Source → Destination**)

## ⚙️ ติดตั้ง Airbyte (ด้วย abctl)
Airbyte รันแยกจาก docker-compose ของเรา (ตัวมันใหญ่และมีหลาย component)
วิธีที่ทางการแนะนำคือใช้ `abctl`:

```bash
# 1) ติดตั้ง abctl (ดูล่าสุดที่ https://docs.airbyte.com/using-airbyte/getting-started/oss-quickstart)
curl -LsfS https://get.airbyte.com | bash -

# 2) เปิด Airbyte (ใช้เวลาสักครู่ตอนแรก)
abctl local install

# 3) เอารหัสผ่านเข้าหน้าเว็บ
abctl local credentials

# 4) เปิดเบราว์เซอร์
#    http://localhost:8000
```

## 🔌 ตั้ง Connection (ทำผ่านหน้าเว็บ Airbyte)

**Source = PostgreSQL ของเรา**
- Host: `host.docker.internal` (ให้ Airbyte เห็น Postgres ที่รันบนเครื่องเรา)
- Port: `5432`
- Database: `shop`
- User / Password: ตาม `.env`
- Schemas: `public`

**Destination** — เริ่มจากง่ายสุดก่อน เลือก **Local JSON** หรือ **Local CSV**
(พอเข้าใจ flow แล้วค่อยลองต่อไป ElasticSearch / อื่นๆ)

จากนั้น:
1. เลือกตารางที่จะ sync (เช่น `products`, `orders`)
2. เลือก sync mode (เริ่มที่ **Full refresh** ง่ายสุด)
3. กด **Sync now** แล้วดูข้อมูลไหลออกมา 🎉

## 🤖 ลองกับ Claude Code
> *"abctl local install ขึ้น error อันนี้ ช่วยอ่านให้หน่อย"*

> *"อธิบายความต่างของ sync mode แบบ Full refresh กับ Incremental ใน Airbyte"*

> *"ผมตั้ง Source Postgres แล้วต่อไม่ติด ขึ้น connection refused ควรเช็คอะไรบ้าง"*

## 📝 หมายเหตุสำหรับผู้สอน
- ถ้าเวลาจำกัด ให้ demo การ sync ไป **Local JSON** ก็พอเห็นภาพ ELT แล้ว
- การต่อ Postgres → ElasticSearch ตรงๆ อาจต้องตั้งค่าเพิ่ม เก็บไว้เป็นหัวข้อ advanced

## ✅ เช็ค
- [ ] เปิดหน้าเว็บ Airbyte ได้
- [ ] ตั้ง Source = Postgres สำเร็จ
- [ ] sync ข้อมูลออกไป destination ได้อย่างน้อย 1 ครั้ง

➡️ [โมดูล 7 — End-to-End Pipeline](../07-pipeline/README.md)
