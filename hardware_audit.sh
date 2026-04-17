#!/bin/bash
# hardware_audit.sh - Collects hardware information

collect_hardware_info() {
    CPU_MODEL=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2 | xargs)
    CPU_CORES=$(nproc)
    CPU_ARCH=$(uname -m)
    ShoDisk=$(df -h --total | grep total | awk '{print "Total: " $2 " Used: " $3}')

    RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
    RAM_AVAILABLE=$(free -h | awk '/^Mem:/ {print $7}')

    DISK_INFO=$(df -h --output=source,size,used,avail,fstype | grep -v tmpfs | grep -v udev | tail -n +2)

    NET_INTERFACES=$(ip -o link show | awk '{print $2}' | tr -d ':')

    MAC_IP=$(ip -o addr show | awk '{print $2, $4}')

    MB_INFO=$(cat /sys/class/dmi/id/board_vendor 2>/dev/null || echo "N/A")
    MB_NAME=$(cat /sys/class/dmi/id/board_name 2>/dev/null || echo "N/A")

    USB_DEVICES=$(lsusb 2>/dev/null || echo "lsusb not available")

    GPU_INFO=$(lspci 2>/dev/null | grep -i vga | cut -d: -f3 | xargs || echo "N/A")
}

print_hardware_short() {
    collect_hardware_info
    echo "=== HARDWARE SUMMARY ==="
    echo "CPU     : $CPU_MODEL ($CPU_CORES cores, $CPU_ARCH)"
    echo "RAM     : Total=$RAM_TOTAL | Available=$RAM_AVAILABLE"
    echo "GPU     : $GPU_INFO"
    echo "Network : $NET_INTERFACES"
    echo "Hard Disk :$ShoDisk"
    echo "========================="
}

print_hardware_full() {
    collect_hardware_info
    echo "========================================"
    echo "        HARDWARE FULL AUDIT REPORT"
    echo "========================================"
    echo ""
    echo "--- CPU ---"
    echo "Model        : $CPU_MODEL"
    echo "Cores        : $CPU_CORES"
    echo "Architecture : $CPU_ARCH"
    echo ""
    echo "--- GPU ---"
    echo "$GPU_INFO"
    echo ""
    echo "--- RAM ---"
    echo "Total        : $RAM_TOTAL"
    echo "Available    : $RAM_AVAILABLE"
    echo ""
    echo "--- DISK ---"
    echo "$DISK_INFO"
    echo ""
    echo "--- NETWORK INTERFACES ---"
    echo "$NET_INTERFACES"
    echo ""
    echo "--- MAC / IP ADDRESSES ---"
    echo "$MAC_IP"
    echo ""
    echo "--- MOTHERBOARD ---"
    echo "Vendor : $MB_INFO"
    echo "Name   : $MB_NAME"
    echo ""
    echo "--- USB DEVICES ---"
    echo "$USB_DEVICES"
    echo ""
}
print_hardware_short
print_hardware_full
