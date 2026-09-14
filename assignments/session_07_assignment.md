# Bài tập về nhà - Buổi 7: Data Cleaning & Data Quality

**Hạn nộp:** Trước buổi 8

**Độ khó:** ⭐️⭐️⭐️⭐️ (Trung bình đến Nâng cao)

---

## Mục tiêu bài tập
- Implement schema và business rule validation
- Handle dirty data với quarantine workflow
- Build automated data quality tests

---

## Phần 1: Bắt buộc (100%)

> Chạy validators trên data mẫu `data/dirty/` (có lỗi cố ý) + `data/seed/` (sạch). Mọi Task phải kèm **số liệu vi phạm cụ thể**, không chỉ nộp code.

### 1.1 Schema Validation - Cột/type/required + scoring (20%)

**Yêu cầu chi tiết:** Hoàn thiện `src/validators/schema_validator.py`:
1. **Column check:** thiếu/thừa cột so với contract → liệt kê tên cột.
2. **Type check:** sai type (ngày trong cột số, chữ trong cột tiền...) → đếm rows sai.
3. **Required check:** NULL ở cột bắt buộc → flag từng row.
4. **Row scoring:** chấm 0-100% mỗi row theo tỷ lệ check đạt (ví dụ đạt 3/4 checks = 75%).

**Kết quả cần đạt:** Chạy trên 1 file dirty ra danh sách lỗi theo cột + điểm từng row.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code validator | `src/validators/schema_validator.py` |
| 2 | Output demo (10 rows đầu kèm score + lỗi) | `docs/evidence/07-schema.txt` - mẫu: `row_id=5 score=75 errors=[missing email, bad date]` |

### 1.2 Business Rule Validation - Email/enum/range/date (30%)

**Yêu cầu chi tiết:** Hoàn thiện `src/validators/business_validator.py` với 4 nhóm rule, mỗi rule có `error_code` cố định:
1. **Email:** regex - `E_EMAIL_INVALID`.
2. **Enum:** status phải thuộc danh sách cho phép - `E_STATUS_INVALID`.
3. **Range:** `amount >= 0`, `quantity > 0`, `discount 0-100` - `E_AMOUNT_NEG`, `E_QTY_INVALID`, `E_DISCOUNT_RANGE`.
4. **Date:** `order_date <= ship_date`, không future date - `E_DATE_ORDER_AFTER_SHIP`, `E_DATE_FUTURE`.
- Mỗi vi phạm trả về `(row_id, error_code, error_message)` cụ thể.

**Kết quả cần đạt:** Chạy trên data dirty thấy đủ 4 nhóm lỗi xuất hiện (nếu data mẫu thiếu nhóm nào, tự tạo 2-3 rows demo).

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code + bảng mã lỗi | `src/validators/business_validator.py` (comment bảng `error_code` đầu file) |
| 2 | Bảng đếm vi phạm per-rule | `docs/evidence/07-business.txt` - mẫu: `E_EMAIL_INVALID=12, E_AMOUNT_NEG=5, ...` |

### 1.3 Cross-Table Integrity - FK checks 4 cặp (25%)

**Yêu cầu chi tiết:** Hoàn thiện `src/validators/integrity_validator.py`, check 4 cặp:
1. `orders.customer_id → customers.id`.
2. `order_items.order_id → orders.id`.
3. `order_items.product_id → products.id`.
4. `payments.order_id → orders.id`.
- Mỗi orphan row ghi `(bảng con, id, fk_thiếu)`.

**Kết quả cần đạt:** Liệt kê được orphan rows (nếu data sạch không có orphan → tự chèn 2-3 FK sai để demo rồi ghi chú).

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code | `src/validators/integrity_validator.py` |
| 2 | Danh sách orphan demo | `docs/evidence/07-integrity.txt` - mẫu: `order_items id=999 order_id=8888 NOT IN orders (3 rows)` |

### 1.4 Data Quality Report - Thống kê + export + invariant (15%)

**Yêu cầu chi tiết:** Hoàn thiện `src/quality_report.py`:
1. Tổng hợp: `total_rows, valid_rows, rejected_rows, rejection_rate%`.
2. Đếm vi phạm per-rule (lấy từ 1.1-1.3).
3. Export `reports/data_quality_report.csv` đúng header: `dataset,total_rows,valid_rows,rejected_rows,rejection_rate,rule,violations`.
4. Verify invariant: `total = valid + rejected` (assert, sai thì báo lỗi).

**Kết quả cần đạt:** File CSV đọc được, invariant đúng, rejection_rate tính đúng công thức.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code | `src/quality_report.py` |
| 2 | File báo cáo thật | `reports/data_quality_report.csv` (mở thấy đủ header + số liệu) |
| 3 | Ảnh/log invariant check | `docs/evidence/07-invariant.txt` - mẫu: `customers: 120 = 105 + 15 OK` |

### 1.5 Reject Workflow - Tách valid/reject + giữ RAW (+10% - bắt buộc)

**Yêu cầu chi tiết:**
1. Tách output: `data/processed/<run_id>/valid/` và `data/reject/<run_id>/`.
2. Mỗi rejected row có thêm `error_code, error_message` (nối nhiều lỗi bằng `;`).
3. RAW gốc không bị sửa (so checksum hoặc mtime trước/sau).

**Kết quả cần đạt:** Có 2 thư mục output, file reject mở thấy cột lỗi, RAW nguyên vẹn.

**Minh chứng phải nộp:**
 
|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | 5 dòng reject mẫu (thấy error_code/message) | `docs/evidence/07-reject-sample.csv` (trích từ file reject thật) |
| 2 | Ảnh cây thư mục output + xác nhận RAW không đổi | `docs/evidence/07-folders.png` hoặc `.txt` (`ls data/reject/<run_id>/` + `md5 RAW trước/sau giống nhau`) |

---

## Phần 2: Nâng cao (+20% Bonus)

### 2.1 Custom Rules (Bonus 10%)

**Yêu cầu chi tiết:** Thêm ≥1 rule tùy chỉnh (ví dụ: VIP discount cap 20%, completed order bắt buộc có payment) + file cấu hình `validators/rules.json` để bật/tắt rule không cần sửa code.

**Kết quả cần đạt:** Tắt rule trong JSON → pipeline bỏ qua rule đó (demo on/off).

**Minh chứng phải nộp:** `src/validators/rules.json` + log on/off `docs/evidence/07-custom-rule.txt`.

### 2.2 Test Suite (Bonus 10%)

**Yêu cầu chi tiết:** Viết pytest cho 3 validators (good/bad/edge: file rỗng, giá trị cực đoan), chạy được `pytest tests/test_validators_public.py` của repo.

**Kết quả cần đạt:** `pytest` pass toàn bộ public tests + tests tự viết.

**Minh chứng phải nộp:** `tests/test_validators_*.py` + output `docs/evidence/07-pytest.txt`.

---

## Deliverables - Tổng hợp nộp bài

| Task | File/Artifact phải có | Location |
|------|----------------------|----------|
| 1.1 Schema | Code + output scoring | `src/validators/schema_validator.py` + `docs/evidence/07-schema.txt` |
| 1.2 Business | Code + bảng mã lỗi + đếm per-rule | `src/validators/business_validator.py` + `docs/evidence/07-business.txt` |
| 1.3 Integrity | Code + orphan list | `src/validators/integrity_validator.py` + `docs/evidence/07-integrity.txt` |
| 1.4 Report | Code + CSV + invariant | `src/quality_report.py` + `reports/data_quality_report.csv` + `docs/evidence/07-invariant.txt` |
| 1.5 Reject | Reject mẫu + cây thư mục | `data/reject/<run_id>/` + `docs/evidence/07-reject-sample.csv` |
| Bonus | Rules JSON + pytest | `src/validators/rules.json` + `docs/evidence/07-pytest.txt` |

---

## Rubric (chấm theo minh chứng)

| Tiêu chí | Điểm | Yêu cầu = minh chứng |
|----------|------|---------|
| Schema validation | 20 | Đủ 4 checks + output scoring mẫu |
| Business rules | 30 | Đủ 4 nhóm + error_code + đếm per-rule |
| Integrity | 25 | Đủ 4 cặp FK + orphan list demo |
| Report | 15 | CSV đúng header + invariant OK |
| Reject workflow | 10 | Tách valid/reject + cột lỗi + RAW nguyên vẹn (bắt buộc trong 100%) |
| Bonus | +20% | Mỗi mục đạt = +10% |

---

## Tips
- Reject records should have traceable error messages
- Keep RAW data immutable for audit trail
- Test validators with known good/bad datasets
