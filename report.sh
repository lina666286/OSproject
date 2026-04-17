#!/bin/bash
# report.sh - Generates and saves audit reports

REPORT_DIR="/var/log/sys_audit"
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
HOSTNAME=$(hostname)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/hardware_audit.sh"
source "$SCRIPT_DIR/software_audit.sh"

create_report_dir() {
    if [ ! -d "$REPORT_DIR" ]; then
        mkdir -p "$REPORT_DIR" 2>/dev/null
        if [ $? -ne 0 ]; then
            REPORT_DIR="$HOME/sys_audit_reports"
            mkdir -p "$REPORT_DIR"
            echo "[INFO] Using fallback report dir: $REPORT_DIR"
        fi
    fi
}

generate_short_report() {
    create_report_dir
    REPORT_FILE="$REPORT_DIR/short_report_${HOSTNAME}_${TIMESTAMP}.txt"

    {
        echo "============================================"
        echo "       SYSTEM AUDIT - SHORT REPORT"
        echo "============================================"
        echo "Date     : $(date)"
        echo "Hostname : $HOSTNAME"
        echo "--------------------------------------------"
        echo ""
        print_hardware_short
        echo ""
        print_software_short
        echo ""
        echo "============================================"
        echo "             END OF REPORT"
        echo "============================================"
    } > "$REPORT_FILE"

    echo "[OK] Short report saved: $REPORT_FILE"
    echo "$REPORT_FILE"
}

generate_full_report() {
    create_report_dir
    REPORT_FILE="$REPORT_DIR/full_report_${HOSTNAME}_${TIMESTAMP}.txt"

    {
        echo "============================================"
        echo "        SYSTEM AUDIT - FULL REPORT"
        echo "============================================"
        echo "Date     : $(date)"
        echo "Hostname : $HOSTNAME"
        echo "--------------------------------------------"
        echo ""
        print_hardware_full
        print_software_full
        echo "============================================"
        echo "             END OF REPORT"
        echo "============================================"
    } > "$REPORT_FILE"

    echo "[OK] Full report saved: $REPORT_FILE"
    echo "$REPORT_FILE"
}
