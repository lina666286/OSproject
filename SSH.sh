
#!/bin/bash
# remote_audit.sh - Run audit on Ubuntu VM via SSH

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

REMOTE_USER="fella"
REMOTE_IP="10.58.226.174"

LOCAL_REPORT_DIR="$HOME/remote_reports"
REMOTE_SCRIPT_DIR="~/sys_audit_scripts"
REMOTE_REPORT_DIR="~/sys_audit_reports"

copy_scripts() {
    echo "[*] Copying scripts to $REMOTE_USER@$REMOTE_IP ..."
    ssh "$REMOTE_USER@$REMOTE_IP" "mkdir -p $REMOTE_SCRIPT_DIR"
    scp "$SCRIPT_DIR"/*.sh "$REMOTE_USER@$REMOTE_IP:$REMOTE_SCRIPT_DIR/"
    echo "[OK] Scripts copied"
}

run_remote_audit() {
    local TYPE="$1"
    echo "[*] Running $TYPE audit on Ubuntu VM..."
    ssh "$REMOTE_USER@$REMOTE_IP" "cd $REMOTE_SCRIPT_DIR && ./main_audit.sh $TYPE"
    echo "[*] Getting report from Ubuntu..."
    LATEST_REPORT=$(ssh "$REMOTE_USER@$REMOTE_IP" "ls -t $REMOTE_REPORT_DIR/*.txt 2>/dev/null | head -1" | tr -d '\r')
    if [ -z "$LATEST_REPORT" ]; then
        echo "[ERROR] No report found"
        return 1
    fi
    mkdir -p "$LOCAL_REPORT_DIR"
    scp "$REMOTE_USER@$REMOTE_IP:$LATEST_REPORT" "$LOCAL_REPORT_DIR/"
    echo "[OK] Report saved to: $LOCAL_REPORT_DIR/$(basename "$LATEST_REPORT")"
}

test_connection() {
    echo "[*] Testing SSH connection..."
    ssh "$REMOTE_USER@$REMOTE_IP" "echo 'SSH OK'"
}

case "$1" in
    test) test_connection ;;
    copy) copy_scripts ;;
    short) run_remote_audit "short" ;;
    full) run_remote_audit "full" ;;
    setup) test_connection && copy_scripts ;;
    *) echo "Usage: $0 {test|copy|setup|short|full}" ;;
esac