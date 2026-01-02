#!/bin/bash

# --- CONFIGURATION ---
WP_DIR="$HOME/.wallpapers"
STATE_FILE="$WP_DIR/.current_wallpaper"
LOG_FILE="$WP_DIR/.wallpaper_log"
MAX_LOG_SIZE=51200 # 50 KB
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
HOUR=$(date +%H)

# --- LOGGING FUNCTION ---
log_message() {
    # If log file is too big, truncate it
    if [ -f "$LOG_FILE" ] && [ $(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null) -gt $MAX_LOG_SIZE ]; then
        echo "$(date): Log rotated (cleared old entries)" > "$LOG_FILE"
    fi
    echo "$(date): $1" >> "$LOG_FILE"
}

# 1. OS DETECTION & IDEMPOTENT INSTALLATION
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SERVICE_DIR="$HOME/.config/systemd/user"
    mkdir -p "$SERVICE_DIR"

    cat <<EOF > "$SERVICE_DIR/wallpaper.service"
[Unit]
Description=Update wallpaper based on time
[Service]
Type=oneshot
ExecStart=/bin/bash "$SCRIPT_PATH"
EOF

    if [ ! -f "$SERVICE_DIR/wallpaper.timer" ]; then
        cat <<EOF > "$SERVICE_DIR/wallpaper.timer"
[Unit]
Description=Run wallpaper update hourly
[Timer]
OnCalendar=hourly
Persistent=true
[Install]
WantedBy=timers.target
EOF
        systemctl --user daemon-reload
        systemctl --user enable --now wallpaper.timer
        log_message "Systemd timer installed."
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLIST_PATH="$HOME/Library/LaunchAgents/com.$USER.wallpaper.plist"
    if [ ! -f "$PLIST_PATH" ]; then
        cat <<EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.$USER.wallpaper</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>$SCRIPT_PATH</string>
    </array>
    <key>StartCalendarInterval</key>
    <dict>
        <key>Minute</key>
        <integer>0</integer>
    </dict>
</dict>
</plist>
EOF
        launchctl load "$PLIST_PATH"
        log_message "Launchd agent installed for user: $USER"
    fi
fi

# 2. WALLPAPER LOGIC
if [ "$HOUR" -ge 5 ] && [ "$HOUR" -lt 12 ]; then
    IMAGE="morning.jpg"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 18 ]; then
    IMAGE="afternoon.jpg"
else
    IMAGE="night.jpg"
fi

# 3. CHANGE DETECTION
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" == "$IMAGE" ]; then
    log_message "No change detected, exiting."
    exit 0
fi

# 4. APPLY WALLPAPER
WP_PATH="$WP_DIR/$IMAGE"

if [ ! -f "$WP_PATH" ]; then
    log_message "ERROR: File $IMAGE not found in $WP_DIR"
    exit 1
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    pkill swaybg
    swaybg -i "$WP_PATH" -m fill > /dev/null 2>&1 &
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$WP_PATH\""
fi

log_message "Wallpaper changed to $IMAGE"
echo "$IMAGE" > "$STATE_FILE"
