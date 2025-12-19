#!/bin/bash

max_volume=1.5 # 150%
step=5         # increase or decrease by 5 (default)
icons_dir=~/.config/dunst/volume_icons

usage() {
    cat <<EOM
Usage: $(basename "$0") [OPTIONS]

    -i increase volume by 5%, max is 150%
    -l lower volume by 5%, min is 0%
    -m toggle mute/unmute

Optional:
    set step for increase/decrase (default: 5) (see Example)

Example:
    $(basename "$0") -i 10
    $(basename "$0") -m
EOM
    exit 0
}

[ -z "$1" ] && usage

# accepts a bool argument that decides which icon to show (volume up/down)
show_volume() {
    local volume_up="$1"
    local current_volume
    current_volume=$(pactl get-sink-volume "$(pactl get-default-sink)" | grep -o "[0-9]\+%" | head -n 1)

    if [ "$volume_up" = true ]; then
        dunstify -I "$icons_dir/volume_up.svg" -h string:x-canonical-private-synchronous:audio "Volume: ${current_volume}" -h int:value:"$current_volume"
    else
        dunstify -I "$icons_dir/volume_down.svg" -h string:x-canonical-private-synchronous:audio "Volume: ${current_volume}" -h int:value:"$current_volume"
    fi
}

increase() {
    # echo "Increasing volume by $step%"
    wpctl set-volume -l $max_volume @DEFAULT_AUDIO_SINK@ "$step"%+
    show_volume true
}

decrease() {
    # echo "Decreasing volume by $step%"
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "$step"%-
    show_volume false
}

mute() {
    # echo "Mute toggled"
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    local is_muted
    is_muted=$(pactl get-sink-mute "$(pactl get-default-sink)" | grep -o no)
    if [ "$is_muted" == "no" ]; then
        dunstify -I "$icons_dir/volume_off.svg" "Muted"
    else
        dunstify -I "$icons_dir/volume_on.svg" "Unmuted"
    fi
}

while getopts ":midh" flag; do
    case ${flag} in
    i)
        [ ! -z "$2" ] && step=$2
        increase
        ;;
    d)
        [ ! -z "$2" ] && step=$2
        decrease
        ;;
    m)
        mute
        ;;
    h)
        usage
        ;;
    *)
        echo "Invalid usage."
        usage
        ;;
    esac
done
