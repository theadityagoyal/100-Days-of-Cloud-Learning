# Required Tools for URL Monitor Script (WSL/Linux)

This script runs inside **WSL** (Windows Subsystem for Linux) and uses some basic Linux tools along with Windows PowerShell for toast notifications.

---

## 🛠 Required Tools

| Tool       | Purpose                                | Install Command (Ubuntu/Debian WSL)          |
|------------|--------------------------------------|----------------------------------------------|
| **bash**   | Shell to run the script               | Pre-installed by default                      |
| **curl**   | To check URL status codes             | `sudo apt install curl`                       |
| **awk**    | For processing log files              | `sudo apt install gawk`                       |
| **powershell** | For Windows toast notifications  | Installed on Windows, accessible via `powershell.exe` inside WSL |

---

## Optional Tools (for automation)

| Tool       | Purpose                                | Install Command (Ubuntu/Debian WSL)          |
|------------|--------------------------------------|----------------------------------------------|
| **cron**   | To schedule regular script execution  | `sudo apt install cron`                       |

---

## Environment Setup

### Windows Subsystem for Linux (WSL)

- WSL allows running Linux command line on Windows.
- If you don’t have it installed, run this command in **Windows PowerShell as Administrator**:

```powershell
wsl --install
