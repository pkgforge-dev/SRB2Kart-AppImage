#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    glu        \
    libgme     \
    sdl2_mixer

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
make-aur-package discord-rpc
#make-aur-package srb2kart-data
#make-aur-package srb2kart

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
echo "Building stable version of SRB2Kart..."
echo "---------------------------------------------------------------"
REPO="https://github.com/STJr/Kart-Public"
VERSION="$(curl -s https://api.github.com/repos/STJr/Kart-Public/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)"
git clone "$REPO" ./SRB2Kart
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./SRB2Kart
make LINUX64=1 -j$(nproc)
