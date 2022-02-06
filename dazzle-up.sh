#!/bin/bash
set -euo pipefail

REPO=${IMAGE_ARTIFACTS_REPO:-"localhost:5000/recaptime-dev/gp-ws-images-build-artifacts"}
# First, build chunks without hashes
dazzle build $REPO -v --chunked-without-hash
# Second, build again, but with hashes
dazzle build $REPO -v
# Third, create combinations of chunks
dazzle combine $REPO --all -v
