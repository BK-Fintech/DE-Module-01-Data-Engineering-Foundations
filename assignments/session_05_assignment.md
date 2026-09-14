# Bài tập về nhà - Buổi 5: Python Fundamentals for Data Pipeline

**Hạn nộp:** Trước buổi 6

**Độ khó:** ⭐️⭐️⭐️ (Trung bình)

---

## Mục tiêu bài tập
- Hiểu quy trình ETL với Python
- Xử lý CSV/JSON files
- Implement logging và exception handling

---

## Phần 1: Bắt buộc (100%)

### 1.1 Environment Setup - venv + dependencies + .env (15%)

**Yêu cầu chi tiết:**
1. Tạo venv: `python3.11 -m venv .venv` (hoặc `python3 -m venv .venv`), activate, `pip install -r requirements.txt`.
2. Copy starter: `cp -R starter/src src` (nếu chưa có `src/` hoàn chỉnh).
3. Copy `.env.example` → `.env`, điền đủ `POSTGRES_*`, `MOCK_API_URL/KEY` (không commit `.env` thật lên GitHub - chỉ commit `.env.example`).

**Kết quả cần đạt:** `pip list` thấy đủ package, `python -c "import src.extract_files"` không lỗi, `.env` load được.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Ảnh/log tạo venv + pip install thành công | `docs/evidence/05-venv.png` hoặc `.txt` (`pip list` thấy pandas/sqlalchemy/psycopg) |
| 2 | Ảnh chạy thử import OK | cùng file trên hoặc `docs/evidence/05-import.txt` (`python -c "from src import config; print('OK')"` → `OK`) |
| 3 | File `.env.example` (không nộp `.env` thật) | Root repo - chụp ảnh `.env` đã điền (che password) vào `docs/evidence/05-env.png` |

### 1.2 File Extraction - Đọc CSV/JSON + validation (25%)

**Yêu cầu chi tiết:** Hoàn thiện `src/extract_files.py`:
1. Đọc CSV từ thư mục input (dùng `pathlib` + `pandas.read_csv`), đọc JSON từ mock API/file mẫu.
2. Xử lý encoding `utf-8` (thử `utf-8-sig` nếu lỗi BOM).
3. Validation cơ bản: file tồn tại, không rỗng, có đủ cột bắt buộc → raise `FileNotFoundError/ValueError` với message rõ.

**Kết quả cần đạt:** Chạy `read_dataset()` với `data/seed/` đọc được ≥3 datasets, file lỗi báo exception có message.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code hoàn thiện | `src/extract_files.py` (hàm `read_dataset`) |
| 2 | Log chạy đọc file thành công + 1 case file lỗi | `docs/evidence/05-extract-log.txt` - mẫu: `customers: 120 rows OK / missing_file.csv → FileNotFoundError: ...` |

### 1.3 Data Profiling - Đếm rows/cols, missing, duplicate (25%)

**Yêu cầu chi tiết:** Viết hàm `profile(df, pk)` trong `src/extract_files.py`:
1. Đếm rows × columns.
2. Missing values per column (`df.isna().sum()`).
3. Duplicate rows theo PK (`df.duplicated(subset=[pk]).sum()`).
4. In report ra console/log theo mẫu cố định (xem Kết quả cần đạt).

**Kết quả cần đạt:** Report đúng mẫu cho mỗi dataset, số liệu khớp khi chạy lại.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code hàm `profile` | `src/extract_files.py` |
| 2 | File report mẫu | `logs/profile_report.txt` - mẫu 1 dataset: `dataset=customers rows=120 cols=8 missing={email:3} duplicates_pk=0` (làm cho ≥3 datasets) |

### 1.4 Data Normalization - Text/date/number/null (20%)

**Yêu cầu chi tiết:** Hoàn thiện `src/transform.py` hàm `normalize(df)`:
1. Text: `strip()` + lowercase cho cột string chỉ định (không lowercase email nếu quy định giữ nguyên - ghi chú).
2. Date: chuẩn `YYYY-MM-DD` (dùng `pd.to_datetime(...).dt.strftime`), giá trị parse lỗi → `NaT` + log warning.
3. Number: convert string → float/int, xử lý ký hiệu tiền tệ/dấu phẩy.
4. Null: chuẩn hóa về `None/NaN` nhất quán (không để lẫn `""`, `"NULL"`, `"N/A"`).

**Kết quả cần đạt:** Chạy trên 1 file dirty mẫu (`data/dirty/`) thấy text/date/number đã chuẩn, không còn giá trị rác kể trên.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code | `src/transform.py` |
| 2 | Before/after 5 dòng mẫu | `docs/evidence/05-normalize.txt` - mẫu: `BEFORE: "  NGUYEN Van A ", "12/01/2026", "$1,200" → AFTER: "nguyen van a", "2026-01-12", 1200.0` |

### 1.5 Logging & Exception - File + console handlers (15%)

**Yêu cầu chi tiết:** Hoàn thiện `src/logger.py`:
1. 2 handlers: file (`logs/pipeline.log`) + console, level `INFO` trở lên.
2. Format: `timestamp | level | module | message` (ví dụ `2026-07-01 10:00:01 | INFO | extract | ...`).
3. `try-except` với message chi tiết (tên file, dòng lỗi), không dùng bare `except:` - bắt exception cụ thể.

**Kết quả cần đạt:** Chạy pipeline nhỏ sinh log file + console đúng format, lỗi cố ý (file thiếu) log ở level `ERROR` kèm traceback gọn.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code | `src/logger.py` |
| 2 | File log mẫu (≥10 dòng gồm INFO + 1 ERROR demo) | `logs/pipeline.log` (nộp đoạn trích vào `docs/evidence/05-logging.txt` nếu log dài) |

---

## Phần 2: Nâng cao (+20% Bonus)

### 2.1 Configuration Management (Bonus 10%)

**Yêu cầu chi tiết:** Hoàn thiện `src/config.py` dùng `dotenv`: load `batch_date, input_dir, output_dir`, hỗ trợ `dev/prod` qua biến `ENV`.

**Kết quả cần đạt:** Đổi `.env` là đổi được input/output mà không sửa code; `print(SETTINGS)` hiện đúng giá trị.

**Minh chứng phải nộp:** `src/config.py` + `.env.example` đầy đủ key + ảnh `docs/evidence/05-config.png` (print SETTINGS ở 2 ENV khác nhau).

### 2.2 Unit Testing (Bonus 10%)

**Yêu cầu chi tiết:** Viết pytest cho extract + transform, gồm edge cases (file rỗng, data lỗi format).

**Kết quả cần đạt:** `pytest` pass ≥5 tests.

**Minh chứng phải nộp:** `tests/test_extract.py`, `tests/test_transform.py` + output `docs/evidence/05-pytest.txt` (`5 passed`).

---

## Deliverables - Tổng hợp nộp bài

| Task | File/Artifact phải có | Location |
|------|----------------------|----------|
| 1.1 Env | venv log + import OK + env ảnh (che pass) | `docs/evidence/05-venv.png`, `05-import.txt`, `05-env.png` |
| 1.2 Extract | Code + log đọc OK/lỗi | `src/extract_files.py` + `docs/evidence/05-extract-log.txt` |
| 1.3 Profiling | Code + report | `src/extract_files.py` + `logs/profile_report.txt` |
| 1.4 Normalize | Code + before/after | `src/transform.py` + `docs/evidence/05-normalize.txt` |
| 1.5 Logging | Code + log mẫu | `src/logger.py` + `logs/pipeline.log` |
| Bonus | config + tests | `src/config.py` + `tests/test_*.py` + `docs/evidence/05-pytest.txt` |

---

## Rubric (chấm theo minh chứng)

| Tiêu chí | Điểm | Yêu cầu = minh chứng |
|----------|------|---------|
| Environment | 15 | venv + install + import OK; thiếu 1 trừ 5 |
| Extraction | 25 | Đọc CSV/JSON + validation có message; không xử lý encoding trừ 5 |
| Profiling | 25 | Report đúng mẫu ≥3 datasets; thiếu duplicate check trừ 10 |
| Normalization | 20 | Before/after đủ 4 loại text/date/number/null |
| Logging | 15 | Đủ 2 handlers + format + ERROR demo |
| Bonus | +20% | Mỗi mục đạt = +10% |

---

## Tips
- Dùng `pathlib` thay vì `os.path` cho cross-platform paths
- Luôn test với sample data nhỏ trước
- Exception handling: catch specific exceptions, not bare `except:`
