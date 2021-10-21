#!/usr/bin/env bash

set -e

DIR=`dirname "$BASH_SOURCE"`
pushd $DIR

# The following is fake and comes from CI
source .env

# call for instance as:
# ./build-sl.sh paritytech polkadot v0.9.10 v0.9.11
OWNER=${1:-$OWNER}
REPO=${2:-polkadot}
REF1=${3:-$REF1}
REF2=${4:-$REF2}

POLKADOT=$REPO.json
SUBSTRATE=substrate.json

echo Using POLKADOT: $POLKADOT
echo Building changelog for $OWNER/$REPO between $REF1 and $REF2

export RUST_LOG=debug;

# This is acting as cache so we don't spend time querying while testing
if [ ! -f "$POLKADOT" ]; then
    echo Generating $POLKADOT
    changelogerator $OWNER/$REPO -f $REF1 -t $REF2 > $POLKADOT
else
    echo Re-using $POLKADOT
fi

if [ ! -f "$SUBSTRATE" ]; then
    echo Generating $SUBSTRATE
    changelogerator $OWNER/substrate -f polkadot-$REF1 -t polkadot-$REF2 > $SUBSTRATE
else
    echo Re-using $SUBSTRATE
fi

# Here we compose all the pieces together into one
# single big json file.
jq \
    --slurpfile srtool_kusama kusama-srtool-digest.json \
    --slurpfile srtool_polkadot polkadot-srtool-digest.json \
    --slurpfile polkadot polkadot.json \
    --slurpfile substrate substrate.json \
    -n '{
        polkadot: $polkadot[0],
        substrate: $substrate[0],
        srtool: [
            { name: "kusama", data: $srtool_kusama[0] },
            { name: "polkadot", data: $srtool_polkadot[0] }
        ] }' | tee context.json

tera --env --env-key env --include-path . --template $REPO.md context.json | tee release-notes-$REPO.md

popd
