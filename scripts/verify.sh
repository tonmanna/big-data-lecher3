#!/usr/bin/env bash
# ============================================================
#  ตรวจว่าทุกบริการพร้อมใช้งาน และข้อมูลถูกโหลดครบ
#  วิธีใช้:  bash scripts/verify.sh   (หรือ  make verify)
# ============================================================
set -u

PG_USER="${POSTGRES_USER:-shopadmin}"
PG_DB="${POSTGRES_DB:-shop}"
MONGO_USER="${MONGO_USER:-shopadmin}"
MONGO_PASS="${MONGO_PASSWORD:-shop1234}"
ES_URL="${ES_URL:-http://localhost:9200}"

ok=0; fail=0
pass(){ echo "  ✅ $1"; ok=$((ok+1)); }
bad(){  echo "  ❌ $1"; fail=$((fail+1)); }

echo "🔎 ตรวจสอบ Big Data Workshop stack ..."
echo ""

# ---------- PostgreSQL ----------
echo "🐘 PostgreSQL"
if docker exec workshop-postgres pg_isready -U "$PG_USER" -d "$PG_DB" >/dev/null 2>&1; then
  pass "เชื่อมต่อได้"
  cnt=$(docker exec workshop-postgres psql -U "$PG_USER" -d "$PG_DB" -tAc "SELECT COUNT(*) FROM products;" 2>/dev/null)
  [ "${cnt:-0}" -ge 1 ] 2>/dev/null && pass "มีสินค้า $cnt รายการ" || bad "ยังไม่มีข้อมูลสินค้า (ลองรอ compose up ให้เสร็จ)"
else
  bad "เชื่อมต่อไม่ได้ — รัน 'make up' ก่อนไหม?"
fi
echo ""

# ---------- MongoDB ----------
echo "🍃 MongoDB"
mcnt=$(docker exec workshop-mongodb mongosh -u "$MONGO_USER" -p "$MONGO_PASS" --quiet \
        --eval "db.getSiblingDB('shop').reviews.countDocuments()" 2>/dev/null | tr -dc '0-9')
if [ -n "${mcnt:-}" ]; then
  pass "เชื่อมต่อได้"
  [ "$mcnt" -ge 1 ] && pass "มีรีวิว $mcnt รายการ" || bad "ยังไม่มีรีวิว"
else
  bad "เชื่อมต่อไม่ได้ — รัน 'make up' ก่อนไหม?"
fi
echo ""

# ---------- ElasticSearch ----------
echo "🔎 ElasticSearch"
if curl -s "$ES_URL/_cluster/health" | grep -q '"status"'; then
  pass "เชื่อมต่อได้"
  ecnt=$(curl -s "$ES_URL/products/_count" 2>/dev/null | grep -o '"count":[0-9]*' | cut -d: -f2)
  if [ -n "${ecnt:-}" ] && [ "$ecnt" -ge 1 ]; then
    pass "index 'products' มี $ecnt รายการ"
  else
    bad "ยังไม่มีข้อมูลใน index — รัน 'make load'"
  fi
else
  bad "เชื่อมต่อไม่ได้ — รัน 'make up' ก่อนไหม?"
fi

echo ""
echo "============================================"
if [ "$fail" -eq 0 ]; then
  echo "🎉 พร้อมแล้ว! ผ่าน $ok รายการ เริ่ม workshop ได้เลย"
  exit 0
else
  echo "⚠️  ผ่าน $ok / มีปัญหา $fail รายการ — ดูข้อความด้านบน"
  exit 1
fi
