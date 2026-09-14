# AI-Native Data Engineering - Module 1: Data Engineering Foundation (8 buổi)
## 🚀 Getting Started

**Bắt đầu:**
1. **Đọc file hướng dẫn:** `HD01 - Hướng dẫn cài đặt phần mềm.md` - chi tiết từng bước setup cho Windows/macOS, Python, Docker, DBeaver
2. **Business case:** `docs/business_requirements.md` - hiểu về project E-commerce

**Sau khi setup xong:**
```bash
# Khởi động PostgreSQL
docker compose up -d postgres

# Tạo database và load seed data
./scripts/bootstrap.sh

# Kết nối DBeaver: localhost:5432, ecommerce/de_user/de_password
```
## Chuỗi học tập
Business Requirement → ERD → PostgreSQL OLTP → SQL Analytics → Sales Data Mart → Python File/API Ingestion → Data Cleaning & Quality → Incremental Load → Automated Daily Pipeline.

## Cấu trúc thư mục
- `docs/`: Student Lab Manual, business requirements, data contract, data dictionary.
- `data/`: seed, incremental và dirty datasets.
- `sql/student/`: nơi viết SQL Buổi 1-4.
- `starter/src/`: Python skeleton cho Buổi 5-8.
- `mock_api/`: REST API giả lập cho buổi 6-8.
- `labs/`: lab guide từng buổi.
- `assignments/`: bài tập sau buổi học và mini project.
- `tests/`: public test cases cho Data Quality.
- `scripts/`: bootstrap, reset, preflight macOS.

## 📋 Workflow theo buổi

**Buổi 1-4:**
- Đọc `labs/session_0X.md`
- Viết SQL trong `sql/student/`
- Test với DBeaver

**Buổi 5:**
```bash
cp -R starter/src src
```
- Đọc `labs/session_05.md`
- Hoàn thành Python skeleton code

**Buổi 6-8:**
```bash
docker compose up -d mock-api
```
- Đọc `labs/session_06_07_08.md`
- Implement data pipeline

**API mock:** `http://localhost:8000`, API key: `training-key`
