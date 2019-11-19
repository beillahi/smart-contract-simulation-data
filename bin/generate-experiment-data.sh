#!/usr/bin/env bash

set -euo pipefail

BIN="$(dirname $BASH_SOURCE[0])"
ROOT="$(cd $(dirname $BIN) && pwd)"
CONFIGS="$ROOT/configs"
CONTRACTS="$ROOT/contracts"
IGNORED_KEYS="description"
COMMAND="sc-simulation"
TIMESTAMP=$(date +"%Y.%m.%d.%H.%M")
TITLE=$(date +"%B %d, %Y %H:%M %Z")
TAG=$TIMESTAMP
LIBS="contracts/original"
OUTPUT="output.${TIMESTAMP}"
TABLES="tables.${TIMESTAMP}"

mkdir -p $OUTPUT
mkdir -p $TABLES

echo Generating experimental data to $OUTPUT
echo ---

for file in $(find $CONFIGS -name "*.json" | sort)
do
    name=$(basename $file .json)
    output="$OUTPUT/$name"
    command="$COMMAND --output $output --libs $LIBS"

    echo Processing example: $name
    echo ---

    # consider any fields defined in the given config
    for key in $(jq -r 'keys[]' $file)
    do
        # read the value of the given key
        value=$(jq -r .\"$key\" $file)

        # skip null values
        if [[ "$value" == "null" ]]
        then
            echo Warning: null value for: $key
            continue

        # print out descriptions
        elif [[ "$key" == "description" ]]
        then
            echo "about: $value"
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
    echo Running command: $command
    echo ---
    mkdir -p "$output"
    $command > >(tee $output/stdout.log) 2> >(tee $output/stderr.log >&2)

    echo ---
done

source "$BIN/generate-tables.sh" "$OUTPUT" "$TABLES"

echo Compressing the results into $OUTPUT.zip
echo ---
zip -r "$OUTPUT.zip" "$OUTPUT" "$TABLES"
echo ---

if [[ -n "${DRYRUN-}" ]]
then
    echo Skipping release because dryrun

elif [[ $(command -v hub) ]]
then
    hub release create -m "$TITLE" -a "$OUTPUT.zip" "$TAG"

else
    echo Skipping release because hub not installed
fi
