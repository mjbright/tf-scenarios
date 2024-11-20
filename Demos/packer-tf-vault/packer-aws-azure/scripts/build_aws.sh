
.  setup_aws.rc

#packer build -var-file  aws_variables.pkr.json -var-file aws_variables.pkr.hcl aws_builder.pkr.hcl 
#packer build -var-file aws_variables.pkr.hcl aws_builder.pkr.hcl 
#packer build aws_variables.pkr.hcl aws_builder.pkr.hcl 
#packer build aws_builder.pkr.hcl 
#
mkdir -p ~/tmp/packer_build

PKR_DIR=BUILD-aws
TF_DIR=$PKR_DIR/TF-AWS-test

LOG="$HOME/tmp/packer_build/build_aws.op.txt"

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
    AMI=$( tail -5 "$LOG" | awk '/ami-/ { print $2; }' )
    echo "AMI=$AMI"

    [ ! -z "$AMI" ] && {
        [ -f $TF_DIR/ami.auto.tfvars ] &&
            mv $TF_DIR/ami.auto.tfvars $TF_DIR/ami.auto.tfvars.prev
        echo "ami = \"$AMI\"" > $TF_DIR/ami.auto.tfvars

        echo "Updated file $TF_DIR/ami.auto.tfvars with ami='$AMI'"
    }
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

GET_IMAGE_INFO

ls -al $LOG
echo "Wrote packer output to '$LOG'"

