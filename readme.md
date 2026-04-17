
# Linux System Audit Tool
**NSCS - Mini Project Part 1 | OS2 | 2025/2026**

## What This Does
This is a set of shell scripts that automatically collect hardware and software information from a Linux machine, generate a report (short or full), send it by email, and can also run on a remote machine via SSH.

---

## File Structure
```
sys_audit_project/
├── scripts/
│   ├── main_audit.sh        <- Main script (run this)
│   ├── hardware_audit.sh    <- Hardware info collection
│   ├── software_audit.sh    <- OS and software info
│   ├── report.sh            <- Report generation
│   ├── email_sender.sh      <- Email sending
│   └── cr.sh SSH.sh    <- SSH remote monitoring
|   
├
└── README.md
```

---

## Installation

### Requirements
- A Linux distribution (Ubuntu, Kali, Debian...)
- Bash shell
- Optional: `mailutils` or `msmtp` for email
- Optional: `openssh-client` for remote monitoring

### Install optional email tool
```bash
sudo apt install mailutils
```

### Make scripts executable
```bash
chmod +x scripts/*.sh
```

---

## Configuration

### Email (edit scripts/email_sender.sh)
Open the file and change these two lines:
```bash
RECIPIENT_EMAIL="admin@example.com"   # <- your email here
SENDER_EMAIL="auditbot@example.com"   # <- sender address
```

### Remote Monitoring (edit scripts/remote_monitor.sh)
```bash
REMOTE_USER="user"             # <- SSH username on remote machine
REMOTE_IP="192.168.1.100"    # <- IP of remote machine
```

---

## How to Run

### Interactive Menu
```bash
bash scripts/main_audit.sh
```
Then choose from the menu:
1. Short audit (display + save)
2. Full audit (display + save)
3. Short audit + send email
4. Full audit + send email

### Command Line (for cron/automation)
```bash
bash scripts/main_audit.sh short        # short report
bash scripts/main_audit.sh full         # full report
bash scripts/main_audit.sh email-short  # short + email
bash scripts/main_audit.sh email-full   # full + email
```

### Remote Monitoring
```bash
# Run audit on remote machine
bash scripts/remote_monitor.sh run

# Retrieve a specific report from remote
bash scripts/remote_monitor.sh /path/to/remote/report.txt
```

---

## Automation with Cron

To run every day at 4:00 AM, open crontab:
```bash
crontab -e
```
Automation with Cron
One-time setup (automatically installs all jobs):
bash
./cr.sh
What cr.sh installs:
Time	Action
04:00 	Generate full report
04:01 	Generate short report
04:02 	Generate + email full report
04:03 	Generate + email short report
View installed cron jobs:
crontab -l
To remove all cron jobs:
crontab -r
To manually edit cron:
bash
crontab -e


## Report Location
By default, reports are saved to:
```
/var/log/sys_audit/
```
If permission is denied, they fall back to:
```
~/sys_audit_reports/
```
