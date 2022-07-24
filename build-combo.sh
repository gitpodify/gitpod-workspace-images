#! /bin/bash
set -eo pipefail
trap ctrl_c EXIT

# shellcheck source=/dev/null
source build-common.sh

REPO=${IMAGE_ARTIFACTS_REPO:-"localhost:5000/recaptime-dev/gp-ws-images-build-artifacts"}
SRC_REPO=${SRC_REPO:-"https://gitlab.com/gitpodify/gitpodified-workspace-images"}
BUGTRACKER=${BUGTRACKER:-"$SRC_REPO/issues"}
MAINTAINER=${MAINTAINER:-"Recap Time Squad <yourfriends@recaptime.tk>, Andrei Jiroh Halili <ajhalili2006@gmail.com>"}
COMMIT=$(git rev-parse HEAD)

metadataContents="Maintainer: $MAINTAINER\nHomepage: $SRC_REPO\nCommit-Id: $COMMIT\nBug-Tracker: $BUGTRACKER"

echo "====================== BUILD METADATA ======================"
echo -e $metadataContents
echo "============================================================"
echo -e $metadataContents > base/.build-info
echo
echo "info: Build logs will log below and will start in 10 seconds..."
sleep 10

function build_combination() {
	combination=$1

	local exists
	exists="$(yq e '.combiner.combinations[] | select (.name=="'"$combination"'")' dazzle.yaml)"
	if [[ -z "$exists" ]]; then
		echo "combination is not defined"
		exit 1
	fi

	refs=$(get_refs "$combination")
	required_chunks=$(get_chunks "$refs" | sort | uniq)
	available_chunks=$(get_available_chunks)

	for ac in $available_chunks; do
		if [[ ! "${required_chunks[*]}" =~ ${ac} ]]; then
			dazzle project ignore "$ac"
		fi
	done
}

function get_refs() {
	local ref=$1
	echo "$ref"

	refs="$(yq e '.combiner.combinations[] | select (.name=="'"$ref"'") | .ref[]' dazzle.yaml)"
	if [[ -z "$refs" ]]; then
		return
	fi

	for ref in $refs; do
		get_refs "$ref"
	done
}

function get_chunks() {
	# shellcheck disable=SC2068
	for ref in $@; do
		chunks=$(yq e '.combiner.combinations[] | select (.name=="'"$ref"'") | .chunks[]' dazzle.yaml)
		echo "$chunks"
	done
}

save_original

if [ -n "${1}" ]; then
	build_combination "$1"
fi

# First, build chunks without hashes
dazzle build $REPO -v --chunked-without-hash
# Second, build again, but with hashes
dazzle build $REPO -v

# Third, create combinations of chunks
if [[ -n "${1}" ]]; then
	dazzle combine $REPO --combination "$1" -v
else
	dazzle combine $REPO --all -v
fi
