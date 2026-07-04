#!/usr/bin/env sh

rsync -av --delete ~/.config/nvim/lua/ ./nvim/
rsync -av --delete ~/.config/hypr/ ./hypr/
rsync -av --delete ~/.config/alacritty/ ./alacritty/
rsync -av --delete ~/.config/rofi/ ./rofi/
rsync -av --delete ~/.config/waybar/ ./waybar/
rsync -av --delete ~/.config/wlogout/ ./wlogout/
rsync -av --delete ~/.config/dunst/ ./dunst/

rsync -av ~/.bashrc ./
rsync -av ~/.zshrc ./
rsync -av ~/.local/share/sioyek/shared.db ./sioyek/
