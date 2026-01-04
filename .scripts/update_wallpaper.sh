#!/bin/bash

# --- CONFIGURATION ---
WP_DIR="$HOME/.wallpapers"
STATE_FILE="$WP_DIR/.current_wallpaper"
LOG_FILE="$WP_DIR/.wallpaper_log"
HYPR_CONF="$HOME/.config/hypr/hyprpaper.conf"
MAX_LOG_SIZE=51200
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
HOUR=$(date +%H)

# Check for force flag
FORCE=false
[[ "$1" == "--force" ]] && FORCE=true

log_message() {
    local FILE_SIZE
    if [[ "$OSTYPE" == "darwin"* ]]; then
        FILE_SIZE=$(stat -f%z "$LOG_FILE" 2>/dev/null || echo 0)
    else
        FILE_SIZE=$(stat -c%s "$LOG_FILE" 2>/dev/null || echo 0)
    fi
    [ "$FILE_SIZE" -gt "$MAX_LOG_SIZE" ] && echo "$(date): Log rotated" > "$LOG_FILE"
    echo "$(date): $1" >> "$LOG_FILE"
}

# --- 1. SYSTEMD/LAUNCHD INSTALLATION (IDEMPOTENT) ---
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    SERVICE_DIR="$HOME/.config/systemd/user"
    mkdir -p "$SERVICE_DIR"
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

    if [[ ! -f "$SERVICE_DIR/wallpaper.service" ]] || [[ "$(cat "$SERVICE_DIR/wallpaper.service")" != "$SERVICE_CONTENT" ]]; then
        echo "$SERVICE_CONTENT" > "$SERVICE_DIR/wallpaper.service"
        systemctl --user daemon-reload
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
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLIST_PATH="$HOME/Library/LaunchAgents/com.$USER.wallpaper.plist"
    if [ ! -f "$PLIST_PATH" ]; then
        cat <<EOF > "$PLIST_PATH"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.$USER.wallpaper</string>
    <key>ProgramArguments</key><array><string>/bin/bash</string><string>$SCRIPT_PATH</string></array>
    <key>StartCalendarInterval</key><dict><key>Minute</key><integer>0</integer></dict>
</dict>
</plist>
EOF
        launchctl load "$PLIST_PATH"
    fi
fi

# --- 2. TIME-BASED SELECTION ---
if [ "$HOUR" -ge 5 ] && [ "$HOUR" -lt 12 ]; then
    IMAGE="morning.jpg"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 18 ]; then
    IMAGE="afternoon.jpg"
else
    IMAGE="night.jpg"
fi

# --- 3. CHANGE DETECTION ---
CURRENT_SAVED=$(cat "$STATE_FILE" 2>/dev/null)
if [ "$CURRENT_SAVED" == "$IMAGE" ] && [ "$FORCE" = false ] && [[ ! -t 1 ]]; then
    exit 0
fi

# --- 4. APPLY ---
WP_PATH="$WP_DIR/$IMAGE"
if [ ! -f "$WP_PATH" ]; then
    log_message "ERROR: File $IMAGE not found in $WP_DIR"
    exit 1
fi

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Wait for monitors to settle if running on startup
    [ "$FORCE" = true ] && sleep 2

    # Get active monitors
    MONITORS=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')
    
    # Generate config using ONLY the wallpaper blocks
    true > "$HYPR_CONF" # Clear the file
    if [ -z "$MONITORS" ]; then
        # Fallback for startup if hyprctl is empty
        cat <<EOF >> "$HYPR_CONF"
splash = false

wallpaper {
    monitor =
    path = $WP_PATH
}
EOF
    else
        for MON in $MONITORS; do
            cat <<EOF >> "$HYPR_CONF"
splash = false

wallpaper {
    monitor = $MON
    path = $WP_PATH
}
EOF
        done
    fi

    # Restart process
    pkill hyprpaper
    sleep 0.3
    hyprpaper &
    
    log_message "Applied $IMAGE via wallpaper block. Monitors: ${MONITORS:-wildcard}"
    echo "$IMAGE" > "$STATE_FILE"
    notify-send -a "System" -i "$WP_PATH" "Wallpaper Updated" "Switched to $IMAGE"

elif [[ "$OSTYPE" == "darwin"* ]]; then
    osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$WP_PATH\""
    log_message "Applied $IMAGE (macOS)"
    echo "$IMAGE" > "$STATE_FILE"
fi
