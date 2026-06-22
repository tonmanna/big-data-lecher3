#!/usr/bin/env bash
# ============================================================
#  ตรวจคุณภาพข้อมูล (data quality) ใน PostgreSQL
#  สอนแนวคิด: ระบบ data จริงต้องมีการตรวจว่าข้อมูล "สมเหตุสมผล"
#  วิธีใช้:  bash scripts/data_quality.sh   (หรือ  make quality)
# ============================================================
set -u
PG_USER="${POSTGRES_USER:-shopadmin}"
PG_DB="${POSTGRES_DB:-shop}"

q(){ docker exec workshop-postgres psql -U "$PG_USER" -d "$PG_DB" -tAc "$1" 2>/dev/null | tr -dc '0-9'; }

echo "🧪 ตรวจคุณภาพข้อมูลใน PostgreSQL ..."
echo ""

problems=0
check(){ # $1 = คำอธิบาย, $2 = จำนวนที่ผิด (0 = ผ่าน)
  if [ "${2:-0}" -eq 0 ] 2>/dev/null; then
    echo "  ✅ $1"
  else
    echo "  ⚠️  $1 — พบ $2 รายการ"
    problems=$((problems+1))
  fi
}

# 1) สินค้าที่สต็อกติดลบ (ไม่ควรมี)
check "ไม่มีสินค้าสต็อกติดลบ"            "$(q "SELECT COUNT(*) FROM products WHERE stock < 0;")"
# 2) สินค้าราคา <= 0 (ไม่ควรมี)
check "ไม่มีสินค้าราคา 0 หรือติดลบ"      "$(q "SELECT COUNT(*) FROM products WHERE price <= 0;")"
# 3) ออเดอร์ที่ไม่มีรายการสินค้าเลย
check "ทุกออเดอร์มีรายการสินค้าอย่างน้อย 1" "$(q "SELECT COUNT(*) FROM orders o WHERE NOT EXISTS (SELECT 1 FROM order_items oi WHERE oi.order_id = o.order_id);")"
# 4) order_items ที่อ้างถึงสินค้าที่ไม่มีอยู่
check "ไม่มี order_items ชี้ไปสินค้าที่ไม่มี" "$(q "SELECT COUNT(*) FROM order_items oi WHERE NOT EXISTS (SELECT 1 FROM products p WHERE p.product_id = oi.product_id);")"
# 5) ลูกค้าอีเมลซ้ำ (ควรไม่ซ้ำ)
check "อีเมลลูกค้าไม่ซ้ำกัน"             "$(q "SELECT COUNT(*) FROM (SELECT email FROM customers GROUP BY email HAVING COUNT(*) > 1) d;")"

echo ""
echo "============================================"
if [ "$problems" -eq 0 ]; then
  echo "🎉 ข้อมูลผ่านการตรวจทุกข้อ"
else
  echo "⚠️  พบปัญหา $problems จุด — ลองให้ Claude Code ช่วยหาสาเหตุและแก้ดู"
fi
