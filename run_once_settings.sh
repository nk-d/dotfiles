#!/bin/bash

SOURCE_DIR=$(chezmoi source-path)

. "$SOURCE_DIR/scripts/utils"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "System configuration\n"

ask_for_sudo

execute "(getent group docker | grep $USER) || sudo usermod -aG docker $USER" \
	"No sudo required for docker users (logout required!)"

execute "getent group pcap || (sudo groupadd pcap && sudo usermod -aG pcap $USER)" \
	"Create pcap group (logout required!)"

execute "sudo chgrp pcap /usr/sbin/tcpdump && sudo chmod 750 /usr/sbin/tcpdump \
         && sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump" \
	"No sudo required for tcpdumping"

execute "(getent group vboxusers | grep $USER) || sudo usermod -aG vboxusers $USER" \
	"User added to vboxusers group (logout required!)"

executo "export _JAVA_AWT_WM_NONREPARENTING='1 phpstorm'" \
	"Added variable for JetBrains apps"

if [ "$SHELL" != "/usr/bin/fish" ]; then
	chsh -s /usr/bin/fish
	print_result $? "Set shell to fish"
fi

execute "if [ ! -d $HOME/.config/nvim ]; then git clone git@github.com:joelazar/nvim-config.git $HOME/.config/nvim; fi;" "Clone neovim config repo"

execute "sudo timedatectl set-ntp true" "Turn on ntp"

execute "sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket" "Turn off rfkill"

execute "systemctl --user enable pipewire-pulse" "Turn on pipewire pulseaudio server"

execute "sudo systemctl enable docker.service" "Turn on docker"

execute "sudo sed -i '/Color$/s/^#//g' /etc/pacman.conf && \
         sudo sed -i '/TotalDownload$/s/^#//g' /etc/pacman.conf && \
         sudo sed -i '/CheckSpace$/s/^#//g' /etc/pacman.conf && \
         sudo sed -i '/VerbosePkgLists$/s/^#//g' /etc/pacman.conf" "Update pacman.conf"

