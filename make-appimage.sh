#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q srb2kart | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export APPNAME=SRB2Kart
export ICON=https://raw.githubusercontent.com/STJr/Kart-Public/refs/heads/master/srb2.png
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/srb2kart

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
