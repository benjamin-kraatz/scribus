#!/usr/bin/env bash
set -euo pipefail

# Kill previous instances if they exist.
pkill -f '/usr/local/bin/scribus -platform vnc:port=5901,size=1600x1000' >/dev/null 2>&1 || true
pkill -f 'websockify --web /usr/share/novnc/ 6080 localhost:5901' >/dev/null 2>&1 || true

# Start Scribus with Qt's built-in VNC platform.
/usr/local/bin/scribus -platform vnc:port=5901,size=1600x1000 > /tmp/scribus-vnc.log 2>&1 &

# Start noVNC websocket proxy.
websockify --web /usr/share/novnc/ 6080 localhost:5901 > /tmp/scribus-novnc.log 2>&1 &

echo "Scribus VNC started on port 5901"
echo "noVNC web UI available on port 6080"
echo "Open: http://localhost:6080/vnc.html?autoconnect=1&resize=remote"
