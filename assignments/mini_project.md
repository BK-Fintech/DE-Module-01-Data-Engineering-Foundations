# Mini Project – Automated E-commerce Data Ingestion Pipeline

**Hạn nộp:** Cuối tuần sau buổi 8

**Tổng điểm:** 100% (15% bonus cho advanced features)

---

## Overview

Xây dựng pipeline data ingestion hoàn chỉnh, từ nhiều nguồn (file + API), xử lý data quality, và cập nhật Data Mart tự động.

---

## Requirements (100%) — Mỗi mục đều có minh chứng bắt buộc

### 1. OLTP Database Setup (20%)

**Yêu cầu chi tiết:**
1. Chạy `sql/student/01_create_oltp.sql` tạo OLTP, load seed `data/seed/`.
2. Verify bằng DBeaver: đủ bảng + đếm rows.

**Kết quả cần đạt:** DB `ecommerce` có dữ liệu seed, queries buổi 2 chạy được.

**Minh chứng phải nộp:**

| Minh chứng | Đường dẫn |
|------------|-----------|
| Log tạo DB + load seed (row counts từng bảng) | `docs/evidence/mp-oltp.txt` — mẫu: `customers=120 orders=500 ...` |
| Ảnh DBeaver cây bảng OLTP | `docs/evidence/mp-oltp-dbeaver.png` |

### 2. Data Mart Creation (15%)

**Yêu cầu chi tiết:** Chạy DDL + load mart (bài buổi 4), verify KPI `13_data_mart_kpi.sql` (tham khảo `sql/solutions/`).

**Kết quả cần đạt:** Mart có dữ liệu, KPI ra số.

**Minh chứng phải nộp:**

| Minh chứng | Đường dẫn |
|------------|-----------|
| Row counts mart + output 3 KPI đầu | `docs/evidence/mp-mart.txt` |

### 3. Python Ingestion Pipeline (20%)

**Yêu cầu chi tiết:** `src/pipeline.py` chạy được `--source both`, log đầy đủ, config qua `.env`.

**Kết quả cần đạt:** 1 run end-to-end success, exit 0.

**Minh chứng phải nộp:**

| Minh chứng | Đường dẫn |
|------------|-----------|
| Code + log full 1 run + `.env.example` | `src/pipeline.py`, `logs/pipeline.log` (trích `docs/evidence/mp-pipeline-log.txt`) |

### 4. Data Quality (20%)

**Yêu cầu chi tiết:** Validators chạy, có DQ report + thư mục reject.

**Kết quả cần đạt:** `Total = Valid + Rejected`, reject rows có `error_code`.

**Minh chứng phải nộp:**

| Minh chứng | Đường dẫn |
|------------|-----------|
| DQ report + reject mẫu + invariant | `reports/data_quality_report.csv` + `docs/evidence/mp-reject-sample.csv` + `docs/evidence/mp-invariant.txt` |

### 5. Idempotency & Checkpointing (15%)

**Yêu cầu chi tiết:** Chạy 2 lần cùng data không duplicate + resume từ checkpoint.

**Kết quả cần đạt:** Lần 2 rows không tăng; state file đúng mẫu.

**Minh chứng phải nộp:**

| Minh chứng | Đường dẫn |
|------------|-----------|
| Báo cáo 2 lần chạy + state file | `docs/idempotency_test.md` + `metadata/pipeline_state.json` |

### 6. Demo & Documentation (10%)

**Yêu cầu chi tiết:**
1. Demo 5-7 phút đủ 5 phần (kiến trúc → live run → lỗi → recovery → KPI).
2. `README.md` có: architecture diagram (ảnh), cách chạy (3 lệnh copy-paste được), link evidence.

**Kết quả cần đạt:** Người xem demo hiểu luồng + thấy pipeline chạy thật.

**Minh chứng phải nộp:**

| Minh chứng | Đường dẫn |
|------------|-----------|
| README + diagram + slide/kịch bản demo | `README.md` + `docs/evidence/mp-architecture.png` + `docs/demo_script.md` |

---

## Advanced Features (+15% Bonus)

| Feature | Điểm |
|---------|------|
| **Error Recovery**: Restart từ checkpoint sau failure | +5% |
| **Performance Benchmark**: Record pipeline runtime | +5% |
| **Custom Business Rules**: 2+ rules tùy chỉnh | +5% |

---

## Demo Requirements (5-7 phút)

1. **Architecture Overview** (1 phút)
   - Explain pipeline flow
   - Show component interactions

2. **Live Demo** (2 phút)
   - Run pipeline with sample data
   - Show logs and outputs

3. **Error Demonstration** (1 phút)
   - Introduce one real error (dirty data, API failure)
   - Show handling và recovery

4. **KPI Demonstration** (1 phút)
   - Show Data Mart metrics before/after refresh
   - Verify data consistency

5. **Q&A** (1-2 phút)

---

## Rubric (chấm theo minh chứng)

| Tiêu chí | Điểm | Yêu cầu = minh chứng |
|----------|------|---------|
| OLTP Setup | 20 | Log row counts + ảnh DBeaver; thiếu 1 trừ 10 |
| Data Mart | 15 | Row counts mart + KPI có số |
| Pipeline | 20 | 1 run success + log full + config |
| Data Quality | 20 | CSV + reject mẫu + invariant OK |
| Idempotency | 15 | 2 lần chạy không duplicate + state đúng mẫu |
| Demo | 10 | Đủ 5 phần + README chạy được |
| Bonus | +15% | Advanced features có demo/log |

---

## Files to Create/Modify

| File | Purpose |
|------|---------|
| `src/pipeline.py` | Main orchestration |
| `src/refresh_mart.py` | Mart refresh logic |
| `scripts/run_daily.sh` | Automation script |
| `docs/idempotency_test.md` | Test documentation |
| `README.md` | Project documentation |

---

## Tips

- Start with file source first, then add API
- Test incrementally (each step before full pipeline)
- Keep RAW data immutable
- Use pytest for automated testing
