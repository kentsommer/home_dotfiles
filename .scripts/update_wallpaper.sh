#!/bin/bash

# --- CONFIGURATION ---
WP_DIR="$HOME/.wallpapers"
STATE_FILE="$WP_DIR/.current_wallpaper"
LOG_FILE="$WP_DIR/.wallpaper_log"
MAX_LOG_SIZE=51200
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
HOUR=$(date +%H)

log_message() {
    if [ -f "$LOG_FILE" ] && [ $(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null) -gt $MAX_LOG_SIZE ]; then
        echo "$(date): Log rotated" > "$LOG_FILE"
    fi
    echo "$(date): $1" >> "$LOG_FILE"
}

# --- 1. IDEMPOTENT INSTALLATION (LINUX) ---
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SERVICE_DIR="$HOME/.config/systemd/user"
    mkdir -p "$SERVICE_DIR"
    
    # Define desired content
    SERVICE_CONTENT="[Unit]
Description=Update wallpaper based on time
After=graphical-session.target

[Service]
Type=oneshot
ExecStart=/bin/bash \"$SCRIPT_PATH\"
StandardOutput=append:$LOG_FILE
StandardError=append:$LOG_FILE

[Install]
WantedBy=graphical-session.target"

    # Only write and reload if the content differs or file is missing
    if [[ ! -f "$SERVICE_DIR/wallpaper.service" ]] || [[ "$(cat "$SERVICE_DIR/wallpaper.service")" != "$SERVICE_CONTENT" ]]; then
        echo "$SERVICE_CONTENT" > "$SERVICE_DIR/wallpaper.service"
        systemctl --user daemon-reload
        log_message "Systemd service file updated and daemon-reloaded."
    fi

    if [[ ! -f "$SERVICE_DIR/wallpaper.timer" ]]; then
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

# --- 1. IDEMPOTENT INSTALLATION (macOS) ---
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
        log_message "Launchd agent installed."
    fi
fi

# --- 2. WALLPAPER LOGIC ---
if [ "$HOUR" -ge 5 ] && [ "$HOUR" -lt 12 ]; then
    IMAGE="morning.jpg"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 18 ]; then
    IMAGE="afternoon.jpg"
else
    IMAGE="night.jpg"
fi

# --- 3. CHANGE DETECTION ---
CURRENT_SAVED=$(cat "$STATE_FILE" 2>/dev/null)
if [ "$CURRENT_SAVED" == "$IMAGE" ] && [[ ! -t 1 ]]; then
    exit 0
fi

# --- 4. APPLY ---
WP_PATH="$WP_DIR/$IMAGE"
if [ ! -f "$WP_PATH" ]; then
    log_message "ERROR: File $IMAGE not found in $WP_DIR"
    exit 1
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/run/user/$(id -u)}
    export SWAYSOCK=${SWAYSOCK:-$(ls /run/user/$(id -u)/sway-ipc.*.sock 2>/dev/null | head -n 1)}

    if [ -z "$SWAYSOCK" ]; then
        log_message "ERROR: Could not find SWAYSOCK."
        exit 1
    fi

    if swaymsg "output * bg '$WP_PATH' fill" > /dev/null 2>&1; then
        log_message "Applied $IMAGE via swaymsg"
        echo "$IMAGE" > "$STATE_FILE"
    fi
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$WP_PATH\""
    log_message "Applied $IMAGE via AppleScript"
    echo "$IMAGE" > "$STATE_FILE"
fi
