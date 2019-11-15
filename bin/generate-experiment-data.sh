#!/usr/bin/env bash

set -euxo pipefail

eval "cd .."
CURRENTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
PATH_to_CONFIG="${CURRENTDIR}/configs" 

for file in "${PATH_to_CONFIG}"/*; do
    cmd_config="sc-simulation "
    Full_filename="${file}" 
    SOURCE=$(eval "jq .source ${Full_filename}")
    SOURCE="${SOURCE%\"}"
    SOURCE="${SOURCE#\"}"
    [ "$SOURCE" == null ]  || cmd_config="${cmd_config} --source ${CURRENTDIR}/contracts/${SOURCE}"
    TARGET=$(eval "jq .target ${Full_filename}")
    TARGET="${TARGET%\"}"
    TARGET="${TARGET#\"}"
    [ "$TARGET" == null ] || cmd_config="${cmd_config} --target ${CURRENTDIR}/contracts/${TARGET}"
    STATES=$(eval "jq .states ${Full_filename}")
    [ "$STATES" == null ] || cmd_config="${cmd_config} --states ${STATES}"
    BALANCES=$(eval "jq .balances ${Full_filename}")
    [ "$BALANCES" == null ] || cmd_config="${cmd_config} --balances ${BALANCES}"
    PAYMENTS=$(eval "jq .payments ${Full_filename}")
    [ "$PAYMENTS" == null ] || cmd_config="${cmd_config} --payments ${PAYMENTS}"
    INTEGERS=$(eval "jq .integers ${Full_filename}")
    [ "$INTEGERS" == null ] || cmd_config="${cmd_config} --integers ${INTEGERS}"
    UNSIGNEDINTEGERS=$(eval "jq .unsignedintegers ${Full_filename}")
    [ "$UNSIGNEDINTEGERS" == null ] || cmd_config="${cmd_config} --unsigned-integers ${UNSIGNEDINTEGERS}"
    BYTES=$(eval "jq .bytes ${Full_filename}")
    [ "$BYTES" == null ] || cmd_config="${cmd_config} --bytes ${BYTES}"
    NUMACCOUNTS=$(eval "jq .numaccounts ${Full_filename}")
    [ "$NUMACCOUNTS" == null ] || cmd_config="${cmd_config} --num-accounts ${NUMACCOUNTS}"
    NUMSENDERS=$(eval "jq .numsenders ${Full_filename}")
    [ "$NUMSENDERS" == null ] || cmd_config="${cmd_config} --num-senders ${NUMSENDERS}"
    NUMEXAMPLES=$(eval "jq .numexamples ${Full_filename}")
    [ "$NUMEXAMPLES" == null ] || cmd_config="${cmd_config} --num-examples ${NUMEXAMPLES}"
    eval $cmd_config
done
