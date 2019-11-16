#!/usr/bin/env bash

set -euo pipefail

output=output.2019.11.16.14.58
columns="lllll"
span="1-5"
header="name & examples (count) & examples (ms) & synthesis (ms) & verify (ms)"
rows=""

for exampleDir in $output/*
do
    exampleName=$(basename $exampleDir)
    metrics="$exampleDir/simulation-metrics.json"
    numExamples=$(jq '.examples.value' $metrics)
    examplesTime=$(jq '.examplesTime.value' $metrics)
    synthesisTime=$(jq '.synthesisTime.value' $metrics)
    verifyTime=$(jq '.verifyTime.value' $metrics)

    row="$exampleName & $numExamples & $examplesTime & $synthesisTime & $verifyTime \\\\"

    if [[ -n "$rows" ]]
    then
        rows="$rows"$'\n    '
    fi
    rows="$rows$row"
done

cat << EOF
\begin{tabular}{$columns}
    \toprule
    $header \\\\
    \cmidrule(lr){$span}
    $rows
    \bottomrule
\end{tabular}
EOF
