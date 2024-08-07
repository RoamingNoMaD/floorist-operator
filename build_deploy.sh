#!/bin/bash
set -ex

login_container_registry() {

    local USER="$1"
    local PASSWORD="$2"
    local REGISTRY="$3"

    podman login "-u=${USER}" "--password-stdin" "$REGISTRY" <<< "$PASSWORD"
}

IMAGE_TAG=$(git rev-parse --short=7 HEAD)

# Workaround for podman bug containers/podman/issues#14568
podman info

login_container_registry "$QUAY_USER" "$QUAY_TOKEN" "quay.io"
login_container_registry "$RH_REGISTRY_USER" "$RH_REGISTRY_TOKEN" "registry.redhat.io"

VERSION=$IMAGE_TAG IMG_BUILD_PARAMS="--pull --no-cache" \
    make podman-build podman-tag-latest podman-push podman-push-latest
