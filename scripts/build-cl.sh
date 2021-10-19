#!/usr/bin/env bash

set -e

DIR=`dirname "$BASH_SOURCE"`
pushd $DIR

# call for instance as:
# ./build-sl.sh paritytech polkadot v0.9.10 v0.9.11
OWNER=$1
REPO=$2
REF1=$3
REF2=$4
CL_FILE=$REPO.json

echo Using CL_FILE: $CL_FILE

# The following is fake and comes from CI
export RUST_STABLE=1.53.0
export RUST_NIGHTLY=1.57.0

echo Building changelog for $OWNER/$REPO between $REF1 and $REF2

export RUST_LOG=debug;

# This is acting as cache so we don't spend time querying while testing
if [ ! -f "$CL_FILE" ]; then
    echo Generating $CL_FILE
    CL=$(ruby generate_release_data.rb $OWNER $REPO $REF1 $REF2)
    echo $CL | jq > $CL_FILE
else
    echo Re-using $CL_FILE
    CL=$(jq -R -s '.' < $CL_FILE)
fi

# SRTOOL_POLKADOT=$(cat polkadot-srtool-digest.json)
# SRTOOL_KUSAMA=$(cat kusama-srtool-digest.json)

# SRTOOL=$( jq -n \
#     --argjson SRTOOL_POLKADOT "$SRTOOL_POLKADOT" \
#     --argjson SRTOOL_KUSAMA "$SRTOOL_KUSAMA" \
#     '{
#         kusama: $SRTOOL_KUSAMA,
#         polkadot: $SRTOOL_POLKADOT
#     }' )

# Here we compose all the pieces together into one
# single big json file.
jq \
    --slurpfile kusama kusama-srtool-digest.json \
    --slurpfile polkadot polkadot-srtool-digest.json \
    --slurpfile cl polkadot.json \
    -n '{ changes: $cl, srtool: { kusama: $kusama, polkadot: $polkadot } }' | tee context.json

# tera --env --env-key env --template $REPO.md context.json | tee release-notes-$REPO.md

popd
