#!/usr/bin/env bash

set -e

DIR=`dirname "$BASH_SOURCE"`
pushd $DIR

# The following is fake and comes from CI
source .env

# call for instance as:
# ./build-sl.sh paritytech polkadot v0.9.10 v0.9.11
OWNER=${1:-$OWNER}
REPO=${2:-$REPO}
REF1=${3:-$REF1}
REF2=${4:-$REF2}

CL_FILE=$REPO.json

echo Using CL_FILE: $CL_FILE
echo Building changelog for $OWNER/$REPO between $REF1 and $REF2

export RUST_LOG=debug;

# This is acting as cache so we don't spend time querying while testing
if [ ! -f "$CL_FILE" ]; then
    echo Generating $CL_FILE
    changelogerator $OWNER/$REPO -f $REF1 -t $REF2 > $CL_FILE
else
    echo Re-using $CL_FILE
    # CL=$(jq -R -s '.' < $CL_FILE)
fi

# Here we compose all the pieces together into one
# single big json file.
jq \
    --slurpfile srtool_kusama kusama-srtool-digest.json \
    --slurpfile srtool_polkadot polkadot-srtool-digest.json \
    --slurpfile cl polkadot.json \
    -n '{ polkadot: $cl[0], srtool: [ { name: "kusama", data: $srtool_kusama[0] }, { name: "polkadot", data: $srtool_polkadot[0] } ] }' | tee context.json

tera --env --env-key env --include-path . --template $REPO.md context.json | tee release-notes-$REPO.md

popd
