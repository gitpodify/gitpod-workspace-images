#!/bin/bash
set -euo pipefail

REPO=${IMAGE_ARTIFACTS_REPO:-"localhost:5000/recaptime-dev/gp-ws-images-build-artifacts"}
SRC_REPO=${SRC_REPO:-"https://gitlab.com/gitpodify/gitpodified-workspace-images"}
BUGTRACKER=${BUGTRACKER:-"$SRC_REPO/issues"}
MAINTAINER=${MAINTAINER:-"Recap Time Squad <yourfriends@recaptime.tk>, Andrei Jiroh Halili <ajhalili2006@gmail.com"}
COMMIT=$(git rev-parse HEAD)

buildId=$(uuidgen)
metadataContents="Build-ID: $buildId\nMaintainer: $MAINTAINER\nHomepage: $SRC_REPO\nCommit-Id: $COMMIT\nBug-Tracker: $BUGTRACKER"

echo "====================== BUILD METADATA ======================"
echo -e $metadataContents
echo "============================================================"
echo -e $metadataContents > base/.build-info
echo
echo "info: Build logs will log below and will start in 10 seconds..."
sleep 10

# First, build chunks without hashes
dazzle build $REPO -v --chunked-without-hash
# Second, build again, but with hashes
dazzle build $REPO -v
# Third, create combinations of chunks
dazzle combine $REPO --all -v

rm base/.build-info