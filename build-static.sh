#!/usr/bin/env bash

SCRIPT_DIR="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"

STATIC_DIR="$SCRIPT_DIR/static"
IMAGE_NAME="static-ffmpeg-yp3-patch"

mkdir -p "$STATIC_DIR"

for platform in linux/amd64 linux/arm64; do
    tag="$IMAGE_NAME:${platform//\//-}"
    dest="$STATIC_DIR/${platform//\//-}"

    echo "Building $platform..."
    docker buildx build \
        --no-cache \
        --platform "$platform" \
        --build-arg ENABLE_FDKAAC=1 \
        -t "$tag" \
        --load \
        "$SCRIPT_DIR"

    echo "Extracting $platform..."
    mkdir -p "$dest"

    cid=$(docker create --platform "$platform" "$tag")
    docker cp "$cid:/ffmpeg" "$dest/ffmpeg"
    docker cp "$cid:/ffprobe" "$dest/ffprobe"
    docker rm "$cid" >/dev/null
done
