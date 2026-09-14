# Bài tập về nhà - Buổi 1: Thiết kế Database & Khởi động Hệ thống

**Hạn nộp:** Trước buổi 2

**Độ khó:** ⭐️ (Cơ bản)

---

## Mục tiêu bài tập
- Hiểu và thực hành quy trình tạo database từ requirement đến schema
- Làm quen với Docker, PostgreSQL, DBeaver, Git
- Xây dựng thói quen commit và documentation

---

## Phần 1: Bắt buộc (100%)

### 1.1 Environment Setup - Khởi động PostgreSQL + kết nối DBeaver (20%)

**Yêu cầu chi tiết:**
1. Khởi động PostgreSQL bằng Docker Compose từ file `docker-compose.yml` của repo (`postgres:16`, port `5432`, user `de_user`).
2. Kết nối từ DBeaver với thông số: Host `localhost`, Port `5432`, Database `ecommerce`, User `de_user` / Password `de_password`.
3. Chạy 2 câu kiểm tra và xác nhận database active:
  ```sql
  SELECT version();
  SELECT current_database();
  ```
4. Commit `docker-compose.yml` (nếu có chỉnh sửa) với message rõ ràng.

**Kết quả cần đạt (Done):**
- `docker compose ps` báo container `ecommerce-postgres` ở trạng thái `running (healthy)` hoặc `Up`.
- DBeaver hiện trạng thái `Connected`, mở được cây database `ecommerce`.
- 2 câu SQL trên chạy thành công, `current_database()` trả về `ecommerce`.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn / vị trí | Ví dụ đạt |
|---|---|---|---|
| 1 | Ảnh terminal `docker compose ps` thấy container running | `docs/evidence/01-docker-ps.png` | Cột State = `running` |
| 2 | Ảnh DBeaver kết nối thành công (thấy database `ecommerce`) | `docs/evidence/01-dbeaver.png` | Icon kết nối xanh, không báo lỗi |
| 3 | Output 2 câu SQL (copy text hoặc screenshot) | `docs/evidence/01-verify-db.txt` hoặc `.png` | `PostgreSQL 16.x ...`, `ecommerce` |

### 1.2 Schema Design - Vẽ ERD và xuất SQL (30%)

**Yêu cầu chi tiết:**
1. Đọc `docs/business_requirements.md` + `database/ecommerce_oltp.dbml` (tham khảo) rồi tự vẽ ERD tại dbdiagram.io gồm ít nhất 7 bảng: `customers, products, orders, order_items, payments, categories, order_status` (cho phép đặt tên tương đương nếu có lý do).
2. Xác định cho mỗi bảng: Primary Key, Foreign Key, các trường bắt buộc `NOT NULL`.
3. Chọn data type phù hợp: tiền tệ dùng `DECIMAL/NUMERIC`, thời gian dùng `DATE/TIMESTAMP`, ID dùng `SERIAL/INT`, không dùng `VARCHAR` cho số tiền/ngày.
4. Export DDL và lưu vào `sql/student/01_create_oltp.sql`, file chạy được trên PostgreSQL 16 (dùng `CREATE TABLE IF NOT EXISTS`).

**Kết quả cần đạt (Done):**
- ERD thể hiện đủ 7 bảng + quan hệ 1:N (vẽ đường nối FK rõ ràng).
- File `01_create_oltp.sql` chạy không lỗi trên DB trống, tạo đủ bảng.
- Mỗi bảng có PK; các bảng con (`orders`, `order_items`, `payments`) có FK đúng; trường bắt buộc có `NOT NULL`.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn / vị trí | Ví dụ đạt |
|---|------------|-------------------|-----------|
| 1 | Ảnh ERD export từ dbdiagram.io | `docs/evidence/01-erd.png` + link dbdiagram trong file | Thấy 7 bảng + đường quan hệ |
| 2 | File DDL hoàn chỉnh | `sql/student/01_create_oltp.sql` | Mở file thấy `CREATE TABLE customers ... PRIMARY KEY`, `REFERENCES` |
| 3 | Log chạy DDL thành công (`psql -f` hoặc DBeaver script log) | `docs/evidence/01-ddl-log.txt` hoặc `.png` | `CREATE TABLE` x7, không báo `ERROR` |

### 1.3 Git Workflow - Repo, .gitignore, commit chuẩn (20%)

**Yêu cầu chi tiết:**
1. Khởi tạo repo Git nếu chưa có, đảm bảo cấu trúc thư mục của khóa học còn nguyên.
2. Tạo `.gitignore` phù hợp Python/PostgreSQL, tối thiểu gồm: `.env`, `logs/`, `*.pyc`, `__pycache__/`, `.venv/`, `data/raw/`, `data/reject/`.
3. Commit lần đầu với message đúng quy định: `session-01: initial schema design`. Push lên GitHub.

**Kết quả cần đạt (Done):**
- Repo GitHub public (hoặc đã share) chứa đủ `docker-compose.yml`, `sql/student/01_create_oltp.sql`, `.gitignore`.
- `git log --oneline` thấy commit message đúng chuẩn.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn / vị trí | Ví dụ đạt |
|---|------------|-------------------|-----------|
| 1 | Link repo GitHub + ảnh `git log --oneline` | Nộp link trong LMS + `docs/evidence/01-git-log.png` | Thấy dòng `session-01: initial schema design` |
| 2 | File `.gitignore` | Root repo `/.gitignore` | Mở file thấy đủ các dòng yêu cầu |

### 1.4 Reflection - Viết chiêm nghiệm 150-200 từ (30%)

**Yêu cầu chi tiết:** Viết 150-200 từ (tiếng Việt hoặc Anh) trả lời đủ 4 câu:
1. Khó khăn khi cài Docker/DBeaver và cách bạn xử lý?
2. Vì sao chọn data type như vậy cho tiền tệ / thời gian / ID? Cho 1 ví dụ cụ thể.
3. Hiểu thế nào về quan hệ 1:N giữa `customers` và `orders`? Vẽ/kể ví dụ 1 customer có N orders.
4. Nếu schema cần sửa sau này (thêm cột, đổi FK), bạn sẽ xử lý thế nào (ALTER vs tạo lại)?

**Kết quả cần đạt (Done):**
- Đủ 150-200 từ, trả lời cả 4 câu, có ít nhất 1 ví dụ cụ thể (lỗi gặp, data type, quan hệ).

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn / vị trí |
|---|------------|-------------------|
| 1 | File reflection | `docs/reflection_01.md` (hoặc mục Reflection trong `README.md` của repo, ghi rõ đường dẫn khi nộp) |

---

## Phần 2: Nâng cao (+20% Bonus)

### 2.1 Advanced Schema (Bonus 10%)

**Yêu cầu chi tiết:**
1. Thêm `CHECK` constraints cho quy tắc business, ví dụ: `order_date` không ở tương lai, `total_amount >= 0`, `quantity > 0`.
  ```sql
  ALTER TABLE orders ADD CONSTRAINT check_order_date
    CHECK (order_date IS NULL OR order_date <= NOW());
  ```
2. Thêm `DEFAULT` cho audit fields: `created_at DEFAULT NOW()`, `updated_at DEFAULT NOW()`.

**Kết quả cần đạt:** Ít nhất 2 `CHECK` + `DEFAULT` cho các bảng chính, chạy không lỗi.

**Minh chứng phải nộp:** Đoạn SQL bổ sung đặt cuối `sql/student/01_create_oltp.sql` (comment `-- Session 01 Bonus`) + ảnh/log test insert vi phạm bị chặn (ví dụ insert amount âm báo `violates check constraint`).

### 2.2 Documentation (Bonus 10%)

**Yêu cầu chi tiết:**
1. Viết `sql/README.md` hướng dẫn chạy scripts theo thứ tự (tạo DB → chạy `01_create_oltp.sql` → verify).
2. Ghi chú quan hệ giữa các bảng (bảng cha-con, ý nghĩa FK) ngay trong file SQL bằng comment.

**Kết quả cần đạt:** Người mới đọc `sql/README.md` chạy được DDL trong < 5 phút mà không cần hỏi thêm.

**Minh chứng phải nộp:** File `sql/README.md` + comment quan hệ trong `01_create_oltp.sql`.

---

## Deliverables - Tổng hợp nộp bài (GitHub + LMS theo quy định)

| Task | File/Artifact phải có | Location trong repo |
|------|----------------------|---------------------|
| 1.1 Setup | Ảnh `docker ps`, ảnh DBeaver, output verify SQL | `docs/evidence/01-docker-ps.png`, `01-dbeaver.png`, `01-verify-db.txt` |
| 1.2 Schema | Ảnh ERD + DDL + log chạy DDL | `docs/evidence/01-erd.png`, `sql/student/01_create_oltp.sql`, `docs/evidence/01-ddl-log.txt` |
| 1.3 Git | Repo + `.gitignore` + git log | Root repo + link GitHub nộp qua LMS |
| 1.4 Reflection | Bài viết 150-200 từ | `docs/reflection_01.md` |
| Bonus | CHECK/DEFAULT + `sql/README.md` | Trong `01_create_oltp.sql` + `sql/README.md` |

---

## Rubric (giảng viên chấm theo minh chứng)

| Tiêu chí | Điểm | Yêu cầu = minh chứng |
|----------|------|---------|
| Setup thành công | 20 | Có 3 ảnh/log 1.1; thiếu 1 minh chứng trừ 7 điểm |
| Schema completeness | 30 | Đủ 7 bảng + PK/FK/NOT NULL + DDL chạy được; sai FK trừ 10, sai type trừ 5 |
| Git workflow | 20 | Có repo + `.gitignore` đủ dòng + commit message đúng |
| Reflection quality | 30 | Đủ 4 câu + 150-200 từ + có ví dụ cụ thể |
| Bonus | +20% | Mỗi mục 2.1/2.2 đạt = +10% |

---

## Tips
- Nếu Docker không chạy: `brew services list` để kiểm tra
- Nếu DBeaver không kết nối: kiểm tra port 5432 có đang bị chiếm (`lsof -i :5432`), thử restart container `docker compose restart postgres`
- Luôn `docker compose ps` để confirm container running trước khi kết nối
