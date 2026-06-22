// ============================================================
//  MongoDB Seed : รีวิวสินค้า + แคตตาล็อก (document model)
//  ไฟล์นี้รันอัตโนมัติตอน docker compose up ครั้งแรก
//
//  จุดสอน: ข้อมูลแบบ document เก็บโครงสร้างซ้อนกัน (nested) ได้
//          และแต่ละเอกสารมี field ไม่เท่ากันก็ได้ (schema-less)
// ============================================================

db = db.getSiblingDB('shop');

// ----- ล้างของเดิม (เผื่อรันซ้ำ) -----
db.reviews.drop();
db.product_catalog.drop();

// ----- รีวิวสินค้า : 1 เอกสาร = 1 รีวิว -----
db.reviews.insertMany([
  {
    product_id: 1,                     // อ้างอิงไปยัง products ใน PostgreSQL
    product_name: "Wireless Headphones",
    customer: "Somchai Jaidee",
    rating: 5,
    title: "เสียงดีมาก คุ้มราคา",
    comment: "ใช้มา 1 เดือน แบตอึด เสียงเบสแน่น แนะนำเลย",
    tags: ["audio", "bluetooth", "recommended"],
    verified_purchase: true,
    created_at: new Date("2026-05-08")
  },
  {
    product_id: 1,
    product_name: "Wireless Headphones",
    customer: "Ploy Wattana",
    rating: 4,
    title: "ดีแต่หูฟังบีบหัวนิด",
    comment: "เสียงโอเค แต่ใส่นานๆ แล้วเจ็บหู",
    tags: ["audio", "comfort"],
    verified_purchase: true,
    created_at: new Date("2026-05-19")
  },
  {
    product_id: 3,
    product_name: "Mechanical Keyboard",
    customer: "Anan Pongsak",
    rating: 5,
    title: "พิมพ์มันส์มาก",
    comment: "switch เสียงดี กดแล้วฟิน เหมาะกับสาย dev",
    tags: ["keyboard", "mechanical", "gaming"],
    verified_purchase: false,
    created_at: new Date("2026-05-21")
  },
  {
    product_id: 5,
    product_name: "The Pragmatic Programmer",
    customer: "Suda Rakdee",
    rating: 5,
    title: "หนังสือที่ dev ทุกคนควรอ่าน",
    comment: "อ่านแล้วเปลี่ยนวิธีคิดการเขียนโค้ดเลย",
    tags: ["book", "programming", "classic"],
    verified_purchase: true,
    created_at: new Date("2026-05-25")
  },
  {
    product_id: 12,
    product_name: "Running Shoes",
    customer: "Nicha Charoen",
    rating: 3,
    title: "พอใช้ได้",
    comment: "ใส่วิ่งโอเค แต่ไซส์เล็กกว่าปกติ ควรเผื่อไซส์",
    tags: ["shoes", "running"],
    verified_purchase: true,
    created_at: new Date("2026-06-03")
  },
  {
    product_id: 8,
    product_name: "Ceramic Coffee Mug",
    customer: "Malee Sukjai",
    rating: 4,
    title: "น่ารักดี",
    comment: "ลายสวย จับถนัดมือ แต่ปากแก้วบางไปนิด",
    tags: ["kitchen", "coffee"],
    verified_purchase: true,
    created_at: new Date("2026-05-30")
  }
]);

// ----- แคตตาล็อกสินค้า : โชว์ nested document + field ไม่เท่ากัน -----
db.product_catalog.insertMany([
  {
    product_id: 1,
    name: "Wireless Headphones",
    brand: "SoundMax",
    specs: {                            // nested object
      battery_hours: 30,
      bluetooth: "5.3",
      noise_cancelling: true,
      colors: ["black", "white", "blue"]
    },
    warranty_months: 12
  },
  {
    product_id: 3,
    name: "Mechanical Keyboard",
    brand: "KeyForge",
    specs: {
      switch_type: "Brown",
      layout: "TKL",
      backlight: "RGB",
      wireless: false
    },
    warranty_months: 24,
    bundle_includes: ["keycap puller", "extra switches"]   // field พิเศษ มีเฉพาะสินค้านี้
  },
  {
    product_id: 9,
    name: "Stainless Water Bottle",
    brand: "HydroLife",
    specs: {
      capacity_ml: 750,
      material: "stainless steel",
      keep_cold_hours: 24
    }
    // ไม่มี warranty_months ก็ได้ — document model ยืดหยุ่น
  }
]);

print("✅ MongoDB seed เสร็จแล้ว: reviews=" + db.reviews.countDocuments() +
      ", product_catalog=" + db.product_catalog.countDocuments());
