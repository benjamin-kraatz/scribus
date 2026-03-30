#!/usr/bin/env bash
set -euo pipefail

# Stop noVNC/websockify first, then Scribus VNC backend.
pkill -f 'websockify --web /usr/share/novnc/ 6080 localhost:5901' >/dev/null 2>&1 || true
pkill -f '/usr/local/bin/scribus -platform vnc:port=5901,size=1600x1000' >/dev/null 2>&1 || true

# Give processes a moment to exit, then force-kill any leftovers.
sleep 1
pkill -9 -f 'websockify --web /usr/share/novnc/ 6080 localhost:5901' >/dev/null 2>&1 || true
pkill -9 -f '/usr/local/bin/scribus -platform vnc:port=5901,size=1600x1000' >/dev/null 2>&1 || true

echo "Stopped Scribus VNC and noVNC services"
