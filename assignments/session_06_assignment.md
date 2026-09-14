# Bài tập về nhà - Buổi 6: Data Ingestion từ REST API

**Hạn nộp:** Trước buổi 7

**Độ khó:** ⭐️⭐️⭐️⭐️ (Trung bình đến Nâng cao)

---

## Mục tiêu bài tập
- Hiểu REST API patterns (pagination, rate limiting, auth)
- Implement retry logic với exponential backoff
- Handle idempotency với UPSERT operations

---

## Phần 1: Bắt buộc (100%)

### 1.1 API Exploration - Health/auth/pagination/filter (20%)

**Yêu cầu chi tiết:**
1. **Health check:** `GET /health` → expect `200 {"status":"ok"}` (kiểm tra key/field thực tế của mock API và ghi lại).
2. **Auth:** gọi 1 lần đúng key (200) + 1 lần sai key (expect `401/403`), ghi nhận message lỗi.
3. **Pagination:** thử `?page=1&page_size=10`, ghi `has_next`, `total_pages` (hoặc field tương đương).
4. **Filtering:** thử `?updated_after=2026-07-01T00:00:00Z` (ISO 8601), so sánh số rows có/không filter.
5. Tổng hợp thành tài liệu API.

**Kết quả cần đạt:** Hiểu 4 endpoints/params trên, tài liệu đủ để người khác gọi được API mà không cần hỏi.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Tài liệu API (base URL, endpoints, headers, params, ví dụ request/response, mã lỗi) | `docs/api_docs.md` (mẫu mục: `GET /orders?page&... → 200 {data, has_next}`) |
| 2 | Log gọi thử 4 loại (curl/httpie/python, che key) | `docs/evidence/06-explore-log.txt` - mẫu: `GET /health → 200 ok / sai key → 401 / page=1 → 10 rows has_next=true` |

### 1.2 HTTP Client Implementation - Timeout/retry/logging (25%)

**Yêu cầu chi tiết:** Hoàn thiện `src/api_client.py`:
1. **Timeout** 10-30s cho mọi request (`requests.get(..., timeout=15)`).
2. **Lỗi HTTP** → raise exception có status + body (không `return None` im lặng).
3. **Retry tối đa 3 lần**, exponential backoff (lần 1 chờ 1s, lần 2 chờ 2s, lần 3 chờ 4s) cho lỗi retryable (`502/503/504`, timeout).
4. **Log** mỗi request/response ở INFO, API key che `******`.

**Kết quả cần đạt:** Ngắt mock API (stop container) rồi gọi → client retry 3 lần rồi báo lỗi rõ; bật lại → gọi thành công.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code client | `src/api_client.py` (có `timeout`, `max_retries=3`, `backoff`, log che key) |
| 2 | Log demo retry (stop API → gọi → 3 retries → lỗi; start lại → OK) | `docs/evidence/06-retry-log.txt` |

### 1.3 Pagination & Data Capture - Fetch all pages + RAW (25%)

**Yêu cầu chi tiết:**
1. Vòng lặp fetch tới khi `has_next=false` (ghi rõ điều kiện dừng theo field thực tế của API).
2. Delay 1-2s giữa requests (tránh rate limit).
3. Lưu RAW nguyên bản → `data/raw/<run_id>/orders.json` (không transform trước khi lưu).
4. Track và in: tổng pages, tổng rows.

**Kết quả cần đạt:** 1 run lấy đủ pages, file RAW tồn tại, đếm rows khớp log.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code vòng lặp fetch | `src/api_client.py` (hàm `fetch_all_pages`) |
| 2 | File RAW thật (ít nhất 1 run) | `data/raw/<run_id>/orders.json` (commit file mẫu nhỏ hoặc ghi `run_id` trong nộp bài) |
| 3 | Log tổng kết | `docs/evidence/06-fetch-log.txt` - mẫu: `pages=5 rows=482 saved=data/raw/20260701_100001/orders.json` |

### 1.4 Database Upsert - ON CONFLICT + transaction (25%)

**Yêu cầu chi tiết:** Hoàn thiện `src/load_postgres.py`:
1. Upsert `ON CONFLICT (id) DO UPDATE SET ...` (ghi rõ cột update, `updated_at=NOW()` nếu có).
2. Transaction bằng context manager (`with engine.begin():`), lỗi → rollback.
3. Connection qua SQLAlchemy engine có pool (không mở connection mới mỗi row).
4. In `inserted=X updated=Y` sau mỗi load.

**Kết quả cần đạt:** Load RAW vào Postgres thành công, chạy lại cùng data không tăng row count (chuyển sang update).

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Code upsert | `src/load_postgres.py` (thấy `ON CONFLICT`, `engine.begin()`) |
| 2 | Log load (inserted/updated + row count verify) | `docs/evidence/06-upsert-log.txt` - mẫu: `inserted=482 updated=0 / SELECT COUNT(*)=482` |

### 1.5 Idempotency Test - Chạy 2 lần không duplicate (+10% - gộp vào 100%, không phải bonus)

**Yêu cầu chi tiết:**
1. Chạy pipeline/API-load 2 lần với cùng `run_id`/data.
2. So sánh `SELECT COUNT(*)` + `COUNT(DISTINCT id)` trước/sau lần 2.
3. Kết luận đạt/không đạt + nguyên nhân nếu fail.

**Kết quả cần đạt:** Lần 2 `inserted=0` (toàn update), tổng rows không đổi.

**Minh chứng phải nộp:**

|   | Minh chứng | Đường dẫn |
|---|------------|-----------|
| 1 | Báo cáo test (lệnh chạy, số liệu 2 lần, kết luận) | `docs/idempotency_test.md` - mẫu bảng: `| Lần | COUNT(*) | inserted | updated |` |

---

## Phần 2: Nâng cao (+20% Bonus)

### 2.1 Advanced Retry Logic (Bonus 10%)

**Yêu cầu chi tiết:** Thêm: retry theo strategy khác nhau (constant/exponential/jitter), circuit breaker (dừng sau N lỗi liên tiếp), chỉ retry `502/503/504` + timeout (không retry `400/401/404`).

**Kết quả cần đạt:** Bảng quyết định retry theo status code + demo 1 case breaker ngắt.

**Minh chứng phải nộp:** Code + `docs/evidence/06-advanced-retry.md` (bảng status→retry/không + log demo).

### 2.2 Checkpointing (Bonus 10%)

**Yêu cầu chi tiết:** Lưu `metadata/pipeline_state.json` gồm `last_run_id`, `last_updated_after`, crash giữa chừng → chạy lại tiếp tục từ checkpoint thay vì từ đầu.

**Kết quả cần đạt:** Xóa checkpoint → chạy full; có checkpoint → chạy tiếp phần còn lại.

**Minh chứng phải nộp:** `metadata/pipeline_state.json` mẫu + log resume `docs/evidence/06-checkpoint.txt`.

---

## Deliverables - Tổng hợp nộp bài

| Task | File/Artifact phải có | Location |
|------|----------------------|----------|
| 1.1 Explore | API docs + log thử | `docs/api_docs.md` + `docs/evidence/06-explore-log.txt` |
| 1.2 Client | Code + log retry | `src/api_client.py` + `docs/evidence/06-retry-log.txt` |
| 1.3 Fetch | Code + RAW + log pages/rows | `src/api_client.py` + `data/raw/<run_id>/orders.json` + `docs/evidence/06-fetch-log.txt` |
| 1.4 Upsert | Code + log inserted/updated | `src/load_postgres.py` + `docs/evidence/06-upsert-log.txt` |
| 1.5 Idempotency | Báo cáo 2 lần chạy | `docs/idempotency_test.md` |
| Bonus | Retry nâng cao + checkpoint | `docs/evidence/06-advanced-retry.md` + `metadata/pipeline_state.json` |

> Lưu ý chấm: Task 1.5 là bắt buộc (10 điểm trong 100%), không phải bonus. Bonus 2.1/2.2 cộng thêm tối đa +20%.

---

## Rubric (chấm theo minh chứng)

| Tiêu chí | Điểm | Yêu cầu = minh chứng |
|----------|------|---------|
| API exploration | 15 | `api_docs.md` đủ 4 mục + log 4 loại; lộ API key trừ hết điểm task |
| HTTP client | 20 | timeout + retry 3 + backoff + log che key; không retry trừ 10 |
| Pagination | 25 | Loop tới `has_next=false` + RAW + log pages/rows khớp |
| Upsert | 25 | `ON CONFLICT` + transaction + inserted/updated log |
| Idempotency | 15 | Chạy 2 lần, rows không tăng, báo cáo có bảng số |
| Bonus | +20% | Mỗi mục đạt = +10% |

---

## Tips
- Always capture RAW before transform (immutable source of truth)
- Use `psycopg` for PostgreSQL connections
- API key should NEVER be in logs (use `******` masking)
