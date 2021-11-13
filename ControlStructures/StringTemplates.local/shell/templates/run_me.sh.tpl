#!/bin/bash

# NOTE: Is there a way of escaping ${} so that we can use ${P_NUM} syntax without it being misinterpreted as a template variable ?

P_NUM=${NUM}
P_MESSAGE="${MESSAGE}"
P_SLEEP=${SLEEP}

die() { echo "$0: die - $*" >&2; exit 1; }

[ -z "$P_NUM"     ] && die "Unset P_NUM arg"
[ -z "$P_MESSAGE" ] && die "Unset P_MESSAGE arg"
[ -z "$P_SLEEP"   ] && die "Unset P_SLEEP arg"

for I in $(seq $P_NUM); do
    echo "Loop$I/$P_NUM: $(date) - $P_MESSAGE"
    sleep $P_SLEEP
done

