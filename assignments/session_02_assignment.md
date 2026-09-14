# Bài tập về nhà - Buổi 2: SQL Fundamentals & Business Analytics

**Hạn nộp:** Trước buổi 3

**Độ khó:** ⭐️⭐️ (Cơ bản đến Trung bình)

---

## Mục tiêu bài tập
- Thành thạo SELECT, WHERE, GROUP BY, JOIN
- Giải quyết 10+ business questions thực tế
- Rèn luyện kỹ năng đối soát kết quả

---

## Phần 1: Bắt buộc (100%)

### 1.1 Basic Queries - 5 queries SELECT/WHERE/ORDER BY (20%)

**Yêu cầu chi tiết:** Viết 5 queries trong `sql/student/02_exercises_basic.sql`, mỗi query có comment `-- Q1: ...` mô tả mục đích:
1. **Q1 - SELECT with filtering**: tất cả orders có `total_amount > 100`.
2. **Q2 - NULL handling**: customers chưa có order nào (`LEFT JOIN orders ... WHERE orders.id IS NULL`).
3. **Q3 - ORDER BY**: top 10 customers theo tổng chi tiêu (tính từ bảng `orders`).
4. **Q4 - COUNT/DISTINCT**: đếm số customers khác nhau có đơn hàng (`COUNT(DISTINCT customer_id)`).
5. **Q5 - LIMIT**: 5 orders mới nhất theo `order_date` (`ORDER BY order_date DESC LIMIT 5`).
- Gợi ý: luôn test với `LIMIT 10` trước, đối soát với `data/seed/`.

**Kết quả cần đạt (Done):** 5 queries chạy không lỗi trên DB seed, trả về đúng logic (có `WHERE`/`JOIN`/`ORDER BY`/`LIMIT` tương ứng).

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | File 5 queries có comment | `sql/student/02_exercises_basic.sql` |
| 2 | Output mỗi query (copy kết quả hoặc screenshot, ít nhất 3-5 dòng đầu + row count) | `docs/evidence/02-basic-results.txt` hoặc 5 ảnh `02-q1.png` ... `02-q5.png` |

### 1.2 Aggregate & Grouping - 5 queries GROUP BY/HAVING (30%)

**Yêu cầu chi tiết:** Viết tiếp trong `sql/student/02_exercises_basic.sql` (hoặc file `02b_aggregate.sql` nếu muốn tách, ghi rõ trong nộp bài):
1. Tổng doanh thu theo từng tháng (`EXTRACT(MONTH FROM order_date)` hoặc `DATE_TRUNC('month', ...)`).
2. Trung bình giá trị đơn hàng theo từng customer (`AVG(total_amount) GROUP BY customer_id`).
3. Số lượng đơn hàng theo từng `order_status`.
4. Tổng doanh thu theo `category` (JOIN `order_items → products → categories`).
5. `HAVING`: categories có tổng doanh thu > 1000.

**Kết quả cần đạt:** Đủ 5 queries, dùng đúng `GROUP BY` + hàm tổng hợp (`SUM/AVG/COUNT`), Q5 có `HAVING`.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | File queries | `sql/student/02_exercises_basic.sql` (ghi chú dòng bắt đầu Q6-Q10) |
| 2 | Output tổng hợp (ít nhất bảng tháng-doanh thu + bảng category-doanh thu) | `docs/query_results.csv` (tối thiểu 2 bảng) + `docs/evidence/02-agg-results.txt` |

### 1.3 JOIN Operations - 5 queries JOIN (30%)

**Yêu cầu chi tiết:** Viết 5 queries:
1. Liệt kê orders kèm `customer_name`, `customer_email` (`orders JOIN customers`).
2. Chi tiết từng `order_item` kèm `product_name`, `price` (`order_items JOIN products`).
3. Orders có `payments` nhưng chưa có `order_items` (hoặc ngược lại) - dùng `LEFT JOIN + IS NULL` 1 phía.
4. Products chưa từng được bán (`products LEFT JOIN order_items ... WHERE order_items.id IS NULL`).
5. Đối soát: total order value = `SUM(order_items quantity*price)` theo từng order (`GROUP BY order_id`), so với `orders.total_amount`.

**Kết quả cần đạt:** Dùng đúng loại JOIN, Q3-Q4 bắt buộc `LEFT JOIN + IS NULL`, Q5 có chênh lệch giải thích được (làm tròn/discount).

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | File queries (comment Q11-Q15) | `sql/student/02_exercises_basic.sql` |
| 2 | Output Q5 đối soát (10 dòng đầu + nhận xét chênh lệch) | `docs/evidence/02-join-q5.txt` (ghi `MATCH` hoặc `DIFF vì ...`) |

### 1.4 Business Questions - Trả lời 5 câu hỏi bằng số + SQL (20%)

**Yêu cầu chi tiết:** Trả lời 5 câu hỏi, mỗi câu gồm: câu SQL + con số đáp án + 1 dòng nhận xét:
1. Total revenue tháng 7/2026 là bao nhiêu?
2. Customer nào có tổng chi tiêu cao nhất (id + tên + số tiền)?
3. Category nào có số lượng orders cao nhất?
4. Average order value (AOV) là bao nhiêu?
5. Có bao nhiêu customers có hơn 3 orders?

**Kết quả cần đạt:** 5 đáp án bằng số cụ thể (không để trống, không ghi "khoảng"), SQL tái chạy ra đúng số đó.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | File trả lời | `docs/answers_02.md` (mỗi câu: SQL + **Đáp án: ...** + nhận xét) |
| 2 | Output chạy lại | `docs/evidence/02-business-results.txt` hoặc ảnh |

---

## Phần 2: Nâng cao (+20% Bonus)

### 2.1 Advanced Analytics (Bonus 10%)

**Yêu cầu chi tiết:**
1. Query cumulative revenue theo thời gian (`SUM(revenue) OVER (ORDER BY month)`).
2. Tỷ trọng doanh thu từng category (`revenue / SUM(revenue) OVER () * 100`).
3. Tìm customers "churn" (không có order trong 30 ngày qua so với `MAX(order_date)`).

**Kết quả cần đạt:** 3 queries chạy được, có cột cumulative / percentage / churn_flag rõ ràng.

**Minh chứng phải nộp:** Bổ sung vào `sql/student/03_exercises_advanced.sql` (comment `-- Bonus 2.1`) + output 5-10 dòng đầu trong `docs/evidence/02-bonus.txt`.

### 2.2 Performance & Optimization (Bonus 10%)

**Yêu cầu chi tiết:**
1. Giải thích 3-5 dòng: vì sao cần INDEX cho cột hay dùng trong `WHERE/JOIN` (lấy 1 query buổi này làm ví dụ).
2. Chạy `EXPLAIN ANALYZE` cho query đó trước/sau khi tạo index, so sánh `Execution Time`.

**Kết quả cần đạt:** Hiểu và chứng minh index giúp giảm thời gian chạy (hoặc giải thích vì sao không giảm với data nhỏ).

**Minh chứng phải nộp:** File giải thích `docs/explain_output/02-explain.md` (ghi câu lệnh + 2 output EXPLAIN + nhận xét) - thay cho yêu cầu cũ chỉ "commit file kết quả".

---

## Deliverables - Tổng hợp nộp bài

| Task | File/Artifact phải có | Location |
|------|----------------------|----------|
| 1.1 Basic | 5 queries + output từng query | `sql/student/02_exercises_basic.sql` + `docs/evidence/02-basic-results.txt` |
| 1.2 Aggregate | 5 queries + CSV đối soát | `sql/student/02_exercises_basic.sql` + `docs/query_results.csv` |
| 1.3 JOIN | 5 queries + output đối soát Q5 | `sql/student/02_exercises_basic.sql` + `docs/evidence/02-join-q5.txt` |
| 1.4 Business | SQL + đáp án số + nhận xét | `docs/answers_02.md` + `docs/evidence/02-business-results.txt` |
| Bonus | Advanced queries + EXPLAIN | `sql/student/03_exercises_advanced.sql` + `docs/explain_output/02-explain.md` |

---

## Rubric (chấm theo minh chứng)

| Tiêu chí | Điểm | Yêu cầu = minh chứng |
|----------|------|---------|
| Basic queries | 20 | Đủ 5 queries + output; thiếu output trừ 50% số điểm task |
| Aggregate queries | 30 | Đủ 5 queries + `query_results.csv`; sai HAVING trừ 10 |
| JOIN queries | 30 | Đúng JOIN + Q5 đối soát có nhận xét; sai LEFT JOIN trừ 10 |
| Business questions | 20 | 5 đáp án số + SQL tái chạy đúng; đáp án không số = 0 điểm câu đó |
| Bonus | +20% | Mỗi mục 2.1/2.2 đạt = +10% |

---

## Tips
- Luôn test với `LIMIT 10` trước khi chạy toàn bộ
- So sánh kết quả với `data/seed/` files
- Dùng `EXPLAIN ANALYZE` để hiểu query plan
