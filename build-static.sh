#!/usr/bin/env bash

set -euo pipefail

STATIC_DIR="static"
IMAGE_NAME="static-ffmpeg-yp3-patch"

mkdir -p "$STATIC_DIR"

for platform in linux/amd64 linux/arm64; do
    tag="${IMAGE_NAME}:${platform//\//-}"
    dest="$PWD/$STATIC_DIR/${platform//\//-}"

    echo "Building $platform..."
    docker buildx build \
        --platform "$platform" \
        --build-arg ENABLE_FDKAAC=1 \
        -t "$tag" \
        --load \
        .

    echo "Extracting $platform..."
    mkdir -p "$dest"

    cid=$(docker create --platform "$platform" "$tag")
    docker cp "$cid:/ffmpeg" "$dest/ffmpeg"
    docker cp "$cid:/ffprobe" "$dest/ffprobe"
    docker rm "$cid" >/dev/null
done
