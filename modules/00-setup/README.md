# โมดูล 0 — เตรียมเครื่องให้พร้อม

ก่อนเริ่ม workshop เราต้องมีเครื่องมือ 2 อย่างนี้

## 1) Docker Desktop
ตัวรันฐานข้อมูลทั้งหมดให้เรา โดยไม่ต้องลงทีละตัว

- ดาวน์โหลด: https://www.docker.com/products/docker-desktop/
- ติดตั้งแล้วเปิดโปรแกรม รอจนไอคอนขึ้นว่า "running"
- เช็คว่าใช้ได้:
  ```bash
  docker --version
  docker compose version
  ```

## 2) Claude Code
ผู้ช่วย AI ของเราตลอด workshop

- ติดตั้งตามคู่มือ: https://code.claude.com/docs
- เปิดในโฟลเดอร์ของ workshop นี้:
  ```bash
  cd big-data-lecher3
  claude
  ```

## ✅ เช็คความพร้อม
- [ ] `docker compose version` ทำงานได้
- [ ] Docker Desktop เปิดอยู่
- [ ] เปิด Claude Code ในโฟลเดอร์ workshop ได้

## 🤖 ลองคุยกับ Claude Code
> *"ช่วยอธิบายว่า repo นี้ทำอะไร และมีฐานข้อมูลอะไรบ้าง"*

Claude จะอ่าน `CLAUDE.md` แล้วสรุปให้ฟัง ➡️ ไปต่อ [โมดูล 1](../01-docker/README.md)
