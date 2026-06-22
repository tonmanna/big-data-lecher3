# โมดูล 4 — ElasticSearch (เครื่องมือค้นหา)

## 🎯 เป้าหมาย
- เข้าใจว่า search engine ต่างจากฐานข้อมูลทั่วไปยังไง
- ค้นหาสินค้าแบบ full-text และกรองผลลัพธ์ได้

## 💡 ทำไมต้องมี ElasticSearch?
ลองนึกถึงช่องค้นหาในเว็บช้อปปิ้ง — พิมพ์ "หูฟัง ไร้สาย" แล้วเจอสินค้าที่เกี่ยวข้องเรียงตามความตรง
นี่คือสิ่งที่ SQL `LIKE '%...%'` ทำได้ไม่ดี แต่ ElasticSearch เก่งมาก (เร็ว + จัดอันดับความเกี่ยวข้องให้)

## 🛠️ โหลดข้อมูลก่อน
```bash
bash data/seed/elasticsearch/load.sh
```
ข้อมูลมาจาก [`data/seed/elasticsearch/products.ndjson`](../../data/seed/elasticsearch/products.ndjson)

## 📝 ลองค้นหา (ใช้ curl หรือ Kibana Dev Tools ที่ http://localhost:5601)

```bash
# 1) นับจำนวนสินค้าใน index
curl "localhost:9200/products/_count"

# 2) ค้นหา full-text คำว่า "ไร้สาย"
curl -X GET "localhost:9200/products/_search" -H 'Content-Type: application/json' -d '{
  "query": { "match": { "description": "ไร้สาย" } }
}'

# 3) ค้นหา + กรองหมวด + ช่วงราคา
curl -X GET "localhost:9200/products/_search" -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "must":   { "match": { "name": "keyboard" } },
      "filter": [
        { "term":  { "category": "Electronics" } },
        { "range": { "price": { "lte": 3000 } } }
      ]
    }
  }
}'

# 4) จัดกลุ่มนับสินค้าต่อหมวด (aggregation)
curl -X GET "localhost:9200/products/_search" -H 'Content-Type: application/json' -d '{
  "size": 0,
  "aggs": { "by_category": { "terms": { "field": "category" } } }
}'
```

> 💡 ใน Kibana → เมนู **Dev Tools** เขียน query ได้สวยกว่า curl (ไม่ต้องใส่ curl/headers)

## 🤖 ลองกับ Claude Code
> *"เขียน ElasticSearch query หาหนังสือ (category Books) ที่มีคำว่า data ในชื่อหรือคำอธิบาย"*

> *"อธิบายความต่างของ match กับ term ใน ElasticSearch"*

## ✅ เช็ค
- [ ] โหลดข้อมูล 15 รายการเข้า index `products` ได้
- [ ] ค้นหา full-text และกรองผลได้

➡️ [โมดูล 5 — เปรียบเทียบ 3 ฐานข้อมูล](../05-compare/README.md)
