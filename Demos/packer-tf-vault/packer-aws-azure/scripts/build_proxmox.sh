#!/usr/bin/env bash

. setup_proxmox.rc

PROX0 

mkdir -p ~/tmp/packer_build

PKR_DIR=BUILD-proxmox
TF_DIR=$PKR_DIR/TF-proxmox-test

# HACK !!
cd $PKR_DIR
PKR_DIR=.


LOG="$HOME/tmp/packer_build/build_proxmox.op.txt"
die() { echo "$0: die - $*" >&2; exit 1; }

TIMER_hhmmss() {
    _REM_SECS=$1; shift

    let SECS=_REM_SECS%60

    let _REM_SECS=_REM_SECS-SECS
    let      MINS=_REM_SECS/60%60
    let _REM_SECS=_REM_SECS-60*MINS
    let       HRS=_REM_SECS/3600

    [ $SECS -lt 10 ] && SECS="0$SECS"
    [ $MINS -lt 10 ] && MINS="0$MINS"
}

GET_IMAGE_INFO() {
    die "TODO: GET_IMAGE_INFO"
}

if [ "$1" = "-image" ]; then
    GET_IMAGE_INFO
    exit
fi

[ -s "$LOG" ] &&
    { set -x; mv "$LOG" "${LOG}.prev"; set +x; }

echo "Writing packer output to '$LOG'"

## == Packer init ==================================
T0=$SECONDS
CMD="packer init $PKR_DIR/"
    echo "== $CMD"; $CMD; RES=$?
T1=$SECONDS
let TOOK=T1-T0
echo "Packer init took $TOOK secs"
[ $RES -ne 0 ] && die "Packer init error"

## == Packer build==================================
T0=$SECONDS
CMD="packer build $PKR_DIR/ | tee $LOG"
    echo "== $CMD"; eval $CMD; RES=$?
T1=$SECONDS
let TOOK=T1-T0
TIMER_hhmmss $TOOK
#echo "Packer build took $TOOK secs"
#echo "Packer build took ${HRS}h ${MINS}m ${SECS}s"
echo "Packer build took ${MINS}m ${SECS}s" | tee -a $LOG

[ $RES -ne 0 ] && die "Packer build error"

# GET_IMAGE_INFO

ls -al $LOG
echo "Wrote packer output to '$LOG'"

