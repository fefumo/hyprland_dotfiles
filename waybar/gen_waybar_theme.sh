#!/usr/bin/env bash
set -euo pipefail

CFG_DIR="${HOME}/.config/waybar"
COLORS_FILE="${CFG_DIR}/colors.css"

# -------- detect focused monitor & its wallpaper --------
FOCUSED="$(hyprctl -j monitors 2>/dev/null | jq -r '.[] | select(.focused==true) | .name' || true)"
WP="$(hyprctl hyprpaper listactive 2>/dev/null | awk -v m="$FOCUSED" -F ' = ' '$1==m{print $2; found=1} END{if(!found) exit 1}' || true)"

theme_auto=""

# same detection as in wlogout/logoutlaunch.sh
if [ -n "${WP:-}" ] && [ -f "$WP" ]; then
    YRAW=$(magick "$WP" -resize 1x1\! -colorspace Gray -format "%[fx:mean]" info: 2>/dev/null || echo "")
    YRAW="${YRAW//[[:space:]]/}"
    if [ -n "$YRAW" ]; then
        if [[ "$YRAW" == *% ]]; then
            Y=$(awk -v v="${YRAW%\%}" 'BEGIN{printf "%.6f", v/100}')
        else
            Y=$(awk -v v="$YRAW" 'BEGIN{
                if (v>1 && v<=255)       v/=255;
                else if (v>255 && v<=65535) v/=65535;
                printf "%.6f", v
            }')
        fi
        if awk -v y="$Y" 'BEGIN{exit !(y>=0.5)}'; then
            theme_auto="white"
        else
            theme_auto="dark"
        fi
        echo "WAYBAR THEME: WP='$WP' YRAW='$YRAW' Y=$Y -> $theme_auto" >&2
    fi
fi

theme="${theme_auto:-dark}"

case "$theme" in
white)
    # expressive white mode
    export TranspBg='rgba(190, 180, 204, 0.65)'
    export Text='#0b1220'
    export MainBg='rgba(0, 0, 0, 0.2)'
    export Work='rgba(140, 219, 213, 0.7)'
    ;;
black | dark)
    export TranspBg='rgba(9,13,20,0.40)'
    export Text='#eef3ff'
    export MainBg='rgba(180,190,254,0.18)'
    export Work='#b4befe'
    ;;
*)
    echo "Unknown theme: $theme (use: white|black)" >&2
    exit 2
    ;;
esac

# --- render CSS via envsubst and (re)launch Waybar ---
CSS_TMPL="$HOME/.config/waybar/style.css"
CSS_EXPANDED="$(envsubst <"$CSS_TMPL")"

if pgrep -x waybar >/dev/null 2>&1; then
    pkill -x waybar
fi

bash -lc "waybar -c $HOME/.config/waybar/config.jsonc -s <(printf '%s\n' \"$CSS_EXPANDED\")" >/dev/null 2>&1 &
