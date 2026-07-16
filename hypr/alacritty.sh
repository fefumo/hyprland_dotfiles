#!/usr/bin/env bash
set -euo pipefail
#set -x

# Creates a new alacritty or kitty terminal with the current cwd
# by using hyprctl+jq on hyprland and
# `xdtotool` + `xprop` as fallback
# to detect if the current window is an alacritty window
# if so it starts alacritty with the same working directory,
# if no alacritty window has been detected it starts the terminal.
#
# Usage: terminal [OPTIONS]
# See $ (kitty|alacritty) --help
#
# Based on: https://github.com/i3/i3/discussions/6132
#

# Either "alacritty" or "kitty" is tested
term="alacritty"

XDG_CURRENT_DESKTOP="${XDG_CURRENT_DESKTOP:-"unknown"}"

get_parent_pid() {
  if [[ $XDG_CURRENT_DESKTOP == "Hyprland" ]]; then
    # Hyprland
    printf "%d\n" $(hyprctl activewindow -j | jq ".pid")
    return 0
  elif [[ $XDG_CURRENT_DESKTOP == "niri" ]]; then
    # Niri
    printf "%d\n" $(niri msg --json focused-window | jq '.pid')
    return 0
  else
    # Fallback to i3
    win_id="$(xdotool getactivewindow)"
    printf "%d\n" $(xprop -id "$win_id" _NET_WM_PID | grep -oP "\d+" | head -n 1)
    return 0
  fi

  return 1
}

start() {
  parent_pid=$(get_parent_pid)

  for pid in $(pgrep -P "$parent_pid"); do
    ps e -p "$pid" | grep -q "_WINDOW_ID" || continue

    shell_pwd="$(readlink -f /proc/"$pid"/cwd)"
    [[ -d $shell_pwd ]] || return 1
    exec $term --working-directory "${shell_pwd}" "$@"
    return 0
  done

  return 1
}

if ! start "$@"; then
  exec $term "$@"
fi
