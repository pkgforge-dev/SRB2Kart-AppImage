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
VERSION="$(curl -sL https://api.github.com/repos/STJr/Kart-Public/releases/latest | grep '"tag_name"' | head -1 | cut -d '"' -f 4)"
git clone --branch "$VERSION" "$REPO" ./SRB2Kart
echo "$VERSION" > ~/version

# AssetsLinuxOnly.zip from the same latest tag
curl -L -o AssetsLinuxOnly.zip \
  "https://github.com/STJr/Kart-Public/releases/download/$VERSION/AssetsLinuxOnly.zip"

mkdir -p ./AppDir/bin
mkdir -p ./AppDir/share/games/SRB2Kart
bsdtar -xvf AssetsLinuxOnly.zip -C ./AppDir/share/games/SRB2Kart

cd ./SRB2Kart/src
export CFLAGS="${CFLAGS:-} -std=gnu99"
make LINUX64=1 HAVE_DISCORDRPC=1 -j$(nproc)
mv -v ../bin/Linux64/Release/lsdl2srb2kart ../../AppDir/bin/srb2kart
