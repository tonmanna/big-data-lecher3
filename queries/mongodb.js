// ============================================================
//  ชุด query ตัวอย่าง — MongoDB
//  รันทั้งไฟล์:
//    docker exec -i workshop-mongodb mongosh -u shopadmin -p shop1234 \
//      shop < queries/mongodb.js
//  หรือ copy ทีละ query ไปวางใน mongosh / Mongo Express
// ============================================================

db = db.getSiblingDB('shop');

// [1] รีวิวทั้งหมด
print("\n[1] รีวิวทั้งหมด:");
printjson(db.reviews.find({}, { product_name: 1, customer: 1, rating: 1, _id: 0 }).toArray());

// [2] รีวิวที่ให้ 5 ดาว
print("\n[2] รีวิว 5 ดาว:");
printjson(db.reviews.find({ rating: 5 }, { product_name: 1, customer: 1, _id: 0 }).toArray());

// [3] คะแนนเฉลี่ย + จำนวนรีวิวต่อสินค้า
print("\n[3] คะแนนเฉลี่ยต่อสินค้า:");
printjson(db.reviews.aggregate([
  { $group: { _id: "$product_name", avg_rating: { $avg: "$rating" }, reviews: { $sum: 1 } } },
  { $sort: { avg_rating: -1 } }
]).toArray());

// [4] นับการใช้งานของแต่ละ tag
print("\n[4] จำนวนการใช้แต่ละ tag:");
printjson(db.reviews.aggregate([
  { $unwind: "$tags" },
  { $group: { _id: "$tags", count: { $sum: 1 } } },
  { $sort: { count: -1 } }
]).toArray());

// [5] top reviewer — ใครรีวิวเยอะสุด
print("\n[5] ผู้รีวิวมากที่สุด:");
printjson(db.reviews.aggregate([
  { $group: { _id: "$customer", reviews: { $sum: 1 }, avg_given: { $avg: "$rating" } } },
  { $sort: { reviews: -1 } }
]).toArray());

// [6] เข้าถึงข้อมูล nested — สินค้าที่แบตเกิน 20 ชั่วโมง
print("\n[6] สินค้าแบตเกิน 20 ชั่วโมง:");
printjson(db.product_catalog.find(
  { "specs.battery_hours": { $gt: 20 } },
  { name: 1, "specs.battery_hours": 1, _id: 0 }
).toArray());
