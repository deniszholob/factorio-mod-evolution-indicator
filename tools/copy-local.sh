#!/bin/bash
# @usage: bash tools/copy-local.sh
# Be carefull about editing in factorio folder, as this will overwrite anything there

MOD_NAME="ddd-evolution-indicator" # MUST be the same as in "src/info.json" !!!
FACTORIO_DIR="$APPDATA/Factorio/mods/"
RELEASE_FILE_NAME="$MOD_NAME"

echo "===== Current dir:"
pwd
# ls -al

echo "Remove previous contents"
rm -rfv "$FACTORIO_DIR/$RELEASE_FILE_NAME"

echo "===== Copy scr folder to factorio mods folder"
# Copies everything including dot files/folders
cp -rfv "./src" "$FACTORIO_DIR/$RELEASE_FILE_NAME"

echo "===== Copied folder contents:"
ls -al "$FACTORIO_DIR/$RELEASE_FILE_NAME"
