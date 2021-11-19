#!/bin/bash

# We define bash variables P_* from template variable values:
P_NUM=${NUM}
P_MESSAGE="${MESSAGE}"
P_SLEEP=${SLEEP}

die() { echo "$0: die - $*" >&2; exit 1; }

# Use of bash variables in this template will need to be escaped if in the form dollar-brace-NAME-closingBrace
# So bash variables must be specified here either as
# - $VAR    ==> $VAR
# - $${VAR} ==> $VAR

[ -z "$${P_NUM}"     ] && die "Unset P_NUM arg"
[ -z "$${P_MESSAGE}" ] && die "Unset P_MESSAGE arg"
[ -z "$${P_SLEEP}"   ] && die "Unset P_SLEEP arg"

for I in $(seq $${P_NUM}); do
    echo "Loop$${I}/$${P_NUM}: $(date) - $${P_MESSAGE}"
    sleep $${P_SLEEP}
done

