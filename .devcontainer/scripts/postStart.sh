#!/usr/bin/env bash

direnv allow # allow our .envrc to be executed

nohup ./devkit/gp-buildkit >> /dev/null & # start Buildkitd with our repo-specific configs

# Authenticate Docker CLI and Skopeo
./devkit/docker-cli-login || true
./devkit/bin/skopeo-auth-ghcr || true

# Start local registry and show welcome message
./devkit/local-registry
