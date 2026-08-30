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

make-aur-package discord-rpc

echo "Building stable version of SRB2Kart..."
echo "---------------------------------------------------------------"
REPO="https://github.com/STJr/Kart-Public"
VERSION="$(curl -sL https://api.github.com/repos/STJr/Kart-Public/releases/latest | grep '"tag_name"' | head -1 | cut -d '"' -f 4)"
git clone --branch "$VERSION" "$REPO" ./SRB2Kart
VERSION_NOV="${VERSION#v}"
echo "$VERSION_NOV" > ~/version

# AssetsLinuxOnly.zip from same latest tag
curl -L -o AssetsLinuxOnly.zip \
  "https://github.com/STJr/Kart-Public/releases/download/$VERSION/AssetsLinuxOnly.zip"

mkdir -p ./AppDir/bin
mkdir -p ./AppDir/share/games/SRB2Kart
bsdtar -xvf AssetsLinuxOnly.zip -C ./AppDir/share/games/SRB2Kart

cd ./SRB2Kart/src
export CFLAGS="${CFLAGS:-} -std=gnu99"
make LINUX64=1 HAVE_DISCORDRPC=1 -j$(nproc)
mv -v ../bin/Linux64/Release/lsdl2srb2kart ../../AppDir/bin/srb2kart
