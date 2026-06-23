# ============================================================
#  Big Data Workshop — คำสั่งลัด
#  พิมพ์  make help  เพื่อดูคำสั่งทั้งหมด
# ============================================================

.DEFAULT_GOAL := help
.PHONY: help up down reset load status verify quality psql mongosh logs combine

help: ## แสดงคำสั่งทั้งหมด
	@echo "Big Data Workshop — คำสั่งที่ใช้บ่อย:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

up: ## เปิดทั้ง stack (Postgres + Mongo + Elastic + UI)
	@test -f .env || cp .env.example .env
	docker compose up -d

down: ## ปิด stack (ข้อมูลยังอยู่)
	docker compose down

reset: ## ลบทุกอย่างแล้วเริ่มใหม่สะอาดๆ
	docker compose down -v
	$(MAKE) up

load: ## โหลดข้อมูลสินค้าเข้า ElasticSearch
	bash data/seed/elasticsearch/load.sh

status: ## ดูสถานะ container ทั้งหมด
	docker compose ps

verify: ## ตรวจว่าทุกบริการพร้อมและข้อมูลครบ
	bash scripts/verify.sh

quality: ## รันตรวจคุณภาพข้อมูล (data quality)
	bash scripts/data_quality.sh

combine: ## รันตัวอย่าง Python รวมข้อมูล 3 ฐานข้อมูล
	pip install -q -r examples/python/requirements.txt && python examples/python/combine.py

psql: ## เข้า psql ของ PostgreSQL
	docker exec -it workshop-postgres psql -U shopadmin -d shop

mongosh: ## เข้า mongosh ของ MongoDB
	docker exec -it workshop-mongodb mongosh -u shopadmin -p shop1234

logs: ## ดู log ทุกบริการ (Ctrl+C เพื่อออก)
	docker compose logs -f
