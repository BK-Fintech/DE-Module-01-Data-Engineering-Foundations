# AI-Native Data Engineering - Module 1
## Bài Tập Về Nhà

Tổng quan các bài tập về nhà cho 8 buổi học.

---

## Tổng quan

| Buổi | Title | Độ khó | Thời gian dự kiến |
|------|-------|--------|-------------------|
| 01 | Thiết kế Database & Khởi động Hệ thống | ⭐️ | 2-3 giờ |
| 02 | SQL Fundamentals & Business Analytics | ⭐️⭐️ | 3-4 giờ |
| 03 | SQL Nâng cao - Customer Analytics & Cohort | ⭐️⭐️⭐️ | 4-5 giờ |
| 04 | Thiết kế & Xây dựng Sales Data Mart | ⭐️⭐️⭐️ | 4-5 giờ |
| 05 | Python Fundamentals for Data Pipeline | ⭐️⭐️⭐️ | 5-6 giờ |
| 06 | Data Ingestion từ REST API | ⭐️⭐️⭐️⭐️ | 5-6 giờ |
| 07 | Data Cleaning & Data Quality | ⭐️⭐️⭐️⭐️ | 6-7 giờ |
| 08 | End-to-End Daily Pipeline | ⭐️⭐️⭐️⭐️⭐️ | 7-8 giờ |

---


## Cấu trúc bài tập

Mỗi bài tập có cấu trúc:

```markdown
# Bài tập về nhà - Buổi X: [Title]

## Mục tiêu bài tập
## Phần 1: Bắt buộc (100%)
- Task 1
- Task 2
- ...

## Phần 2: Nâng cao (+20% Bonus)
- Advanced Task 1
- Advanced Task 2

## Deliverables
## Rubric
## Tips
```

---

## Mini Project

Xem `mini_project.md` trong folder `assignments/` hoặc `assignments_v2/`

---

## Hướng dẫn sử dụng

### Giảng viên
- Sử dụng `assignments_v2/` để chấm điểm
- Rubric trong mỗi file giúp grading nhất quán
- Advanced tasks cho học viên xuất sắc
- Đối chiếu minh chứng trong cột `Minh chứng phải nộp` - thiếu minh chứng = chưa đạt task đó

### Học viên - Cách nộp bài (GitHub + LMS theo quy định)
1. **GitHub:** push toàn bộ code, SQL, báo cáo và ảnh minh chứng lên repo cá nhân theo đúng đường dẫn quy định trong từng assignment (ví dụ `sql/student/01_create_oltp.sql`, `docs/evidence/01-dbeaver.png`).
2. **LMS:** nộp link GitHub (commit/tag cuối) + file tổng hợp nếu LMS yêu cầu. Đảm bảo link public hoặc đã share cho giảng viên.
3. **Quy tắc đặt tên:** dùng đúng tên file/thư mục trong đề. Ảnh đặt dưới `docs/evidence/<buoi>-<ten>.png` (ví dụ `docs/evidence/01-dbeaver.png`).

### Quy ước minh chứng (áp dụng cho mọi buổi)
- **Task setup/môi trường** (Docker, DBeaver, venv): nộp **screenshot + file cấu hình + log/output**. Ví dụ: ảnh `docker compose ps` hiện `running`, ảnh DBeaver báo `Connected`, output `SELECT version();`.
- **Task code/SQL/Python**: nộp **file code + output/log chạy thực tế**. Ví dụ: `.sql` chạy không lỗi + file `.csv` kết quả hoặc ảnh kết quả query; `.py` + `logs/*.log`.
- **Task báo cáo/phân tích**: nộp **file báo cáo + số liệu trả lời**. Ví dụ: `docs/query_results.csv` kèm câu trả lời bằng số trong file `docs/answers.md` hoặc comment đầu file SQL.
- Mỗi Task trong đề đều có 3 mục: `Yêu cầu chi tiết` (phải làm gì, các bước gợi ý) → `Kết quả cần đạt` (thế nào là xong) → `Minh chứng phải nộp` (nộp gì, ở đâu, ví dụ output). Chỉ tick Done khi có đủ minh chứng.

---

## Lưu ý

- Deadline: Trước buổi học tiếp theo
- Format: Git commit hoặc nộp qua LMS
- Reflection: Yêu cầu cho tất cả buổi
- Bonus: Có thể dùng để cứu điểm buổi khác
