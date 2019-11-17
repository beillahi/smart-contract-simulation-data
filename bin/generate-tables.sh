#!/usr/bin/env bash

set -euo pipefail

output=$1
columns="lllll"
span="1-5"
header="name & examples (count) & examples (ms) & synthesis (ms) & verify (ms) & transactions (count) & queries (count) & expression & verified"
rows=""

for exampleDir in $output/*
do
    exampleName=$(basename $exampleDir)

    simulationMetrics="$exampleDir/simulation-metrics.json"
    examplesData="$exampleDir/examples-data.json"
    evaluatorQueries="$exampleDir/evaluator-queries.jsonl"
    synthesisData="$exampleDir/synthesis-data.json"
    verifierData="$exampleDir/verifier-data.json"

    numExamples=$(jq '.examples.value' $simulationMetrics)
    examplesTime=$(jq '.examplesTime.value' $simulationMetrics)
    synthesisTime=$(jq '.synthesisTime.value' $simulationMetrics)
    verifyTime=$(jq '.verifyTime.value' $simulationMetrics)

    if [[ -f $examplesData ]]
    then
        numTransactions=$(jq '.transactionHistory | length' $examplesData)
    else
        numTransactions=?
    fi

    if [[ -f $evaluatorQueries ]]
    then
        numQueries=$(jq -s 'length' $evaluatorQueries)
    else
        numQueries=?
    fi

    if [[ -f $synthesisData ]]
    then
        synthesisOutput=$(jq '.output[]' $synthesisData)
    else
        synthesisData=?
    fi

    if [[ -f $verifierData ]]
    then
        verifySuccess=$(jq '.success' $verifierData)
    else
        verifySuccess=?
    fi

    row="$exampleName & $numExamples & $examplesTime & $synthesisTime & $verifyTime & $numTransactions & $numQueries & $synthesisOutput & $verifySuccess \\\\"

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
