#!/bin/bash

# Install script for common programs on POP OS

# Do a quick update

sudo apt update && sudo apt upgrade -y

# Install flatpak if not installed

sudo apt install flatpak -y

# Add the flathub repo for most packages (should already be there by default)

flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Fix update behaviour for texlive through flatpak, texlive will be installed through lyx or install through repo

flatpak mask org.freedesktop.Sdk.Extension.texlive//21.08 --user

# create array of programs to install with flatpak, individual entries can be commented out

finstall=()
finstall+=("org.mozilla.Thunderbird") 		# Thunderbird
finstall+=("io.github.quodlibet.QuodLibet") 	# Quod Libet
finstall+=("org.gimp.GIMP") 			# GIMP
finstall+=("org.signal.Signal")			# Signal
finstall+=("us.zoom.Zoom")			# Zoom
finstall+=("org.videolan.VLC")			# VLC
finstall+=("com.discordapp.Discord")		# Discord
finstall+=("com.valvesoftware.Steam")		# Steam
finstall+=("flathub org.blender.Blender")	# Blender
finstall+=("org.inkscape.Inkscape")		# Inkscape
finstall+=("org.texstudio.TeXstudio")		# TeXStudio
finstall+=("io.github.peazip.PeaZip")		# PeaZip
finstall+=("com.github.tchx84.Flatseal")  # Flatseal
# finstall+=()

# Install programs in finstall

flatpak install flathub ${finstall[@]} -y

# Create array of programs to install with apt, individual entries can be commented out

ainstall=()
ainstall+=("tilix")	# Tilix
ainstall+=("code")	# Visual Studio Code
ainstall+=("mc")	# Midnight Commander
ainstall+=("lyx")	# LyX
ainstall+=("texlive")	# TeXLive, should come with LyX
ainstall+=("unattended-upgrades")   # Unattended upgrades
# ainstall+=()

# Install programs in ainstall

sudo apt install ${ainstall[@]} -y

# Install the latest rclone version

curl https://rclone.org/install.sh | sudo bash

# Get the latest Julia version, IMPORTANT: make sure it is the latest!

if [ ! -f "/opt/julia-1.7.1/bin/julia" ]; then
   echo "Downloading and installing Julia."
   wget https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.1-linux-x86_64.tar.gz
   tar zxvf julia-1.7.1-linux-x86_64.tar.gz
   sudo mv julia-1.7.1/ /opt/
   sudo ln -s /opt/julia-1.7.1/bin/julia /usr/local/bin/julia
   sudo rm julia-1.7.1-linux-x86_64.tar.gz
else
   echo "Julia already installed."
fi

# Install the Rust environment

if [ ! -d "$HOME/.cargo" ]; then
   echo "Downloading and installing Rust."
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
   echo "Rust already installed."
fi

# if you want to change steam standard game library location:
# flatpak override com.valvesoftware.Steam --filesystem=/mnt/my/hdd
