#!/bin/bash
# software_audit.sh - Collects OS and software information

collect_software_info() {
    OS_NAME=$(. /etc/os-release && echo "$PRETTY_NAME")
    KERNEL=$(uname -r)
    ARCH=$(uname -m)

    if command -v dpkg &>/dev/null; then
        PKG_COUNT=$(dpkg -l 2>/dev/null | grep "^ii" | wc -l)
        PKG_LIST=$(dpkg -l 2>/dev/null | grep "^ii" | awk '{print $2, $3}')
    elif command -v rpm &>/dev/null; then
        PKG_COUNT=$(rpm -qa 2>/dev/null | wc -l)
        PKG_LIST=$(rpm -qa 2>/dev/null)
    else
        PKG_COUNT="N/A"
        PKG_LIST="Package manager not detected"
    fi

    LOGGED_USERS=$(who)

    RUNNING_SERVICES=$(systemctl list-units --type=service --state=running 2>/dev/null | grep ".service" | awk '{print $1}' || echo "systemctl not available")
    TOP_PROCESSES=$(ps -eo user,pid,%cpu,%mem,time,comm --sort=-%cpu 2>/dev/null | head -11)
    #TOP_PROCESSES=$(ps aux --sort=-%cpu 2>/dev/null | head -10)

    OPEN_PORTS=$(ss -tuln 2>/dev/null || netstat -tuln 2>/dev/null || echo "Could not retrieve ports")
}

print_software_short() {
    collect_software_info
    echo "=== SOFTWARE SUMMARY ==="
    echo "OS       : $OS_NAME"
    echo "Kernel   : $KERNEL"
    echo "Arch     : $ARCH"
    echo "Packages : $PKG_COUNT installed"
    echo "Users    : $(who | awk '{print $1}' | sort -u | tr '\n' ' ')"
    echo "=========================="
}

print_software_full() {
    collect_software_info
    echo "========================================"
    echo "        SOFTWARE FULL AUDIT REPORT"
    echo "========================================"
    echo ""
    echo "--- OPERATING SYSTEM ---"
    echo "OS Name  : $OS_NAME"
    echo "Kernel   : $KERNEL"
    echo "Arch     : $ARCH"
    echo ""
    echo "--- INSTALLED PACKAGES ($PKG_COUNT total) ---"
    echo "$PKG_LIST" | head -50
    echo "(showing first 50 packages)"
    echo ""
    echo "--- LOGGED-IN USERS ---"
    echo "$LOGGED_USERS"
    echo ""
    echo "--- RUNNING SERVICES ---"
    echo "$RUNNING_SERVICES"
    echo ""
    echo "--- TOP 10 PROCESSES (by CPU) ---"
    echo "$TOP_PROCESSES"
    echo ""
    echo "--- OPEN PORTS ---"
    echo "$OPEN_PORTS"
    echo ""
}
