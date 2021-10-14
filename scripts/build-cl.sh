#!/usr/bin/env bash

set -e

OWNER=$1
REPO=$2
REF1=$3
REF2=$4
DATAFILE=$REPO.json

# The following is fake and comes from CI
export RUST_STABLE=1.53.0
export RUST_NIGHTLY=1.57.0

echo Building changelog for $OWNER/$REPO between $REF1 and $REF2

export RUST_LOG=debug;

# This is acting as cache so we don't spend time querying while testing
if [ ! -f "$DATAFILE" ]; then
    DATA=$(ruby generate_release_data.rb $OWNER $REPO $REF1 $REF2)
    echo $DATA | jq > $DATAFILE
else
    DATA=$(cat $DATAFILE)
fi

time tera --env --env-key env --template $REPO.md $DATAFILE | tee release-notes-$REPO.md
