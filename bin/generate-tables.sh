#!/usr/bin/env bash

set -euo pipefail

output=${1:-output}
tabledir=${2:-.}

if [[ ! -d "$output" ]]
then
    echo "No such output directory: $output"
    exit -1
fi

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
    local columns=(l l l l l l)
    local header=(
        name
        "traces (count)"
        # "trace length (avg)"
        # "trace length (max)"
        "states (count)"
        "transactions (count)"
        "positivie examples (count)"
        "negative examples (count)"
    )
    local rows=()

    for example in $(getExamples)
    do
        rows+=(
            $example
            $(getMetric $example examples-data.json ".states | length")
            $(getMetric $example examples-data.json ".traces | length")
            # $(getMetric $example examples-data.json "[.traces | length] as \$vs | (\$vs|add) / (\$vs|length)")
            # $(getMetric $example examples-data.json ".traces | max_by(length)")
            $(getMetric $example examples-data.json ".transactionHistory | length")
            $(getMetric $example examples-data.json ".examples.positive | length")
            $(getMetric $example examples-data.json ".examples.negative | length")
        )
    done

    table columns[@] header[@] rows[@]
}

function synthesisTable() {
    local columns=(l l l l l l l l)
    local header=(
        name
        "positivie examples (count)"
        "negative examples (count)"
        "fields (count)"
        "seed features (count)"
        "synthesized features (count)"
        "queries (count)"
        "transactions (count)"
    )
    local rows=()

    for example in $(getExamples)
    do
        rows+=(
            $example
            $(getMetric $example synthesis-input-data.json ".examples.positive | length")
            $(getMetric $example synthesis-input-data.json ".examples.negative | length")
            $(getMetric $example synthesis-input-data.json ".expressions | length")
            $(getMetric $example synthesis-input-data.json ".features | length")
            $(getMetric $example synthesis-data.json ".features | length")
            $(getMetric $example evaluator-queries.jsonl length -s)
            $(getMetric $example evaluator-data.jsonl length -s)
        )
    done

    table columns[@] header[@] rows[@]
}

function verifyTable() {
    local columns=(l l l l)
    local header=(
        name
        "functions (count)"
        "lines of code (count)"
        verified
    )
    local rows=()

    for example in $(getExamples)
    do
        rows+=(
            $example
            $(getMetric $example verifier-data.json .functions)
            $(getMetric $example verifier-data.json .linesOfCode)
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

function generateTables() {
    local dir="$1"
    echo "Generating overview table: $dir/overview-table.tex"
    echo "$(overviewTable)" > "$dir/overview-table.tex"

    echo "Generating timing table: $dir/timing-table.tex"
    echo "$(timingBreakdownTable)" > "$dir/timing-table.tex"

    echo "Generating examples table: $dir/examples-table.tex"
    echo "$(examplesTable)" > "$dir/examples-table.tex"

    echo "Generating synthesis table: $dir/synthesis-table.tex"
    echo "$(synthesisTable)" > "$dir/synthesis-table.tex"

    echo "Generating verify table: $dir/verify-table.tex"
    echo "$(verifyTable)" > "$dir/verify-table.tex"
}

generateTables "$tabledir"
