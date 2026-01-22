#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/wallpapers"

# get the list of the images
mapfile -d '' IMAGES < <(find "$DIR" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) -print0)

if ((${#IMAGES[@]} == 0)); then
    echo "[ERR] No images in $DIR" >&2
    exit 1
fi

IMG="${IMAGES[RANDOM % ${#IMAGES[@]}]}"

if ! pgrep -x hyprpaper >/dev/null 2>&1; then
    hyprpaper &
    sleep 0.2
fi

# get monitors' names
readarray -t MONS < <(hyprctl -j monitors | jq -r '.[].name')
if ((${#MONS[@]} == 0)); then
    echo "[ERR] No monitors found via hyprctl" >&2
    exit 2
fi
# echo "$MONS"
# echo "$IMG"

for m in "${MONS[@]}"; do
    hyprctl hyprpaper wallpaper "$m,$IMG," >/dev/null
done

echo "[OK] Set $IMG for: ${MONS[*]}"
