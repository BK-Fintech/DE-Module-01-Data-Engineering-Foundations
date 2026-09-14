# Bài tập về nhà - Buổi 4: Thiết kế & Xây dựng Sales Data Mart

**Hạn nộp:** Trước buổi 5

**Độ khó:** ⭐️⭐️⭐️ (Trung bình)

---

## Mục tiêu bài tập
- Hiểu quy trình thiết kế Data Mart từ OLTP
- Thực hành Star Schema với fact và dimension tables
- So sánh hiệu năng OLTP vs OLAP

---

## Phần 1: Bắt buộc (100%)

### 1.1 Mart Design - Xác định grain + DDL dimensions/fact (25%)

**Yêu cầu chi tiết:**
1. Viết 3-5 dòng xác định **grain** ngay đầu file SQL (comment): ví dụ `GRAIN: one row per order_item` - giải thích vì sao chọn grain này (để tính revenue theo product/category/ngày).
2. Viết DDL cho ít nhất 5 dimensions: `dim_date, dim_customer, dim_product, dim_payment_method, dim_order_status` (đúng 5 dims trong skeleton `04_data_mart.sql`).
3. Viết DDL `fact_sales` gồm: FK tới 5 dims + measures (`quantity, unit_price, revenue, discount`) + `order_id` degenerate dimension.
4. Ghi comment business logic + transformation cho mỗi bảng (lấy từ đâu, map thế nào).

**Kết quả cần đạt:** Đọc comment grain hiểu ngay 1 dòng fact = gì; 6 bảng `CREATE TABLE` đầy đủ PK/FK.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | DDL + comment grain + business logic | `sql/student/04_data_mart.sql` (đầu file có `-- GRAIN: ...`) |
| 2 | Ảnh sơ đồ star schema (vẽ tay/dbdiagram/DBeaver ERD) | `docs/evidence/04-star-schema.png` |

### 1.2 Mart Implementation - Chạy DDL + constraints (30%)

**Yêu cầu chi tiết:**
1. DDL dùng `CREATE TABLE IF NOT EXISTS`, dimension có PK (surrogate key `SERIAL` hoặc natural key - ghi lý do trong comment).
2. Fact có FK `REFERENCES` tới từng dim, data type tối ưu analytics (`DATE` cho ngày, `NUMERIC(12,2)` cho tiền).
3. Chạy toàn bộ DDL trên DB test, không lỗi.

**Kết quả cần đạt:** 6 bảng tạo thành công, `\d fact_sales` thấy đủ FK.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | File DDL (cùng file 1.1) | `sql/student/04_data_mart.sql` |
| 2 | Log tạo bảng thành công | `docs/evidence/04-ddl-log.txt` (6 dòng `CREATE TABLE`, không `ERROR`) |
| 3 | Ảnh `\d dim_date` + `\d fact_sales` (thấy PK/FK) | `docs/evidence/04-describe.png` |

### 1.3 Data Loading - Load từ OLTP + verify row counts (25%)

**Yêu cầu chi tiết:** Viết 5 câu load (INSERT INTO ... SELECT):
1. Load `dim_date` (generate_series dải ngày theo `MIN/MAX(order_date)` OLTP).
2. Load `dim_customer`, 3. `dim_product`, 4. `dim_payment_method` + `dim_order_status` từ OLTP.
5. Load `fact_sales` bằng JOIN OLTP (`orders → order_items → products → payments`).
6. Verify: `SELECT COUNT(*)` từng bảng + đối soát `SUM(fact.revenue)` vs `SUM(oltp orders.total_amount)` - chênh lệch phải giải thích (discount/rounding/chưa load).

**Kết quả cần đạt:** Mart có dữ liệu (fact > 0 rows), có bảng đối soát số liệu OLTP ↔ Mart.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Scripts load | Nối tiếp trong `sql/student/04_data_mart.sql` (`-- LOAD ...`) |
| 2 | Bảng row counts + đối soát revenue | `docs/evidence/04-rowcounts.txt` - mẫu: `dim_customer=120, fact_sales=1500, oltp_revenue=..., mart_revenue=..., diff=... vì ...` |

### 1.4 KPI Queries - 5 queries từ Mart (20%)

**Yêu cầu chi tiết:** Viết 5 queries **chỉ đọc từ mart** (`fact_sales JOIN dims`, không JOIN bảng OLTP):
1. Total revenue by month (`dim_date.month`).
2. Revenue by category (qua `dim_product.category`).
3. Top 10 products theo revenue.
4. AOV (`SUM(revenue)/COUNT(DISTINCT order_id)`).
5. Customer count by segment/region (nếu không có region: count by `dim_order_status` + ghi chú).

**Kết quả cần đạt:** 5 queries chạy trên mart, mỗi query có đáp án số.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | File 5 KPI queries | `sql/student/04_kpi_from_mart.sql` (file mới, comment `-- KPI1` ... `-- KPI5`) |
| 2 | Output + đáp án số | `docs/answers_04.md` (mỗi KPI: SQL + **Đáp án** + nhận xét 1 dòng) |

---

## Phần 2: Nâng cao (+20% Bonus)

### 2.1 Advanced Mart Design (Bonus 10%)

**Yêu cầu chi tiết:** Chọn 1 trong 2: (a) SCD Type 2 cho `dim_product` (thêm `valid_from/valid_to/is_current`) demo 1 sản phẩm đổi giá; hoặc (b) bảng tổng hợp `monthly_summary`, `category_summary`.

**Kết quả cần đạt:** DDL + 1 ví dụ insert/update chứng minh SCD/summary hoạt động.

**Minh chứng phải nộp:** File `sql/student/04_bonus_scd.sql` + output demo `docs/evidence/04-scd.txt`.

### 2.2 Performance Testing (Bonus 10%)

**Yêu cầu chi tiết:** Chạy cùng 1 KPI (ví dụ revenue by month) trên OLTP (nhiều JOIN) vs trên Mart (star join), đo bằng `EXPLAIN ANALYZE`, so sánh `Execution Time`. Thêm index cho cột `WHERE/JOIN` nếu cần.

**Kết quả cần đạt:** Kết luận mart nhanh hơn (hoặc giải thích khi data nhỏ chưa chênh), có số ms cụ thể.

**Minh chứng phải nộp:** File `docs/mart_performance/04-perf.md` (2 câu SQL + 2 output EXPLAIN + bảng so sánh ms + nhận xét).

---

## Deliverables - Tổng hợp nộp bài

| Task | File/Artifact phải có | Location |
|------|----------------------|----------|
| 1.1 Design | DDL + grain + sơ đồ star | `sql/student/04_data_mart.sql` + `docs/evidence/04-star-schema.png` |
| 1.2 Implementation | DDL log + describe | `docs/evidence/04-ddl-log.txt` + `04-describe.png` |
| 1.3 Loading | Scripts load + row counts/đối soát | cùng file SQL + `docs/evidence/04-rowcounts.txt` |
| 1.4 KPI | 5 queries mart + đáp án số | `sql/student/04_kpi_from_mart.sql` + `docs/answers_04.md` |
| Bonus | SCD/summary + perf | `sql/student/04_bonus_scd.sql` + `docs/mart_performance/04-perf.md` |

---

## Rubric (chấm theo minh chứng)

| Tiêu chí | Điểm | Yêu cầu = minh chứng |
|----------|------|---------|
| Mart Design | 25 | Có grain + đủ 5 dims/1 fact + sơ đồ; thiếu grain trừ 10 |
| Implementation | 30 | DDL chạy được + PK/FK đúng (ảnh describe); sai FK trừ 10 |
| Data Loading | 25 | Có load scripts + row counts + đối soát có giải thích diff |
| KPI Queries | 20 | 5 queries từ mart + đáp án số; query còn JOIN OLTP = 0 điểm câu đó |
| Bonus | +20% | Mỗi mục đạt = +10% |

---

## Tips
- Dimension tables thường ít thay đổi, nên có indexes
- Fact tables có thể rất lớn, nên partition nếu cần
- Date dimension rất quan trọng cho time-based analytics
