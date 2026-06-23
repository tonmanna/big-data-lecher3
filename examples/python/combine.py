#!/usr/bin/env python3
# ============================================================
#  ตัวอย่าง: เชื่อมข้อมูลจากทั้ง 3 ฐานข้อมูลมารวมกัน
#
#  เรื่องราว: เราอยากได้ "รายงานสินค้า" ที่รวม
#    - ยอดขาย + สต็อก   จาก PostgreSQL
#    - คะแนนรีวิวเฉลี่ย  จาก MongoDB
#    - จำนวนผลค้นหา      จาก ElasticSearch
#  โดยใช้ product_id เป็นกุญแจเชื่อมข้อมูลข้ามระบบ
#
#  วิธีรัน (ดู README ในโฟลเดอร์นี้):
#    pip install -r requirements.txt
#    python combine.py
# ============================================================
import os
import sys

import psycopg2          # ต่อ PostgreSQL
from pymongo import MongoClient   # ต่อ MongoDB
import requests          # เรียก ElasticSearch ผ่าน REST API

# ----- ค่าเชื่อมต่อ (อ่านจาก env ได้ ถ้าไม่มีใช้ค่า default ของ workshop) -----
PG  = dict(host="localhost", port=5432, dbname=os.getenv("POSTGRES_DB", "shop"),
           user=os.getenv("POSTGRES_USER", "shopadmin"),
           password=os.getenv("POSTGRES_PASSWORD", "shop1234"))
MONGO_URI = f"mongodb://{os.getenv('MONGO_USER','shopadmin')}:" \
            f"{os.getenv('MONGO_PASSWORD','shop1234')}@localhost:27017/"
ES_URL = os.getenv("ES_URL", "http://localhost:9200")


def get_products_from_postgres():
    """ดึงสินค้า + ยอดขายรวม + สต็อก จาก PostgreSQL"""
    conn = psycopg2.connect(**PG)
    cur = conn.cursor()
    # ยอดขายรวม = ผลรวมของ (จำนวน × ราคา) เฉพาะออเดอร์ที่ไม่ถูกยกเลิก
    cur.execute("""
        SELECT p.product_id, p.name, p.stock,
               COALESCE(SUM(oi.quantity * oi.unit_price)
                        FILTER (WHERE o.status <> 'cancelled'), 0) AS revenue
        FROM products p
        LEFT JOIN order_items oi ON p.product_id = oi.product_id
        LEFT JOIN orders o       ON oi.order_id = o.order_id
        GROUP BY p.product_id, p.name, p.stock
        ORDER BY revenue DESC;
    """)
    rows = [
        {"product_id": r[0], "name": r[1], "stock": r[2], "revenue": float(r[3])}
        for r in cur.fetchall()
    ]
    cur.close(); conn.close()
    return rows


def get_avg_ratings_from_mongo():
    """ดึงคะแนนรีวิวเฉลี่ยต่อสินค้า จาก MongoDB -> dict {product_id: avg}"""
    client = MongoClient(MONGO_URI)
    reviews = client["shop"]["reviews"]
    result = reviews.aggregate([
        {"$group": {"_id": "$product_id", "avg": {"$avg": "$rating"}, "n": {"$sum": 1}}}
    ])
    ratings = {doc["_id"]: (round(doc["avg"], 1), doc["n"]) for doc in result}
    client.close()
    return ratings


def search_hits_in_elastic(keyword):
    """นับว่าค้นคำนี้ใน ElasticSearch แล้วเจอกี่รายการ"""
    try:
        resp = requests.get(
            f"{ES_URL}/products/_search",
            json={"query": {"multi_match": {"query": keyword,
                                            "fields": ["name", "description"]}}},
            timeout=5,
        )
        return resp.json().get("hits", {}).get("total", {}).get("value", 0)
    except requests.RequestException:
        return None


def main():
    print("📊 กำลังรวมข้อมูลจาก 3 ฐานข้อมูล ...\n")
    try:
        products = get_products_from_postgres()
        ratings = get_avg_ratings_from_mongo()
    except Exception as e:
        print(f"❌ เชื่อมต่อฐานข้อมูลไม่ได้: {e}")
        print("   ลองรัน 'make up' และ 'make load' ให้ stack พร้อมก่อนนะ")
        sys.exit(1)

    # ----- หัวตาราง -----
    print(f"{'สินค้า':<34}{'ยอดขาย':>12}{'สต็อก':>8}{'คะแนน':>9}{'รีวิว':>7}")
    print("-" * 70)

    for p in products:
        avg, n = ratings.get(p["product_id"], (None, 0))
        star = f"{avg}★" if avg is not None else "—"
        print(f"{p['name'][:32]:<34}{p['revenue']:>12,.0f}{p['stock']:>8}{star:>9}{n:>7}")

    # ----- ตัวอย่างใช้ ElasticSearch เสริม -----
    print("\n🔎 ตัวอย่างค้นหาใน ElasticSearch:")
    for kw in ["wireless", "book", "kitchen"]:
        hits = search_hits_in_elastic(kw)
        shown = f"{hits} รายการ" if hits is not None else "(ES ไม่พร้อม — รัน make load?)"
        print(f"   ค้น '{kw}'  →  {shown}")

    print("\n✅ เสร็จแล้ว! นี่คือพลังของการใช้หลายฐานข้อมูลร่วมกัน")


if __name__ == "__main__":
    main()
