#!/usr/bin/env bash

# This script reads the following environment variables:
#
# INCLUDE=<pattern>     only examples matching <pattern> are considered
# DRYRUN=<value>        don’t actually run the tool nor publish results

set -euo pipefail

function log() {
    "$@" | tee -a "$LOG"
}

BIN="$(dirname "$BASH_SOURCE[0]")"
ROOT="$(cd "$(dirname "$BIN")" && pwd)"
CONFIGS="$ROOT/configs"
CONTRACTS="$ROOT/contracts"
COMMAND="sc-simulation"
TIMESTAMP=$(date +"%Y.%m.%d.%H.%M")
TITLE=$(date +"%B %d, %Y %H:%M %Z")
TAG=$TIMESTAMP
LOG="log.${TIMESTAMP}"
OUTPUT="output.${TIMESTAMP}"
TABLES="tables.${TIMESTAMP}"
EXAMPLES=$(find "$CONFIGS" -name "*.json" | grep -e "${INCLUDE:-}" | sort)
NUM_EXAMPLES=$(($(echo "$EXAMPLES" | wc -w)))

mkdir -p "$OUTPUT"
mkdir -p "$TABLES"

log echo "Generating experimental data to $OUTPUT"
log echo ---
log echo "Found $NUM_EXAMPLES examples: $(echo "$EXAMPLES" | xargs basename -s .json | xargs)"
log echo ---

counter=0
for file in $EXAMPLES
do
    name=$(basename "$file" .json)
    output="$OUTPUT/$name"
    command="$COMMAND --output $output"

    log echo "Processing example $((++counter)) of $NUM_EXAMPLES: $name"
    log echo ---

    # consider any fields defined in the given config
    for key in $(jq -r 'keys[]' $file)
    do
        # read the value of the given key
        value=$(jq -r .\""$key"\" "$file")

        # skip null values
        if [[ "$value" == "null" ]]
        then
            log echo Warning: null value for: $key
            continue

        # print out descriptions
        elif [[ "$key" == "description" ]]
        then
            log echo "$value"
            log echo ---
            continue

        # prepend the contracts path contract-path values
        elif [[ "$value" =~ .sol$ ]]
        then
            value="$CONTRACTS/$value"
        fi

        # append the key to the command
        command="$command --$key $value"
    done

    # just generate files but don’t actually do much
    if [[ -n ${DRYRUN-} ]]
    then
        command="$command --no-examples --no-synthesize --no-verify"
    fi

    # actually run the command
    log echo Running command: $command
    log echo ---
    mkdir -p "$output"
    $command > >(tee "$output"/stdout.log) 2> >(tee "$output"/stderr.log >&2)

    log echo ---
done

node "$ROOT/dist/index.js" "$OUTPUT" "$TABLES"
(cd "$TABLES" && latexmk document.tex)

log echo Compressing the results into $OUTPUT.zip
log echo ---
zip -r "$OUTPUT.zip" "$OUTPUT" "$TABLES" "$LOG"
log echo ---

if [[ -n "${DRYRUN-}" ]]
then
    log echo Skipping release because dryrun

elif [[ $(command -v hub) ]]
then
    log echo Creating release "$TITLE"
    log hub release create -m "$TITLE" -a "$OUTPUT.zip" -a "$TABLES/document.pdf" "$TAG"

else
    log echo Skipping release because hub not installed
fi
