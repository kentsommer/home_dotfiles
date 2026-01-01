#!/bin/bash

# --- CRON INSTALLATION ---
SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
CRON_JOB="0 * * * * /bin/bash $SCRIPT_PATH"

if ! crontab -l 2>/dev/null | grep -Fq "$SCRIPT_PATH"; then
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Successfully added wallpaper job to crontab."
fi

# --- WALLPAPER CONFIGURATION ---
WP_DIR="$HOME/.wallpapers"
STATE_FILE="$WP_DIR/.current_wallpaper"
HOUR=$(date +%H)

# Set image based on the time of day
if [ "$HOUR" -ge 5 ] && [ "$HOUR" -lt 12 ]; then
    IMAGE="morning.jpg"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -lt 18 ]; then
    IMAGE="afternoon.jpg"
else
    IMAGE="night.jpg"
fi

# --- CHANGE DETECTION ---
if [ -f "$STATE_FILE" ]; then
    CURRENT_SAVED=$(cat "$STATE_FILE")
    if [ "$CURRENT_SAVED" == "$IMAGE" ]; then
        exit 0
    fi
fi

# --- APPLY WALLPAPER ---
WP_PATH="$WP_DIR/$IMAGE"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    pkill swaybg
    swaybg -i "$WP_PATH" -m fill > /dev/null 2>&1 &
    
elif [[ "$OSTYPE" == "darwin"* ]]; then
    osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$WP_PATH\""
fi

# --- Update state file ---
echo "$IMAGE" > "$STATE_FILE"
