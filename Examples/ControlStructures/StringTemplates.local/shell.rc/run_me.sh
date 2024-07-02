#!/bin/bash

. ./rcfile

die() { echo "$0: die - $*" >&2; exit 1; }

# Use of bash variables in this template will need to be escaped if in the form dollar-brace-NAME-closingBrace
# So bash variables must be specified here either as
# - $VAR    ==> $VAR
# - $${VAR} ==> $VAR

[ -z "${NUM}"     ] && die "Unset NUM arg"
[ -z "${MESSAGE}" ] && die "Unset MESSAGE arg"
[ -z "${SLEEP}"   ] && die "Unset SLEEP arg"

for I in $(seq ${NUM}); do
    echo "Loop${I}/${NUM}: $(date) - ${MESSAGE}"
    sleep ${SLEEP}
done

