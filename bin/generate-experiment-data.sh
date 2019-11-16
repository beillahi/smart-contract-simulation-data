#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd $(dirname $(dirname $BASH_SOURCE[0])) && pwd)"
CONFIGS="$ROOT/configs"
CONTRACTS="$ROOT/contracts"
IGNORED_KEYS="description"
COMMAND="sc-simulation"
TIMESTAMP=$(date +"%Y.%m.%d.%H.%M")
TITLE=$(date +"%B %d, %Y %H:%M")
TAG=$TIMESTAMP
OUTPUT="output.${TIMESTAMP}"
DRYRUN=

mkdir -p $OUTPUT

echo Generating experimental data to $OUTPUT
echo ---

for file in $(find $CONFIGS -name "*.json")
do
    name=$(basename $file .json)
    output="$OUTPUT/$name"
    command="$COMMAND --output $output"

    echo Processing example: $name
    echo ---

    # consider any fields defined in the given config
    for key in $(jq -r 'keys[]' $file)
    do
        # read the value of the given key
        value=$(jq -r .${key//-/} $file)

        # skip ignored keys and null values
        if [[ " $IGNORED_KEYS " =~ " $key " || "$value" == "null" ]]
        then
            continue
        fi

        # prepend the contracts path contract-path values
        if [[ "$value" =~ .sol$ ]]
        then
            value="$CONTRACTS/$value"
        fi

        # just generate files but don’t actually do much
        if [[ -n $DRYRUN ]]
        then
            command="$command --no-examples --no-synthesize --no-verify"
        fi

        # append the key to the command
        command="$command --$key $value"
    done

    # actually run the command
    echo Running command: $command
    echo ---
    mkdir -p "$output"
    $command > >(tee $output/stdout.log) 2> >(tee $output/stderr.log >&2)

    echo ---
done

echo Compressing the results into $OUTPUT.zip
echo ---
zip -r "$OUTPUT.zip" "$OUTPUT"
echo ---

if [[ $(command -v hub) ]]
then
    hub release create -m "$TITLE" -a "$OUTPUT.zip" "$TAG"
else
    echo Skipping release because hub not installed
fi
