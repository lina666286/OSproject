#!/bin/bash
# email_sender.sh - Sends audit report via email

# -- Configuration --
RECIPIENT_EMAIL="aissanilina471@gmail.com" #edit this line to change recipient
SENDER_EMAIL="auditbot@example.com"
SUBJECT_SHORT="[Audit] Short Report - $(hostname) - $(date '+%Y-%m-%d')"
SUBJECT_FULL="[Audit] Full Report - $(hostname) - $(date '+%Y-%m-%d')"

send_report_email() {
    local REPORT_FILE="$1"
    local REPORT_TYPE="$2"  # "short" or "full"

    if [ -z "$REPORT_FILE" ] || [ ! -f "$REPORT_FILE" ]; then
        echo "[ERROR] Report file not found: $REPORT_FILE"
        return 1
    fi

    if [ "$REPORT_TYPE" == "short" ]; then
        SUBJECT="$SUBJECT_SHORT"
    else
        SUBJECT="$SUBJECT_FULL"
    fi

    # Try mail command first
    if command -v mail &>/dev/null; then
        mail -s "$SUBJECT" "$RECIPIENT_EMAIL" < "$REPORT_FILE"
        echo "[OK] Email sent to $RECIPIENT_EMAIL using 'mail'"

    # Try mutt
    elif command -v mutt &>/dev/null; then
        mutt -s "$SUBJECT" -a "$REPORT_FILE" -- "$RECIPIENT_EMAIL" < /dev/null
        echo "[OK] Email sent using 'mutt'"

    # Try msmtp (common on Ubuntu/Kali)
    elif command -v msmtp &>/dev/null; then
        {
            echo "To: $RECIPIENT_EMAIL"
            echo "From: $SENDER_EMAIL"
            echo "Subject: $SUBJECT"
            echo ""
            cat "$REPORT_FILE"
        } | msmtp "$RECIPIENT_EMAIL"
        echo "[OK] Email sent using 'msmtp'"

    else
        echo "[WARNING] No mail tool found. Install 'mailutils' or 'msmtp'."
        echo "  To install: sudo apt install mailutils"
        return 1
    fi
}
