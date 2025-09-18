#!/usr/bin/env bash

#// Check if wlogout is already running

if pgrep -x "wlogout" >/dev/null; then
    pkill -x "wlogout"
    exit 0
fi

#// set file variables

confDir="${confDir:-$HOME/.config}"
wlogoutDir="${confDir}/wlogout"
wLayout="${wlogoutDir}/layout"
wlTmplt="${wlogoutDir}/style.css"
echo "wLayout: ${wLayout}"
echo "wlTmplt: ${wlTmplt}"

if [ ! -f "${wLayout}" ] || [ ! -f "${wlTmplt}" ]; then
    echo "ERROR: missing ${wLayout} or ${wlTmplt}" >&2
    exit 1
fi

#// detect monitor res

x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
hypr_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')

#// scale config layout and style
wlColms=6
export mgn=$((y_mon * 28 / hypr_scale))
export hvr=$((y_mon * 23 / hypr_scale))

#// scale font size

export fntSize=$((y_mon * 2 / 100))

# --- DETECT CURRENT WALLPAPER ---

# get the name of the focused monitor
FOCUSED="$(hyprctl -j monitors 2>/dev/null | jq -r '.[] | select(.focused==true) | .name' || true)"

WP="$(hyprctl hyprpaper listactive 2>/dev/null | awk -v m="$FOCUSED" -F ' = ' '$1==m{print $2; found=1} END{if(!found) exit 1}' || true)"

# --- BRIGHTNESS -> THEME (robust, handles % and raw) ---

theme_auto=""

if [ -n "${WP:-}" ] && [ -f "$WP" ]; then
    YRAW=$(magick "$WP" -resize 1x1\! -colorspace Gray -format "%[fx:mean]" info: 2>/dev/null || echo "")
    YRAW="${YRAW//[[:space:]]/}"

    if [ -n "$YRAW" ]; then
        # normalize
        if [[ "$YRAW" == *% ]]; then
            Y=$(awk -v v="${YRAW%\%}" 'BEGIN{printf "%.6f", v/100}')
        else
            Y=$(awk -v v="$YRAW" 'BEGIN{
        if (v>1 && v<=255)       v/=255;
        else if (v>255 && v<=65535) v/=65535;
        printf "%.6f", v
      }')
        fi

        if awk -v y="$Y" 'BEGIN{exit !(y>=0.55)}'; then
            theme_auto="white"
        else
            theme_auto="black"
        fi

        echo "DEBUG: WP='$WP' YRAW='$YRAW' Y=$Y -> $theme_auto" >&2
    fi
fi

# --- THEME ---
if [ -n "$theme_auto" ]; then
    theme="$theme_auto"
else
    theme="black"
fi

case "$theme" in
white)

    export MainBg='rgba(243, 238, 203, 0.80)'
    export BtnCol='black'

    export WbHvrBg='rgba(229, 222, 198, 0.12)'
    export WbActBg='rgba(214, 204, 170, 0.22)'
    ;;
black | dark)
    export MainBg='rgba(16,20,25,0.80)'
    export BtnCol='white'
    export WbActBg='rgba(255,255,255,0.12)'
    export WbHvrBg='rgba(255,255,255,0.22)'
    ;;
*)
    echo "Unknown theme: $theme (use: white|black)" >&2
    exit 2
    ;;
esac

#// eval hypr border radius

hypr_border="${hypr_border:-10}"
export active_rad=$((hypr_border * 5))
export button_rad=$((hypr_border * 8))

#// eval config files

wlStyle="$(envsubst <"${wlTmplt}")"

#// launch wlogout

wlogout -b "${wlColms}" -c 0 -r 0 -m 0 \
    --layout "${wLayout}" \
    --css <(echo "${wlStyle}") \
    --protocol layer-shell
