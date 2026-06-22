# โมดูล 3 — MongoDB (ฐานข้อมูลแบบเอกสาร)

## 🎯 เป้าหมาย
- เข้าใจ "document" และทำไมมันยืดหยุ่นกว่าตาราง
- เขียน query และ aggregation pipeline พื้นฐาน

## 📊 ข้อมูลของเรา (db: `shop`)
- `reviews` — รีวิวสินค้า (1 เอกสาร = 1 รีวิว)
- `product_catalog` — สเปคสินค้า มี nested object และ field ไม่เท่ากัน

ดูข้อมูลเต็มที่ [`data/seed/mongodb/01_init.js`](../../data/seed/mongodb/01_init.js)

## 💡 ต่างจาก SQL ยังไง?
ใน PostgreSQL ทุกแถวต้องมีคอลัมน์เหมือนกัน แต่ใน MongoDB แต่ละ document
มี field ไม่เท่ากันได้ และเก็บข้อมูลซ้อนกัน (nested) ได้เลย — เหมาะกับข้อมูลที่โครงสร้างไม่ตายตัว

## 🛠️ เข้าใช้งาน
**หน้าเว็บ:** http://localhost:8081 (Mongo Express)

**command line:**
```bash
docker exec -it workshop-mongodb mongosh -u shopadmin -p shop1234
```
```javascript
use shop
```

## 📝 ลองรัน query เหล่านี้

```javascript
// 1) ดูรีวิวทั้งหมด
db.reviews.find().pretty()

// 2) รีวิวที่ให้ 5 ดาว
db.reviews.find({ rating: 5 })

// 3) รีวิวที่มี tag "audio"
db.reviews.find({ tags: "audio" })

// 4) คะแนนเฉลี่ยและจำนวนรีวิวต่อสินค้า (aggregation)
db.reviews.aggregate([
  { $group: {
      _id: "$product_name",
      avg_rating: { $avg: "$rating" },
      review_count: { $sum: 1 }
  }},
  { $sort: { avg_rating: -1 } }
])

// 5) เข้าถึงข้อมูล nested — สินค้าที่แบตเกิน 20 ชั่วโมง
db.product_catalog.find({ "specs.battery_hours": { $gt: 20 } })
```

## 🤖 ลองกับ Claude Code
> *"เขียน aggregation หาสินค้าที่ได้คะแนนรีวิวเฉลี่ยต่ำกว่า 4 ดาว"*

> *"ใน collection reviews ช่วยนับว่าแต่ละ tag ถูกใช้กี่ครั้ง"*

## ✅ เช็ค
- [ ] รัน find และ aggregate ได้
- [ ] เข้าใจว่า document เก็บ nested data ได้

➡️ [โมดูล 4 — ElasticSearch](../04-elasticsearch/README.md)
