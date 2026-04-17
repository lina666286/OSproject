#!/bin/bash
# cron.sh - Installs multiple cron jobs at different minutes

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_SCRIPT="$SCRIPT_DIR/main_audit.sh"

LOG_DIR="$HOME/sys_audit_reports"
mkdir -p "$LOG_DIR"
CRON_LOG="$LOG_DIR/cron_execution.log"

# Remove old cron jobs first
crontab -r 2>/dev/null

# Add each job with a different minute
(crontab -l 2>/dev/null; echo "13 14 * * * $MAIN_SCRIPT full >> $CRON_LOG 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "14 14 * * * $MAIN_SCRIPT short >> $CRON_LOG 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "15 14 * * * $MAIN_SCRIPT email-full >> $CRON_LOG 2>&1") | crontab -
(crontab -l 2>/dev/null; echo "16 14 * * * $MAIN_SCRIPT email-short >> $CRON_LOG 2>&1") | crontab -

echo "[OK] Cron jobs installed at different minutes:"
echo "  14:13 - full report (save only)"
echo "  14:14 - short report (save only)"
echo "  14:15 - email-full (save + email)"
echo "  14:16 - email-short (save + email)"
echo ""
echo "Current cron jobs:"
crontab -l