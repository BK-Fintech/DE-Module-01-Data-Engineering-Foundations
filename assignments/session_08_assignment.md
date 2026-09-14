# Bài tập về nhà - Buổi 8: End-to-End Daily Pipeline

**Hạn nộp:** Trước mini project demo

**Độ khó:** ⭐️⭐️⭐️⭐️⭐️ (Nâng cao)

---

## Mục tiêu bài tập
- Orchestrated toàn bộ ETL pipeline
- Implement idempotency và checkpointing
- Demo end-to-end solution

---

## Phần 1: Bắt buộc (100%)

### 1.1 Pipeline Orchestration - 8 bước + CLI + exit code (30%)

**Yêu cầu chi tiết:** Hoàn thiện `src/pipeline.py` đúng thứ tự 8 bước (code repo đã có khung `DATASETS`/steps - điền tiếp):
1. Extract (file/api) → 2. Normalize → 3. Validate → 4. Split valid/reject → 5. Upsert DB → 6. DQ report → 7. Checkpoint → 8. Refresh Mart.
- CLI: `argparse` với `--source {file,api,both}`, `--input-dir`, `--refresh-mart` (chạy `--help` phải hiện đủ flags).
- Log full vào `logs/pipeline.log` đúng format buổi 5.
- Exit code: `0` khi success, `!= 0` khi fail (dùng `sys.exit`).

**Kết quả cần đạt:** `python -m src.pipeline --source both --input-dir data/incremental/day_2026-07-01 --refresh-mart` chạy hết 8 bước không lỗi, log hiện đủ 8 bước.

**Minh chứng phải nộp:**

| # | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code pipeline | `src/pipeline.py` (đủ 8 steps + argparse + exit code) |
| 2 | Ảnh `--help` | `docs/evidence/08-help.png` hoặc `.txt` (thấy 3 flags) |
| 3 | Log 1 run thành công (thấy đủ 8 bước + `exit 0`) | `logs/pipeline.log` + trích `docs/evidence/08-pipeline-log.txt` - mẫu: `[1/8] Extract ... OK (482 rows) ... [8/8] Refresh Mart OK` |

### 1.2 Multi-Source Support - file + api + both (25%)

**Yêu cầu chi tiết:**
1. **File:** `--source file --input-dir data/incremental/day_2026-07-01` (đọc CSV/JSON增量).
2. **API:** `--source api` (fetch mock API + upsert).
3. **Both:** `--source both` (chạy cả hai, log ghi rõ source từng batch).
4. Mỗi run sinh `run_id` riêng, RAW tách thư mục theo `run_id`.

**Kết quả cần đạt:** 3 lệnh trên đều chạy được, log phân biệt source, không lẫn data.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | 3 logs tương ứng 3 nguồn | `docs/evidence/08-file.txt`, `08-api.txt`, `08-both.txt` (mỗi file 5-10 dòng: source, rows, run_id) |
| 2 | Ảnh cây `data/raw/` có ≥2 run_id | `docs/evidence/08-raw-tree.txt` (`ls data/raw/`) |

### 1.3 Checkpoint & State - Watermark + resume (20%)

**Yêu cầu chi tiết:**
1. State lưu tại `metadata/pipeline_state.json` gồm: `last_run_id`, `last_updated_after` (ISO 8601), `status`.
2. Chỉ update checkpoint khi run **success** (fail thì giữ watermark cũ).
3. Lần chạy sau đọc state để resume (API dùng `updated_after` từ state).

**Kết quả cần đạt:** Giả lập fail (ngắt API hoặc input sai) → state không đổi; chạy lại success → state cập nhật watermark mới.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | File state thật | `metadata/pipeline_state.json` - mẫu: `{"last_run_id":"20260701_100001","last_updated_after":"2026-07-01T10:00:00Z","status":"success"}` |
| 2 | Log demo fail-giữ-state + success-đổi-state | `docs/evidence/08-checkpoint.txt` (ghi 2 lần chạy + `cat state` trước/sau) |

### 1.4 Data Mart Integration - Refresh + KPI before/after (15%)

**Yêu cầu chi tiết:**
1. Dùng `src/refresh_mart.py` để refresh mart sau pipeline.
2. Đo KPI trước/sau (dùng queries buổi 4: total revenue, order count) - ghi số cụ thể.
3. Lưu bảng so sánh.

**Kết quả cần đạt:** Mart thay đổi sau refresh (revenue tăng đúng lượng data mới), số liệu before/after khớp log pipeline.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code refresh | `src/refresh_mart.py` |
| 2 | Bảng KPI before/after | `docs/kpi_comparison.csv` - header: `kpi,before,after,diff` (ví dụ `total_revenue,125400,131200,5800`) |

### 1.5 Automation Script - run_daily.sh + cron (10% - bắt buộc)

**Yêu cầu chi tiết:**
1. Tạo `scripts/run_daily.sh` (repo đã có mẫu - hoàn thiện error handling + logging): `set -euo pipefail`, activate venv, gọi pipeline, ghi log theo ngày.
2. Tham khảo `scripts/cron_example.txt`, ghi lịch chạy đề xuất (ví dụ `0 2 * * *`).
3. Chạy thử script 1 lần thành công.

**Kết quả cần đạt:** `./scripts/run_daily.sh` chạy không cần gõ thêm lệnh, sinh log ngày.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Script hoàn chỉnh + executable | `scripts/run_daily.sh` (`chmod +x`, có error handling + log path) |
| 2 | Log 1 lần chạy bằng script | `docs/evidence/08-daily.txt` (thấy `run_daily.sh ... exit 0` + log file ngày) |
| 3 | Dòng cron đề xuất | Trong `scripts/cron_example.txt` hoặc `docs/evidence/08-daily.txt` |

---

## Phần 2: Nâng cao (+20% Bonus)

### 2.1 Error Recovery (Bonus 10%)

**Yêu cầu chi tiết:** Demo restart từ checkpoint sau failure (không chạy lại từ đầu) + retry từng step + cơ chế alert (log `ALERT` hoặc webhook/email mẫu).

**Kết quả cần đạt:** Fail ở bước 5 → fix → chạy lại chỉ tiếp tục từ bước 5 (log chứng minh).

**Minh chứng phải nộp:** Log recovery `docs/evidence/08-recovery.txt` (fail → fix → resume, thấy `Resume from step 5`).

### 2.2 Performance Optimization (Bonus 10%)

**Yêu cầu chi tiết:** Tái sử dụng DB connection, xử lý song song steps độc lập (nếu làm), benchmark tổng runtime (`time python -m src.pipeline ...`).

**Kết quả cần đạt:** Có con số runtime + 1 cải tiến có đo lường (trước/sau).

**Minh chứng phải nộp:** `docs/evidence/08-benchmark.txt` - mẫu: `before=95s after=60s (reuse connection)` + `time` output.

---

## Deliverables - Tổng hợp nộp bài

| Task | File/Artifact phải có | Location |
|------|----------------------|----------|
| 1.1 Orchestration | Code + help + log 8 bước | `src/pipeline.py` + `docs/evidence/08-help.*` + `logs/pipeline.log` |
| 1.2 Multi-source | 3 logs + cây RAW | `docs/evidence/08-file.txt`, `08-api.txt`, `08-both.txt` |
| 1.3 Checkpoint | State + log fail/success | `metadata/pipeline_state.json` + `docs/evidence/08-checkpoint.txt` |
| 1.4 Mart | Code + KPI before/after | `src/refresh_mart.py` + `docs/kpi_comparison.csv` |
| 1.5 Automation | Script + log + cron | `scripts/run_daily.sh` + `docs/evidence/08-daily.txt` |
| Bonus | Recovery + benchmark | `docs/evidence/08-recovery.txt`, `08-benchmark.txt` |

---

## Rubric (chấm theo minh chứng)

| Tiêu chí | Điểm | Yêu cầu = minh chứng |
|----------|------|---------|
| Orchestration | 30 | Đủ 8 bước + CLI 3 flags + log + exit code |
| Multi-source | 25 | 3 nguồn chạy được + log phân biệt source |
| Checkpoint | 20 | State đúng mẫu + demo fail-giữ/success-đổi |
| Mart integration | 15 | Refresh + KPI CSV có số before/after |
| Automation | 10 | Script chạy được + log + cron (bắt buộc) |
| Bonus | +20% | Mỗi mục đạt = +10% |

---

## Mini Project Demo (Buổi 8)

### Requirements (5-7 phút)
1. **Architecture overview**: Explain pipeline flow (diagram if possible)
2. **Live demo**: Run pipeline with sample data
3. **Error demonstration**: Show handling of one real error
4. **Recovery**: Rerun after fixing error
5. **KPI demonstration**: Show Data Mart change after refresh

### Rubric
| Tiêu chí | Trọng số |
|----------|----------|
| Architecture explanation | 20% |
| Pipeline execution | 30% |
| Error handling demo | 20% |
| Recovery & rerun | 15% |
| KPI demonstration | 15% |

---

## Tips
- Test with small datasets first
- Keep RAW data unchanged for audit
- Document all decisions in README
