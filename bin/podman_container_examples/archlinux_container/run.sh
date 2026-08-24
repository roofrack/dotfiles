#!/usr/bin/env bash
# Rob remember... run.sh file creates the container from an image.

# This creates a containor using the image 'arch-opencode:latest' (an image built using the script arch_image_build.sh)
# Took me forever and a day to get herdr to see opencode running in a container. Should of just
# read the docs. Needed to add the 'HERDR_AGENT=opencode' to make it work.
# RUN THIS inside herdr pane
HERDR_AGENT=opencode podman run -it --rm \
  --name opencode-agent \
  -v "$(pwd)":/workspace:Z \
  -v "$HOME/.config/opencode":/root/.config/opencode:Z \
  localhost/arch-opencode:latest
