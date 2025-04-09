#!/bin/bash

set -e

# --- Detect distro
detect_distro() {
    if command -v apt >/dev/null; then
        echo "debian"
    elif command -v pacman >/dev/null; then
        echo "arch"
    elif command -v dnf >/dev/null; then
        echo "fedora"
    elif command -v xbps-install >/dev/null; then
        echo "void"
    else
        echo "unsupported"
    fi
}

echo "🌀 Installing FeedVoid..."

# --- Check root
if [[ $EUID -ne 0 ]]; then
    echo "❌ Please run as root (sudo ./install_feedvoid.sh)"
    exit 1
fi

DISTRO=$(detect_distro)

# --- Install python and pip
install_python() {
    echo "📦 Installing Python and pip for $DISTRO..."

    case "$DISTRO" in
        debian)
            apt update
            apt install -y python3 python3-pip
            ;;
        arch)
            pacman -Sy --noconfirm python python-pip
            ;;
        fedora)
            dnf install -y python3 python3-pip
            ;;
        void)
            xbps-install -Sy python3 python3-pip
            ;;
        *)
            echo "⚠️ Unsupported distro. Install Python3 and pip manually."
            exit 1
            ;;
    esac
}

install_python

# --- Copy the script
echo "📁 Installing FeedVoid to /usr/bin/feedvoid..."
install -m 755 ./feedvoid /usr/bin/feedvoid

# --- Final
echo "✅ Installed! Run with: feedvoid or feedvoid --gui"
