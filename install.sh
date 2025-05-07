#!/bin/bash

set -e

BRIDGE_VERSION="v1.0.0"
BASE_URL="https://github.com/ayoussief/bridge-template/releases/download/$BRIDGE_VERSION"

detect_platform() {
  uname_out="$(uname -s)"
  case "${uname_out}" in
      Linux*)     os=linux;;
      Darwin*)    os=macos;;
      CYGWIN*|MINGW*|MSYS*) os=windows;;
      *)          echo "Unsupported OS"; exit 1;;
  esac
  echo $os
}

PLATFORM=$(detect_platform)

echo "Detected platform: $PLATFORM"

case "$PLATFORM" in
  linux)
    URL="$BASE_URL/bridge-linux"
    DEST="bridge"
    ;;
  macos)
    URL="$BASE_URL/bridge-macos"
    DEST="bridge"
    ;;
  windows)
    URL="$BASE_URL/bridge-windows.exe"
    DEST="bridge.exe"
    ;;
esac

curl -L "$URL" -o "$DEST"
chmod +x "$DEST"

INSTALL_DIR="/usr/local/bin"
if [ ! -w "$INSTALL_DIR" ]; then
  echo "🔒 You may be asked for your password to install bridge..."
  sudo mv "$DEST" "$INSTALL_DIR/bridge"
else
  mv "$DEST" "$INSTALL_DIR/bridge"
fi

echo "✅ bridge installed to $INSTALL_DIR/bridge"
echo "You can now run: bridge new node"