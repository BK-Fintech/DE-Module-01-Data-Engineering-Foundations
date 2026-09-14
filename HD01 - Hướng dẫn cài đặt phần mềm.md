# HD01 - Hướng dẫn cài đặt phần mềm
### Khoá AI-Native Data Engineer - Module 1: Data Engineering Foundation

---

## 1. Tổng quan

| # | Công cụ (bắt buộc) | Phiên bản chuẩn khoá học | Mục đích trong khoá học | Link tải chính thức |
|---|---|---|---|---|
| 1 | **Python 3.11** | **3.11.x** (chuẩn theo checklist: 3.11.0) | Viết script xử lý dữ liệu, gọi API, làm việc với database, chạy pipeline (Buổi 5-8) | https://www.python.org/downloads/release/python-3110 |
| 2 | **Docker Desktop** | Bản mới nhất (4.x) | Chạy PostgreSQL 16 và Mock API trong container, không cần cài database trực tiếp lên máy | https://www.docker.com/products/docker-desktop |
| 3 | **Git** | Bản mới nhất (2.x) | Tải repository khoá học, quản lý version code, nộp bài | https://git-scm.com/install |
| 4 | **VS Code** (Code Editor) | Bản mới nhất | Soạn code Python/SQL, xem dữ liệu, chạy terminal | https://code.visualstudio.com/download |
| 5 | **DBeaver Community** (Database Client) | Bản Community (miễn phí) | Kết nối, xem và query PostgreSQL trực quan | https://dbeaver.io/download |

### Giải pháp thay thế

| Công cụ gốc | Giải pháp thay thế được chấp nhận | Không được thay thế |
|---|---|---|
| Python | **Không** - bắt buộc Python 3.11 để tương thích pandas, SQLAlchemy, psycopg, FastAPI trong `requirements.txt` | Anaconda/Miniconda, Python 3.9/3.10/3.12 (dễ lỗi dependency) |
| Docker Desktop | **Không** (trừ khi tự setup thủ công: cài PostgreSQL 16 trực tiếp + chạy Mock API bằng `uvicorn` - không khuyến khích) | Rancher Desktop, OrbStack, Colima, Podman |
| Git | **Không** | GitHub Desktop (chỉ là GUI bọc ngoài Git, vẫn cần Git) |
| VS Code | **PyCharm** - https://www.jetbrains.com/pycharm | - |
| DBeaver | **pgAdmin** - https://www.pgadmin.org | - |

### Thứ tự cài đặt khuyên dùng

```
1. Git → 2. Python 3.11 → 3. VS Code → 4. Docker Desktop → 5. DBeaver
```

### Cấu hình máy tối thiểu

| Thành phần | Tối thiểu | Khuyến nghị |
|---|---|---|
| **CPU** | 64-bit, ≥ 2 nhân | ≥ 4 nhân (Intel/AMD đời 2017+ hoặc Apple Silicon M1 trở lên) |
| **RAM** | 8 GB | ≥ 16 GB (để chạy cùng lúc Docker + VS Code + DBeaver + trình duyệt) |
| **Ổ cứng (trống)** | ≥ 10 GB | ≥ 20 GB |

---

## 2. Cách đọc hướng dẫn này

- Mỗi công cụ có **2 phần riêng: A. macOS và B. Windows**. Chỉ cần đọc phần đúng với máy của mình.
- Sau mỗi công cụ có **lệnh kiểm tra (verify)**. Cài xong phải chạy lệnh verify thấy `OK` mới sang bước tiếp theo.
- Lệnh cho macOS chạy trong **Terminal** (`Cmd + Space` → gõ `Terminal`). Lệnh cho Windows chạy trong **PowerShell** hoặc **Git Bash** (khuyên dùng PowerShell cho người mới).
- Bảng tổng hợp lệnh verify nhanh xem ở **Mục 8**.

---

## 3. Công cụ 1 - Python 3.11

Link: https://www.python.org/downloads/release/python-3110

### A. macOS (cả chip Intel và Apple Silicon M1/M2/M3/M4)

#### Cách 1 (khuyên dùng cho người mới): cài đặt từ python.org

1. Mở link trên → kéo xuống mục **Files** → chọn file phù hợp:
   - Máy **Apple Silicon (M1/M2/M3/M4)**: `macOS 64-bit universal2 installer`.
   - Máy **Intel**: `macOS 64-bit Intel-only installer` (bản universal2 cũng dùng được).
   - Không biết máy mình chip gì: logo Apple (góc trái) → **About This Mac / Giới thiệu về máy Mac này** → dòng **Chip**.
2. Mở file `.pkg` vừa tải → **Continue → Continue → Agree → Install** → nhập mật khẩu máy → **Close**.
3. Mở **Terminal**, chạy:
   ```bash
   python3.11 --version
   ```
   Kết quả đúng: `Python 3.11.x` (ví dụ `Python 3.11.9`).
4. Kiểm tra `pip`:
   ```bash
   python3.11 -m pip --version
   ```

#### Cách 2 (dành cho người đã quen với terminal): cài bằng Homebrew

1. Cài Homebrew (nếu chưa có):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
2. Cài Python 3.11 và Git:
   ```bash
   brew install git python@3.11
   ```
3. Verify:
   ```bash
   python3.11 --version
   brew list | grep python
   ```

#### Lỗi thường gặp (macOS)

| Hiện tượng | Cách sửa |
|---|---|
| `command not found: python3.11` | Đóng Terminal mở lại. Thử `python3 --version`. Nếu vẫn không thấy, cài lại file `.pkg` và chắc chắn không bỏ tick PATH. |
| `python3` ra 3.9 hoặc 3.13 của hệ thống | Luôn gõ rõ `python3.11` chứ không gõ `python3`. Trong khoá học mọi lệnh đều dùng `python3.11 -m venv`, `python3.11 -m pip`. |
| Lỗi SSL khi `pip install` | Chạy lại installer `.pkg`, bước cuối có nút cài chứng chỉ (Certificates) - bấm vào đó. |

### B. Windows 10 / 11 (64-bit)

1. Mở https://www.python.org/downloads/release/python-3110 → kéo xuống **Files** → tải **`Windows installer (64-bit)`** (file `python-3.11.x-amd64.exe`). Không tải bản `32-bit` hay `ARM64` trừ khi máy Surface ARM.
2. **Bước quan trọng nhất:** chạy file `.exe` → ở màn hình đầu tiên tick chọn **`Add python.exe to PATH`** (ô nhỏ ở cuối cửa sổ) → rồi mới bấm **Install Now**.
   - Nếu quên tick ô này, sau này gõ `python` sẽ báo lỗi. Phải gỡ ra cài lại.
3. Bấm **Disable path length limit** (nếu hiện) → **Close** → **khởi động lại máy** (hoặc ít nhất đóng hết PowerShell mở lại).
4. Mở **PowerShell** (chuột phải nút Start → **Terminal** hoặc gõ `PowerShell` trong Start menu), chạy:
   ```powershell
   python --version
   pip --version
   ```
   Kết quả đúng: `Python 3.11.x`.
5. Nếu máy có nhiều bản Python, dùng lệnh rõ ràng:
   ```powershell
   py -3.11 --version
   py -3.11 -m pip --version
   ```

#### Lỗi thường gặp (Windows)

| Hiện tượng | Cách sửa |
|---|---|
| `'python' is not recognized` | Do quên tick **Add to PATH**. Gỡ Python → cài lại và nhớ tick. Hoặc dùng `py -3.11` thay cho `python`. |
| `pip` báo lỗi quyền (Permission denied) | Mở PowerShell bằng **Run as Administrator** rồi chạy lại, hoặc thêm `--user`: `pip install --user <tên-lib>`. |
| Cài xong nhưng `python --version` vẫn ra 3.12 | Máy đang có 2 bản Python. Gỡ bản không dùng, hoặc trong khoá học luôn gọi `py -3.11`. |

### Verify Python (cả 2 hệ điều hành)

```bash
# macOS (Terminal):
python3.11 --version
# Windows (PowerShell):
python --version
# hoặc:
py -3.11 --version
```

---

## 4. Công cụ 2 - Docker Desktop

Link: https://www.docker.com/products/docker-desktop

### A. macOS

1. Mở link trên → bấm **Download for Mac**.
2. Chọn đúng chip:
   - **Apple Silicon (M1/M2/M3/M4)**: nút **Mac with Apple Silicon**.
   - **Intel**: nút **Mac with Intel chip**.
3. Mở file `.dmg` → kéo biểu tượng **Docker** vào thư mục **Applications**.
4. Mở **Docker Desktop** từ Launchpad lần đầu → chấp nhận **Terms**, nhập mật khẩu máy khi hỏi → chờ 1–3 phút cho Docker khởi động. Biểu tượng cá voi trên thanh menu phải hết quay và báo **Running**.
5. Mở **Terminal**, chạy:
   ```bash
   docker --version
   docker compose version
   ```
   Cả 2 lệnh đều phải ra version (ví dụ `Docker version 26.x`, `Docker Compose version v2.x`).
6. (Tuỳ chọn, cách nhanh bằng Homebrew):
   ```bash
   brew install --cask docker
   ```
   Sau đó vẫn phải mở Docker Desktop từ Applications một lần.

> Lưu ý macOS: Docker Desktop trên Mac chạy qua một máy ảo nhẹ nên lần đầu khởi động hơi lâu. Cấp cho Docker ít nhất 4GB RAM: Docker Desktop → **Settings (bánh răng) → Resources → Memory ≥ 4GB → Apply & Restart**.

### B. Windows

> Docker trên Windows **bắt buộc cần WSL2**. Đừng bỏ qua bước 1–2, nếu không Docker sẽ báo lỗi `WSL2 not installed`.

1. **Bật virtualization:** khởi động lại máy → vào BIOS (thường bấm `Del`/`F2`/`F12` khi vừa bật máy) → tìm **Intel VT-x / AMD-V** → chuyển sang **Enabled** → Save & Exit. Kiểm tra sau khi vào Win: Task Manager (`Ctrl+Shift+Esc`) → tab **Performance → CPU** → dòng **Virtualization: Enabled**.\
_Virtualization là tính năng phần cứng của CPU (Intel VT-x hoặc AMD-V) cho phép máy chạy các máy ảo/container_
2. **Cài/Update WSL2:** mở **PowerShell với quyền Admin** (chuột phải Start → Terminal (Admin)) → chạy:
   ```powershell
   wsl --install
   ```
   - Nếu đã có WSL1 cũ, update lên WSL2:
     ```powershell
     wsl --update
     wsl --set-default-version 2
     ```
   - Khởi động lại máy sau bước này.
3. **Tải Docker Desktop:** mở link trên → **Download for Windows** (file `Docker Desktop Installer.exe`, ~600MB).
4. Chạy installer → giữ nguyên tick **`Use WSL 2 instead of Hyper-V (recommended)`** → **OK** → **Close** → **khởi động lại máy**.
5. Mở **Docker Desktop** từ Start menu → chấp nhận Terms → chờ báo **Running** (góc dưới trái xanh).
6. Mở **PowerShell**, chạy:
   ```powershell
   docker --version
   docker compose version
   ```
7. (Cách nhanh bằng winget cho người quen lệnh):
   ```powershell
   winget install -e --id Docker.DockerDesktop
   ```

#### Lỗi thường gặp (Docker, cả 2 HĐH)

| Hiện tượng | Cách sửa |
|---|---|
| Docker báo `WSL2 not installed` (Windows) | Chạy `wsl --install` bằng Admin, restart máy, mở lại Docker. |
| `Cannot connect to the Docker daemon` / đèn đỏ | Docker Desktop chưa chạy. Mở Docker Desktop lên, chờ Running rồi chạy lại lệnh. |
| Cổng `5432 already in use` (học tới Buổi 1–2) | Máy đã có PostgreSQL cài trực tiếp. Tắt service đó hoặc đổi port. Kiểm tra: macOS `lsof -i :5432`, Windows `netstat -ano \| findstr 5432`. |
| Máy yếu, Docker ngốn RAM | Docker Settings → Resources → giảm Memory xuống 4GB, tắt bớt container không dùng: `docker ps`, `docker stop <tên>`. |
| Apple Silicon báo image không tương thích | Khoá học dùng `postgres:16` đã hỗ trợ ARM, cứ pull bình thường. Không dùng image cũ `postgres:9/10`. |

### Verify Docker (cả 2 HĐH)

```bash
docker --version
docker compose version
docker ps
```

---

## 5. Công cụ 3 - Git

Link: https://git-scm.com/install

### A. macOS

**Cách 1:**
```bash
xcode-select --install
```
Bấm **Install** trong popup. Hoặc:

**Cách 2:**
```bash
brew install git
```

**Cách 3:** tải installer `.dmg`/`.pkg` từ https://git-scm.com/install → **macOS** → mở file → Next tới hết.

Verify:
```bash
git --version
```

### B. Windows

1. Mở https://git-scm.com/install → **Windows** → tải bản **64-bit Git for Windows Setup** (hoặc nhanh bằng lệnh `winget install -e --id Git.Git`).
2. Chạy file `.exe` → cứ **Next** với các lựa chọn khuyên dùng cho khoá học:
   - Editor: giữ **Vim** hoặc đổi sang **Visual Studio Code** (dễ dùng hơn).
   - PATH: chọn **`Git from the command line and also from 3rd-party software`** (mặc định).
   - Line endings: chọn **`Checkout Windows-style, commit Unix-style`** (mặc định).
   - Terminal: chọn **Use Windows' default console** hoặc **MinTTY**.
   - Bấm **Install → Finish** (có thể tick `Launch Git Bash` để mở thử).
3. Mở **PowerShell** hoặc **Git Bash**, chạy:
   ```powershell
   git --version
   ```

### Cấu hình Git lần đầu (cả Mac và Windows - bắt buộc)

```bash
git config --global user.name "Ho Ten Cua Ban"
git config --global user.email "email-cua-ban@example.com"
git config --global init.defaultBranch main
git config --list
```

---

## 6. Công cụ 4 - VS Code (Code Editor)

Link: https://code.visualstudio.com/download

### A. macOS

1. Mở link → tải bản **macOS Universal** (dùng được cho cả Intel và Apple Silicon).
2. Mở file `.zip` → kéo **Visual Studio Code** vào **Applications**.
3. Mở VS Code lần đầu (chuột phải → **Open** nếu macOS chặn) → mở **Command Palette** (`Cmd+Shift+P`) → gõ **`Shell Command: Install 'code' command in PATH`** → Enter. Bước này để sau này gõ `code .` trong Terminal là mở được project.
4. Hoặc bằng Homebrew:
   ```bash
   brew install --cask visual-studio-code
   ```
5. Verify:
   ```bash
   code --version
   ```

### B. Windows

1. Mở link → tải bản **Windows → User Installer 64-bit** (máy cá nhân) hoặc **System Installer** (máy công ty cần admin).
2. Chạy `.exe` → tick thêm 2 ô rất hữu ích:
   - **`Add "Open with Code" to Explorer context menu`**.
   - **`Add to PATH`**.
   → **Next → Install → Finish**.
3. Hoặc bằng winget:
   ```powershell
   winget install -e --id Microsoft.VisualStudioCode
   ```
4. Verify trong PowerShell:
   ```powershell
   code --version
   ```

### Extension nên cài thêm (cả 2 HĐH)

Mở VS Code → biểu tượng **Extensions** (`Ctrl+Shift+X` / `Cmd+Shift+X`) → tìm và cài:

- `Python` + `Pylance` (Microsoft) - chạy/debug Python, gợi ý code.
- `Docker` (Microsoft) - xem container/image ngay trong VS Code.
- `GitLens` - xem lịch sử commit (hữu ích khi nộp bài).
- Trình duyệt dùng `dbdiagram.io` trên web, không cần cài thêm (dùng cho ERD Buổi 1).

---

## 7. Công cụ 5 - DBeaver Community
Link: https://dbeaver.io/download

### A. macOS

1. Mở link → tải bản **macOS (dmg)**. Hoặc 1 lệnh:
   ```bash
   brew install --cask dbeaver-community
   ```
2. Mở file `.dmg` → kéo **DBeaver** vào **Applications** → mở lần đầu bằng chuột phải → **Open**.
3. Kiểm tra nhanh trong Terminal:
   ```bash
   brew list --cask | grep dbeaver
   ```
   (Chỉ để xác nhận đã cài nếu dùng brew; nếu cài tay thì mở trong Applications là được.)

### B. Windows

1. Mở link → tải bản **Windows (installer)** 64-bit (file `.exe`, ~100MB). Hoặc:
   ```powershell
   winget install -e --id DBeaver.DBeaver.Community
   ```
2. Chạy `.exe` → **Next → Install → Finish**. Mở **DBeaver** từ Start menu.

### Kết nối thử tới PostgreSQL khoá học (làm sau khi đã `docker compose up`)

Học viên sẽ làm bước này ở Buổi 1, nhưng có thể test ngay sau cài đặt:

1. Đảm bảo đã chạy trong thư mục project:
   ```bash
   cp .env.example .env
   docker compose up -d postgres
   ```
2. Mở DBeaver → **New Database Connection (ổ cắm + dấu +)** → chọn **PostgreSQL** → **Next**.
3. Nhập đúng:
   - **Host:** `localhost`, **Port:** `5432`
   - **Database:** `ecommerce`
   - **Username:** `de_user`, **Password:** `de_password`
4. Bấm **Test Connection** → nếu thiếu driver, DBeaver sẽ hỏi tải driver → bấm **Download** → Test lại phải báo **Connected** → **Finish**.
5. Mở rộng `ecommerce → Schemas → public → Tables` để thấy các bảng sau khi chạy bootstrap.

---

## 8. Phần mềm thay thế

### 8.1. VS Code → PyCharm

- Link: https://www.jetbrains.com/pycharm
- Chọn bản nào?
  - **PyCharm Community**: miễn phí, đủ cho Python + SQL cơ bản trong khoá học.
  - **PyCharm Professional**: trả phí (miễn phí cho sinh viên với email .edu), hỗ trợ Docker/database mạnh hơn.
- Cài đặt:
  - **macOS:** tải `.dmg` (chọn đúng Apple Silicon / Intel) → kéo vào Applications.
  - **Windows:** tải `.exe` → tick **Add to PATH**, **Create Desktop Shortcut** → Install.
- Lưu ý khi dùng PyCharm thay VS Code: mọi lệnh terminal trong lab (`docker compose`, `python3.11 -m venv`, `pytest`) vẫn chạy trong **Terminal của PyCharm** (View → Tool Windows → Terminal). Giảng viên demo bằng VS Code nên nút bấm có thể khác vị trí - học viên tự đối chiếu.

### 8.2. DBeaver → pgAdmin

- Link: https://www.pgadmin.org
- Cài đặt:
  - **macOS:** tải bản `.dmg` → kéo vào Applications.
  - **Windows:** tải bản `.exe` → Next tới hết.
- Kết nối thử (tương đương DBeaver):
  1. Mở pgAdmin → chuột phải **Servers → Register → Server**.
  2. Tab **General → Name:** `ecommerce-local`.
  3. Tab **Connection → Host:** `localhost`, **Port:** `5432`, **Database:** `ecommerce`, **Username:** `de_user`, **Password:** `de_password` → tick **Save password** → **Save**.
- So sánh nhanh: DBeaver nhẹ, hỗ trợ nhiều loại database, phù hợp khoá học. pgAdmin chỉ làm việc với PostgreSQL nhưng giao diện query/monitor PostgreSQL chi tiết hơn.


## 8. Kiểm tra tổng thể sau khi cài đủ (trước Buổi 1)

### Bảng lệnh verify 

**macOS (Terminal):**
```bash
git --version
python3.11 --version
docker --version
docker compose version
code --version
```

**Windows (PowerShell):**
```powershell
git --version
python --version
docker --version
docker compose version
code --version
```

Tất cả phải in ra số version, không báo `not found / not recognized`.


### Chạy thử PostgreSQL + Mock API

```bash
cp .env.example .env
docker compose up -d postgres
docker ps
```

- `docker ps` phải thấy `ecommerce-postgres` trạng thái `Up`.
- Mở DBeaver/pgAdmin kết nối `localhost:5432` như Mục 7 để xác nhận.
- Từ Buổi 6 test thêm:
  ```bash
  docker compose up -d mock-api
  ```
  Mở trình duyệt `http://localhost:8000` phải thấy API (key mặc định `training-key`).

### Tạo môi trường Python cho project (làm 1 lần)

**macOS:**
```bash
python3.11 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

**Windows (PowerShell):**
```powershell
py -3.11 -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

Nếu PowerShell chặn activate (`execution policy`), chạy 1 lần bằng Admin:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
Rồi activate lại.

---

## 10. Lỗi hay gặp nhất (FAQ)

1. **Quên tick PATH khi cài Python/Git/VS Code trên Windows** → gỡ ra cài lại, nhớ tick. Đây là lỗi số 1 của học viên Windows.
2. **Mở Docker nhưng `docker ps` báo daemon** → Docker Desktop chưa Running. Mở app lên chờ xanh.
3. **DBeaver Test Connection thất bại** → 90% là do chưa chạy `docker compose up -d postgres`, hoặc sai password (`de_password` chứ không phải `postgres`). Kiểm tra file `.env`.
4. **`pip install -r requirements.txt` lỗi trên Python 3.12** → đang dùng sai version. Tạo lại venv bằng `python3.11` / `py -3.11`.
5. **Máy công ty chặn cài Docker (cần admin)** → nhờ IT cấp quyền, hoặc học tạm bằng PostgreSQL portable + chạy Mock API tay (báo trước cho giảng viên, không được hỗ trợ đầy đủ).
6. **macOS chặn mở app (unidentified developer)** → chuột phải app → **Open** → **Open** lần nữa, không double-click.

---

*Chúc học viên cài đặt thuận lợi và sẵn sàng cho khoá học AI Native Data Engineer!*
