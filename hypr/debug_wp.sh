#!/usr/bin/env bash

LOG="$HOME/.local/state/hypr/start_wallpaper.log"
mkdir -p "$(dirname "$LOG")"

exec >>"$LOG" 2>&1

echo
echo "===== START $(date -Is) ====="
echo "PID=$$"
echo "SHELL=$SHELL"
echo "PATH=$PATH"
echo "HOME=$HOME"
echo "WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-}"
echo "XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-}"
echo "HYPRLAND_INSTANCE_SIGNATURE=${HYPRLAND_INSTANCE_SIGNATURE:-}"

echo "--- command paths ---"
command -v hyprpaper || true
command -v hyprctl || true
command -v bash || true

echo "--- starting hyprpaper ---"
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

echo "--- running random_wall.sh ---"
"$HOME/.config/hypr/random_wall.sh"
echo "random_wall.sh exit code: $?"

echo "--- running gen_waybar_theme.sh ---"
"$HOME/.config/waybar/gen_waybar_theme.sh"
echo "gen_waybar_theme.sh exit code: $?"

echo "===== DONE $(date -Is) ====="
