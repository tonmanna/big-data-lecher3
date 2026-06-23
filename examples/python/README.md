# 🐍 ตัวอย่าง Python — เชื่อม 3 ฐานข้อมูลเข้าด้วยกัน

สคริปต์ `combine.py` แสดงให้เห็นว่าในงานจริง เราดึงข้อมูลจากหลายระบบมา **รวมเป็นรายงานเดียว** ได้อย่างไร โดยใช้ `product_id` เป็นกุญแจเชื่อม

| ดึงอะไร | จากที่ไหน |
|---------|----------|
| ยอดขายรวม + สต็อก | 🐘 PostgreSQL |
| คะแนนรีวิวเฉลี่ย | 🍃 MongoDB |
| จำนวนผลค้นหา | 🔎 ElasticSearch |

## ▶️ วิธีรัน

ต้องเปิด stack และโหลดข้อมูลก่อน:
```bash
make up && make load && make verify
```

แล้วรันสคริปต์ (แนะนำให้สร้าง virtual environment ก่อน):
```bash
cd examples/python
python -m venv .venv && source .venv/bin/activate   # ไม่บังคับ แต่แนะนำ
pip install -r requirements.txt
python combine.py
```

## 📤 ผลลัพธ์ที่จะเห็น (ตัวอย่าง)
```
สินค้า                              ยอดขาย   สต็อก   คะแนน  รีวิว
----------------------------------------------------------------------
Wireless Headphones                  3,870      50   4.5★      2
Mechanical Keyboard                  2,490      30   5.0★      1
...

🔎 ตัวอย่างค้นหาใน ElasticSearch:
   ค้น 'wireless'  →  1 รายการ
```

## 🤖 ลองต่อยอดกับ Claude Code
> *"แก้ combine.py ให้บันทึกผลเป็นไฟล์ CSV ด้วย"*

> *"เพิ่มคอลัมน์ 'หมวดสินค้า' จาก PostgreSQL ในรายงาน"*
