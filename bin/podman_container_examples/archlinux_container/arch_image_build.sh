#!/usr/bin/env bash
# Builds a lightweight archlinux image for containers. Rob you made this. Use this
# script instead of a Containerfile for generating an image.
# Instead of running `podman build -t 'your_container_name' Containerfile`
#   just run this script instead and it builds the image.
# Add apps here to the image. I have added opencode for this particular one.

set -euo pipefail

# Ensure the script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo)."
  exit 1
fi

# 1. Create unique temporary directory
ROOTFS=$(mktemp -d /tmp/arch-rootfs-XXXXXX)
echo "Created temporary rootfs at: $ROOTFS"

# Ensure cleanup happens even if the script fails midway
trap 'echo "Cleaning up..."; rm -rf "$ROOTFS" arch-opencode.tar' EXIT

# 2. Bootstrap minimal system + opencode using host repositories
echo "Bootstrapping Arch Linux and opencode..."
pacstrap -C /etc/pacman.conf -c "$ROOTFS" base opencode

# 3. Strip down image size
echo "Cleaning package caches..."
rm -rf "$ROOTFS"/var/cache/pacman/pkg/*
rm -rf "$ROOTFS"/var/log/*

# 4. Tar and Import into your regular user's Rootless Podman
echo "Creating tarball and importing to Rootless Podman..."
tar -C "$ROOTFS" --numeric-owner -cf arch-opencode.tar .

# Identify the original user who invoked sudo
ORIGINAL_USER="${SUDO_USER:-$USER}"

# Pipe the tar archive directly into a rootless podman import command
sudo -u "$ORIGINAL_USER" podman import \
  --change "CMD /usr/bin/opencode" \
  arch-opencode.tar arch-opencode:latest

echo "Success! Image 'arch-opencode:latest' is ready in your rootless environment."
