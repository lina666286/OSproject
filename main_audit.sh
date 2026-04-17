#!/bin/bash
# main_audit.sh - Main entry point for the audit system

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/hardware_audit.sh"
source "$SCRIPT_DIR/software_audit.sh"
source "$SCRIPT_DIR/report.sh"
source "$SCRIPT_DIR/email_sender.sh"

LOG_FILE="$HOME/sys_audit_reports/audit_exec.log"
mkdir -p "$(dirname $LOG_FILE)"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

run_short() {
    log "Starting SHORT audit..."
    REPORT_PATH=$(generate_short_report | tail -1)
    log "Short report created: $REPORT_PATH"
    echo ""
    cat "$REPORT_PATH"
    echo ""
    echo "Report saved to: $REPORT_PATH"
}

run_full() {
    log "Starting FULL audit..."
    REPORT_PATH=$(generate_full_report | tail -1)
    log "Full report created: $REPORT_PATH"
    echo ""
    cat "$REPORT_PATH"
    echo ""
    echo "Report saved to: $REPORT_PATH"
}

run_email_short() {
    REPORT_PATH=$(generate_short_report | tail -1)
    send_report_email "$REPORT_PATH" "short"
    log "Short report emailed: $REPORT_PATH"
}

run_email_full() {
    REPORT_PATH=$(generate_full_report | tail -1)
    send_report_email "$REPORT_PATH" "full"
    log "Full report emailed: $REPORT_PATH"
}

show_menu() {
    echo ""
    echo "========================================"
    echo "   Linux System Audit Tool"
    echo "========================================"
    echo " 1) Run Short Audit (display + save)"
    echo " 2) Run Full Audit  (display + save)"
    echo " 3) Run Short Audit + Send Email"
    echo " 4) Run Full Audit  + Send Email"
    echo " 5) Exit"
    echo "========================================"
    echo -n "Choose an option [1-5]: "
}

# -- Non-interactive mode (for cron) --
if [ "$1" == "short" ]; then
    run_short
    exit 0
elif [ "$1" == "full" ]; then
    run_full
    exit 0
elif [ "$1" == "email-short" ]; then
    run_email_short
    exit 0
elif [ "$1" == "email-full" ]; then
    run_email_full
    exit 0
fi

# -- Interactive menu --
while true; do
    show_menu
    read CHOICE
    case $CHOICE in
        1) run_short ;;
        2) run_full ;;
        3) run_email_short ;;
        4) run_email_full ;;
        5) echo "Goodbye."; exit 0 ;;
        *) echo "[!] Invalid option." ;;
    esac
done
