#!/usr/bin/env bash

set -euo pipefail

output=$1

function table() {
    declare -a columns=("${!1}")
    declare -a headers=("${!2}")
    declare -a rows=("${!3}")

    if [[ ${#headers[@]} != ${#columns[@]} ]]
    then
        echo "Got ${#headers[@]} headers, expected ${#columns[@]}"
        exit -1
    fi

    if [[ $((${#rows[@]} % ${#columns[@]})) != 0 ]]
    then
        echo "Got ${#rows[@]} rows, expected multiple of ${#columns[@]}"
        exit -1
    fi

    latexTable columns[@] header[@] rows[@]
}

function latexTable() {
    declare -a columns=("${!1}")
    declare -a headers=("${!2}")
    declare -a rows=("${!3}")

    local numColumns=${#columns[@]}
    local span="1-$numColumns"
    local col=0

    echo -n "\begin{tabular}{"
    for field in "${columns[@]}"
    do
        echo -n "$field"
    done
    echo "}"

    echo "\toprule"

    for field in "${headers[@]}"
    do
        echo -n "$field"
        ((col++))

        if [[ $(( $col % $numColumns )) == 0 ]]
        then
            echo " \\\\"
        else
            echo -n " & "
        fi
    done

    echo "\cmidrule(lr){$span}"

    for field in "${rows[@]}"
    do
        echo -n "$field"
        ((col++))

        if [[ $(( $col % $numColumns )) == 0 ]]
        then
            echo " \\\\"
        else
            echo -n " & "
        fi
    done

    echo "\bottomrule"
    echo "\end{tabular}"
}

function textTable() {
    declare -a columns=("${!1}")
    declare -a headers=("${!2}")
    declare -a rows=("${!3}")

    local numColumns=${#columns[@]}
    local col=0

    for field in "${headers[@]}"
    do
        echo -n "$field"
        ((col++))

        if [[ $(( $col % $numColumns )) == 0 ]]
        then
            echo
        else
            echo -n ", "
        fi
    done

    echo ----------------------------------------------------------------

    for field in "${rows[@]}"
    do
        echo -n "$field"
        ((col++))

        if [[ $(( $col % $numColumns )) == 0 ]]
        then
            echo
        else
            echo -n ", "
        fi
    done
}

function getExamples() {
    echo "$(ls $output | sort)"
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

function examplesTable() {
    local columns=(l l l l)
    local header=(
        name
        "positivie examples (count)"
        "negative examples (count)"
        "transactions (count)"
    )
    local rows=()

    for example in $(getExamples)
    do
        rows+=(
            $example
            $(getMetric $example examples-data.json ".examples.positive | length")
            $(getMetric $example examples-data.json ".examples.negative | length")
            $(getMetric $example examples-data.json ".transactionHistory | length")
        )
    done

    table columns[@] header[@] rows[@]
}

function synthesisTable() {
    local columns=(l l l l)
    local header=(
        name
        "positivie examples (count)"
        "negative examples (count)"
        "queries (count)"
    )
    local rows=()

    for example in $(getExamples)
    do
        rows+=(
            $example
            $(getMetric $example examples-data.json ".examples.positive | length")
            $(getMetric $example examples-data.json ".examples.negative | length")
            $(getMetric $example evaluator-queries.jsonl length -s)
        )
    done

    table columns[@] header[@] rows[@]
}

function verifyTable() {
    local columns=(l l)
    local header=(
        name
        verified
    )
    local rows=()

    for example in $(getExamples)
    do
        rows+=(
            $example
            $(getMetric $example verifier-data.json .success)
        )
    done

    table columns[@] header[@] rows[@]
}

function timingBreakdownTable() {
    local columns=(l l l l)
    local header=(
        name
        "examples (ms)"
        "synthesis (ms)"
        "verify (ms)"
    )
    local rows=()

    for example in $(getExamples)
    do
        rows+=(
            $example
            $(getMetric $example simulation-metrics.json .examplesTime.value)
            $(getMetric $example simulation-metrics.json .synthesisTime.value)
            $(getMetric $example simulation-metrics.json .verifyTime.value)
        )
    done

    table columns[@] header[@] rows[@]
}

function overviewTable() {
    local columns=(l l l)
    local header=(name expression verified)
    local rows=()

    for example in $(getExamples)
    do
        rows+=(
            $example
            "$(getMetric $example synthesis-data.json .output[])"
            $(getMetric $example verifier-data.json .success)
        )
    done

    table columns[@] header[@] rows[@]
}

echo "$(overviewTable)"
echo ---
echo "$(timingBreakdownTable)"
echo ---
echo "$(examplesTable)"
echo ---
echo "$(synthesisTable)"
echo ---
echo "$(verifyTable)"
