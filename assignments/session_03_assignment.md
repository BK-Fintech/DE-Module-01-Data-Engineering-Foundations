# Bài tập về nhà - Buổi 3: SQL Nâng cao - Customer Analytics & Cohort

**Hạn nộp:** Trước buổi 4

**Độ khó:** ⭐️⭐️⭐️ (Trung bình)

---

## Mục tiêu bài tập
- Thành thạo CTE và Window Functions
- Phân tích RFM (Recency, Frequency, Monetary)
- Thực hành Cohort Analysis

---

## Phần 1: Bắt buộc (100%)

### 1.1 CTE Refactoring - 5 queries CTE (25%)

**Yêu cầu chi tiết:** Viết 5 queries, mỗi query bắt buộc dùng `WITH ... AS`, comment `-- CTE1: ...`:
1. **CTE 1**: tính total spending mỗi customer trong CTE, ngoài filter top 10.
2. **CTE 2**: phân tầng Low (<500) / Medium (500-2000) / High (>2000) bằng `CASE WHEN` trên CTE.
3. **CTE 3**: dùng ≥2 CTEs lồng nhau (ví dụ: CTE orders_per_customer → CTE avg_orders) để đếm orders/customer.
4. **CTE 4**: tính AOV mỗi customer (`total_spending / order_count`).
5. **CTE 5**: retention đơn giản - CTE cohort (tháng order đầu) + CTE orders tháng sau, tính % quay lại.

**Kết quả cần đạt:** 5 queries chạy được, ít nhất 1 query có nested/multiple CTEs, không dùng subquery thay CTE để "lách".

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | File 5 queries CTE | `sql/student/03_cte_window_cohort.sql` (dòng `-- CTE1` ... `-- CTE5`) |
| 2 | Output mỗi query (5-10 dòng đầu + row count) | `docs/evidence/03-cte-results.txt` |

### 1.2 Window Functions - 5 queries (35%)

**Yêu cầu chi tiết:**
1. `ROW_NUMBER() OVER (ORDER BY total_spending DESC)`: rank customers.
2. `RANK()` vs `DENSE_RANK()`: top 3 customers - giải thích khác biệt gap trong comment (ví dụ đồng hạng thì RANK nhảy số).
3. `ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date)`: số thứ tự order của mỗi customer.
4. `LAG()/LEAD()`: so sánh `total_amount` với order trước/sau của cùng customer + cột chênh lệch.
5. `SUM(total_amount) OVER (ORDER BY order_date)`: running total cumulative revenue.

**Kết quả cần đạt:** Đủ 5 hàm/window khác nhau, `PARTITION BY`/`ORDER BY` trong `OVER()` đúng, comment giải thích RANK vs DENSE_RANK.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | File queries (comment `-- W1` ... `-- W5`) | Nối tiếp trong `sql/student/03_cte_window_cohort.sql` |
| 2 | Output 5 queries | `docs/evidence/03-window-results.txt` (mỗi query 5 dòng đầu) |

### 1.3 Customer Analytics - RFM 3 metrics trong 1 bảng (20%)

**Yêu cầu chi tiết:** Viết 1 query tổng hợp ra bảng `customer_id, recency_days, frequency, monetary`:
- **Recency**: `NOW() - MAX(order_date)` (số ngày từ order cuối tới hiện tại).
- **Frequency**: `COUNT(order_id)`.
- **Monetary**: `SUM(total_amount)`.
- Dùng CTE hoặc subquery để tính rồi JOIN 3 metrics lại (hoặc 1 GROUP BY duy nhất - giải thích cách chọn trong comment).

**Kết quả cần đạt:** 1 bảng RFM đủ 4 cột, không NULL ở `frequency/monetary`, `recency_days >= 0`.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Query RFM | Trong `sql/student/03_cte_window_cohort.sql` (`-- RFM`) |
| 2 | File CSV kết quả (ít nhất 20 dòng đầu + header) | `docs/customer_rfm.csv` |

### 1.4 Cohort Analysis - Retention theo tháng (20%)

**Yêu cầu chi tiết:**
1. Xác định cohort = tháng của order đầu tiên (`DATE_TRUNC('month', MIN(order_date))` per customer).
2. Tính retention: % customers của cohort còn mua ở tháng 1, 2, 3 sau đó.
3. Trực quan hóa: vẽ bảng retention bằng Excel/Google Sheets (heatmap) hoặc chấp nhận bảng CSV có định dạng rõ.

**Kết quả cần đạt:** Bảng retention với hàng = cohort tháng, cột = tháng sau (M0, M1, M2...), giá trị = %.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Query cohort | Trong `sql/student/03_cte_window_cohort.sql` (`-- Cohort`) |
| 2 | File CSV retention | `docs/cohort_retention.csv` (header: `cohort_month,m0,m1,m2,...`) |
| 3 | Ảnh heatmap/bảng (chụp từ Sheets/Excel) | `docs/evidence/03-cohort.png` |
| 4 | Reflection 5-8 dòng: cohort nào giữ chân tốt nhất, vì sao? | `docs/reflection_03.md` |

---

## Phần 2: Nâng cao (+20% Bonus)

### 2.1 Advanced Customer Segmentation (Bonus 10%)

**Yêu cầu chi tiết:** Phân loại RFM buckets (ví dụ score 1-5 cho từng R/F/M → 125 segments) + tính LTV đơn giản (`monetary` hoặc `AOV × frequency`).

**Kết quả cần đạt:** Thêm cột `rfm_segment` (ví dụ `555`, `111`) cho ≥20 customers mẫu.

**Minh chứng phải nộp:** Query bổ sung (`-- Bonus RFM`) trong file SQL + CSV mẫu `docs/evidence/03-rfm-segments.csv` (20 dòng).

### 2.2 Time Series Analysis (Bonus 10%)

**Yêu cầu chi tiết:** Tính MoM growth (`(this-prev)/prev`), YoY (nếu có data), moving average 7-day/30-day của revenue.

**Kết quả cần đạt:** 3 cột tính được, giải thích 2-3 dòng tháng tăng/giảm mạnh nhất.

**Minh chứng phải nộp:** Query (`-- Bonus timeseries`) + output `docs/evidence/03-timeseries.txt`.

---

## Deliverables - Tổng hợp nộp bài

| Task | File/Artifact phải có | Location |
|------|----------------------|----------|
| 1.1 CTE | 5 queries + output | `sql/student/03_cte_window_cohort.sql` + `docs/evidence/03-cte-results.txt` |
| 1.2 Window | 5 queries + output | cùng file SQL + `docs/evidence/03-window-results.txt` |
| 1.3 RFM | Query + CSV | cùng file SQL + `docs/customer_rfm.csv` |
| 1.4 Cohort | Query + CSV + ảnh heatmap + reflection | cùng file SQL + `docs/cohort_retention.csv` + `docs/evidence/03-cohort.png` + `docs/reflection_03.md` |
| Bonus | Queries + outputs | cùng file SQL + `docs/evidence/03-rfm-segments.csv`, `03-timeseries.txt` |

> Lưu ý sửa đường dẫn: bản cũ ghi `sql/solutions/...` (thư mục đáp án giảng viên) - học viên nộp vào `sql/student/...` như trên.

---

## Rubric (chấm theo minh chứng)

| Tiêu chí | Điểm | Yêu cầu = minh chứng |
|----------|------|---------|
| CTE | 25 | Đủ 5 queries + output; có ≥1 nested CTE, thiếu output trừ 50% |
| Window Functions | 35 | Đủ 5 hàm khác nhau + giải thích RANK/DENSE_RANK |
| RFM Analytics | 20 | CSV đủ 4 cột + không NULL sai |
| Cohort Analysis | 20 | CSV retention + ảnh heatmap + reflection |
| Bonus | +20% | Mỗi mục đạt = +10% |

---

## Tips
- Dùng `PARTITION BY customer_id` khi cần rank per customer
- Window functions cần ORDER BY trong OVER() clause
- RFM có thể cần CASE WHEN để categorize buckets
