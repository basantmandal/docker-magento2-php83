#!/usr/bin/env bash

set -e  # fail fast

image="basantmandal/hk2-php8.3-fpm"
version="2.0"
tag="${image}:${version}"

echo "🔍 Checking for existing image..."

if docker image inspect "$tag" > /dev/null 2>&1; then
    echo "⚠️  Image exists. Removing old image..."
    docker image rm -f "$tag"
fi

echo "🏗️  Building image locally (no cache)..."
docker build --no-cache -t "$tag" ../ | tee docker_build.log

echo "✅ Build complete: $tag"
echo "👉 You can now test locally before pushing to Docker Hub"