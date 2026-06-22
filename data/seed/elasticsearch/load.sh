#!/usr/bin/env bash
# ============================================================
#  โหลดข้อมูลสินค้าเข้า ElasticSearch
#  วิธีใช้:  bash data/seed/elasticsearch/load.sh
# ============================================================
set -e

ES_URL="${ES_URL:-http://localhost:9200}"
INDEX="products"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "⏳ รอ ElasticSearch ที่ $ES_URL ..."
until curl -s "$ES_URL/_cluster/health" | grep -q '"status"'; do
  sleep 2
done
echo "✅ ElasticSearch พร้อมแล้ว"

# ----- ลบ index เดิม (ถ้ามี) -----
curl -s -X DELETE "$ES_URL/$INDEX" > /dev/null || true

# ----- สร้าง index พร้อม mapping -----
echo "📐 สร้าง index '$INDEX' พร้อม mapping ..."
curl -s -X PUT "$ES_URL/$INDEX" -H 'Content-Type: application/json' -d '{
  "mappings": {
    "properties": {
      "product_id": { "type": "integer" },
      "name":       { "type": "text" },
      "category":   { "type": "keyword" },
      "brand":      { "type": "keyword" },
      "price":      { "type": "float" },
      "description":{ "type": "text" },
      "tags":       { "type": "keyword" }
    }
  }
}' > /dev/null

# ----- โหลดข้อมูลแบบ bulk -----
echo "📦 โหลดข้อมูลสินค้า ..."
curl -s -X POST "$ES_URL/$INDEX/_bulk" \
  -H 'Content-Type: application/x-ndjson' \
  --data-binary "@$SCRIPT_DIR/products.ndjson" > /dev/null

# ----- รอ refresh แล้วนับ -----
curl -s -X POST "$ES_URL/$INDEX/_refresh" > /dev/null
COUNT=$(curl -s "$ES_URL/$INDEX/_count" | grep -o '"count":[0-9]*' | cut -d: -f2)
echo "🎉 เสร็จแล้ว! โหลดสินค้าเข้า index '$INDEX' จำนวน $COUNT รายการ"
