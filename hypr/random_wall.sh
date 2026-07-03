#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/wallpapers"
# uncomment for logging
# LOG="$HOME/.local/state/hypr/start_wallpaper.log"
# mkdir -p "$(dirname "$LOG")"
# exec >>"$LOG" 2>&1
# echo
# echo "===== START $(date -Is) ====="
# echo "PID=$$"
# echo "HOME=$HOME"
# echo "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-}"
# echo "XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-}"

if pgrep -x hyprpaper >/dev/null; then
  echo "hyprpaper already running"
else
  hyprpaper &
  echo "hyprpaper started with PID $!"
fi

echo "--- waiting for hyprpaper IPC ---"
ready=0

for i in {1..50}; do
  if hyprctl hyprpaper listactive >/dev/null 2>&1; then
    echo "hyprpaper IPC ready after $i tries"
    ready=1
    break
  fi

  echo "hyprpaper not ready yet: try $i"
  sleep 0.1
done

if [[ "$ready" -ne 1 ]]; then
  echo "ERROR: hyprpaper IPC did not become ready"
  exit 1
fi

# get the list of the images
mapfile -d '' IMAGES < <(find "$DIR" -type f \
  \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0)

if ((${#IMAGES[@]} == 0)); then
  echo "[ERR] No images in $DIR" >&2
  exit 1
fi

IMG="${IMAGES[RANDOM % ${#IMAGES[@]}]}"

# get monitors' names
readarray -t MONS < <(hyprctl -j monitors | jq -r '.[].name')
if ((${#MONS[@]} == 0)); then
  echo "[ERR] No monitors found via hyprctl" >&2
  exit 2
fi

echo "$MONS"
echo "$IMG"

for m in "${MONS[@]}"; do
  hyprctl hyprpaper wallpaper "$m,$IMG" >/dev/null
done

echo "[OK] Set $IMG for: ${MONS[*]}"

# echo "===== DONE $(date -Is) ====="
