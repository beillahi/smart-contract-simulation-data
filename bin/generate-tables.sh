#!/usr/bin/env bash

set -euo pipefail

output=$1

function table() {
    local columns="$1"
    local header="$2"
    local rows="$3"

    local numColumns=$(expr $(echo "$columns" | wc -c) - 1)
    local span="1-$numColumns"

    cat << EOF
\begin{tabular}{$columns}
    \toprule
    $header \\\\
    \cmidrule(lr){$span}
    $rows
    \bottomrule
\end{tabular}
EOF
}

function getMetric() {
    local example="$1"
    local json="$2"
    local expression="$3"
    local flags="${4:-}"
    local unknown=-

    local file="$output/$example/$json"
    local result

    if [[ -f "$file" ]]
    then
        result=$(jq -r $flags "$expression // \"$unknown\"" $file)
    else
        result=$unknown
    fi

    echo "$result"
}

function getExamples() {
    echo "$(ls $output | sort)"
}

function bigTable() {
    local columns="lllllll"
    local header="name & examples (count) & examples (ms) & synthesis (ms) & verify (ms) & transactions (count) & queries (count)"
    local rows=""

    for example in $(getExamples)
    do
        numExamples=$(getMetric $example simulation-metrics.json .examples.value)
        examplesTime=$(getMetric $example simulation-metrics.json .examplesTime.value)
        synthesisTime=$(getMetric $example simulation-metrics.json .synthesisTime.value)
        verifyTime=$(getMetric $example simulation-metrics.json .verifyTime.value)
        numTransactions=$(getMetric $example example-data.json ".transactionHistory | length")
        numQueries=$(getMetric $example evaluator-queries.jsonl length -s)

        row="$example & $numExamples & $examplesTime & $synthesisTime & $verifyTime & $numTransactions & $numQueries \\\\"

        if [[ -n "$rows" ]]
        then
            rows="$rows"$'\n    '
        fi
        rows="$rows$row"
    done

    table "$columns" "$header" "$rows"
}

function anotherTable() {
    local columns="lll"
    local header="name & expression & verified"
    local rows=""

    for example in $(getExamples)
    do
        synthesisOutput=$(getMetric $example synthesis-data.json .output[])
        verifySuccess=$(getMetric $example verifier-data.json .success)

        row="$example & $synthesisOutput & $verifySuccess \\\\"

        if [[ -n "$rows" ]]
        then
            rows="$rows"$'\n    '
        fi
        rows="$rows$row"
    done

    table "$columns" "$header" "$rows"
}

echo ---
bigTable
echo ---
anotherTable
echo ---
