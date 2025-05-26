# URL Watcher with Windows Toasts 

Ever wondered if your APIs, dashboards, or portals were secretly down while you were sipping chai?  
This script is your cool little watchdog. It checks the status of all your favorite URLs and **pops toast notifications on Windows** (yes, from inside WSL!).

---

## Problem Statement

> "My app went down, and I found out only when the client screamed at me..."

Relatable? Let’s fix that.

This script automatically pings all your URLs and alerts you with a toast notification whenever something breaks — or just to say “everything’s cool.”

---

## Features

- Checks multiple URLs using `curl`.
- Sends **Windows toast notifications** using PowerShell inside WSL.
- Maintains a rotating log with the latest 20 checks.
- Uses Indian Standard Time (IST) by default.
- Gives you a geeky DevOps flex without needing Node or Python.

---

## Installation

### 1. Clone the repo

```bash
git clone https://github.com/theadityagoyal/100-Days-of-Cloud-Learning
cd url-watcher
```

### 2. Make the script executable

```bash
chmod +x monitor-toast.sh
```

### 3. Add or modify URLs

Open `monitor-toast.sh` and edit the `declare -A URLS=(...)` section to add your own endpoints.

### 4. Run it manually

```bash
./monitor-toast.sh
```

OR add it to your crontab for regular checks.

---

## What’s This “Toast”?

It’s a small notification popup from Windows that makes sure you know something just happened — like one of your APIs dying.  
Your WSL terminal + PowerShell = pop magic 

---

## Logs

Logs are saved in:

```bash
~/url_monitor.log
```

Each block is timestamped and shows URL statuses with ✅ or ❌.

---

## Sample Output

```text
2025-05-26 13:00:00 IST
1. Web - Ubihrm Portal is ✅ UP
2. App - GetInfo API is ❌ DOWN (Status: 503)
...
```

---

## Tech Used

- `bash`
- `curl`
- `awk`
- `powershell.exe` (for toasts inside WSL)
-  your brain (for writing cool scripts)

---

## Fun Fact

> Toast notifications are more satisfying than logs.  
> This script will even tell your Windows taskbar,  
> **"Bro, one of your APIs just ghosted you."**
