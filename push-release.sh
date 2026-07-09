#!/usr/bin/env bash

SCRIPT_DIR="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

cd "$SCRIPT_DIR" || exit 1

TMPDIR="$(mktemp -d)"

cp "static/linux-amd64/ffmpeg" "$TMPDIR/ffmpeg-amd64"
cp "static/linux-amd64/ffprobe" "$TMPDIR/ffprobe-amd64"
cp "static/linux-arm64/ffmpeg" "$TMPDIR/ffmpeg-arm64"
cp "static/linux-arm64/ffprobe" "$TMPDIR/ffprobe-arm64"

gh repo set-default tytydraco/static-ffmpeg-yp3-patch
gh release create \
    "yp3-$(date +%Y%m%d-%H%M%S)" \
    --title "$(date)" \
    --notes "Static binaries with YP3 x264 patch." \
    "$TMPDIR/ffmpeg-amd64" \
    "$TMPDIR/ffprobe-amd64" \
    "$TMPDIR/ffmpeg-arm64" \
    "$TMPDIR/ffprobe-arm64"

rm -rf "$TMPDIR"