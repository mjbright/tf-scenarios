#!/bin/bash

# jq info:
# - https://stedolan.github.io/jq/manual/
# - https://www.baeldung.com/linux/jq-command-json
# - https://stedolan.github.io/jq/tutorial/



GATHER_DIR=~/tmp/get_instances
GATHER_FILE=$GATHER_DIR/get_instances.$$.json

GLOBAL_INSTANCE="UNSET"

POST_OUTPUT_GREP=""

VERBOSE=0

JQ_OPTS="-c"

mkdir -p $GATHER_DIR

GATHER_FN=gather_ALL
OUTPUT_FN=output_BASIC

## -- Functions: -----------------------------------------------------------

die() { echo "$0: die - $*" >&2; exit 1; }

HIGHLIGHTS() {
    HIGHLIGHT "red" "terminated" |
    HIGHLIGHT "pink" "shutting-down" |
    HIGHLIGHT "blue" "pending" |
    HIGHLIGHT "green" "running"
}

HIGHLIGHT() {
    local COLOUR="$1"; shift
    local MATCH="$1"; shift

    local COL
    local NOCOL="[00m"

    case $COLOUR in
        black)  COL="[00;30m";;
        red)    COL="[00;31m";;
        green)  COL="[00;32m";;
        yellow) COL="[00;33m";;
        blue)   COL="[00;34m";;
        pink)   COL="[00;35m";;
        cyan)   COL="[00;36m";;
        white)  COL="[00;37m";;

        *)      COL="[00;34m";;
    esac

    sed -e "s/${MATCH}/${COL}${MATCH}${NOCOL}/ig"
}

# Input gathering/filtering functions:

gather_ALL() {
    HEADER="All instances"
    aws ec2 describe-instances
}

gather_RUN() {
    HEADER="All running instances"
    aws ec2 describe-instances --filter 'Name=instance-state-name,Values=running'
}

gather_INSTANCE() {
    HEADER="instances $GLOBAL_INSTANCE"
    aws ec2 describe-instances --instance-ids $GLOBAL_INSTANCE
}

gather_TF_RUN() {
    HEADER="All running Terraform instances (tagged with key 'Terraform')"
    aws ec2 describe-instances --filter 'Name=instance-state-name,Values=running' 'Name=tag-key,Values=Terraform'
}

gather_NOT_TF_RUN() {
    gather_RUN
    HEADER="All running non-Terraform instances (NOT tagged with key 'Terraform')"
    POST_OUTPUT_GREP="grep -v Terraform"
    # BAD aws ec2 describe-instances --filter 'Name=instance-state-name,Values=running' | jq '.Reservations[].Instances[] | select '

    #BAD aws ec2 describe-instances --filter 'Name=instance-state-name,Values=running' | jq '.Reservations[].Instances[] | select '
}

# Output formatting functions:

output_BASIC() {
    #jq $JQ_OPTS '.Reservations[].Instances[] | {InstanceId,State,Tags,LaunchTime}'
    jq $JQ_OPTS '.Reservations[].Instances[] | {id:.InstanceId, image:.ImageId, state: .State.Name, Tags, LaunchTime}'
}

output_IMPORT() {
    #jq $JQ_OPTS '.Reservations[].Instances[] | {InstanceId,ImageId,InstanceType}'
    jq $JQ_OPTS '.Reservations[].Instances[] | {id:.InstanceId, image:.ImageId, type:.InstanceType, state: .State.Name, Tags}'
}

output_ALL() {
    jq $JQ_OPTS '.Reservations[].Instances[]'
}

## -- Args: ----------------------------------------------------------------

while [ ! -z "$1" ]; do
    case $1 in
        # INPUT: i/p gathering options:
        -ia*) GATHER_FN=gather_ALL;;
        -ir*) GATHER_FN=gather_RUN;;
        -int*) GATHER_FN=gather_NOT_TF_RUN;;
        -ii*) GATHER_FN=gather_INSTANCE; shift; GLOBAL_INSTANCE=$1;;
        -ic*) GATHER_FN=cat;;

        -il*) GATHER_FILE=$GATHER_DIR/last.json;; # FIND LAST

        # IMPORT: i/p gather + o/p filtering options:
        -im*) GATHER_FN=gather_NOT_TF_RUN; OUTPUT_FN=output_IMPORT;;

        # OUTPUT: o/p filtering options:
        -ob*) OUTPUT_FN=output_BASIC;;
        -oi*) OUTPUT_FN=output_IMPORT;;
        -oa*) OUTPUT_FN=output_ALL;;

        # JQ_OPTS: jq output format options:
        -jc) JQ_OPTS="-c";;
        -jr) JQ_OPTS="-r";;
        #-je) JQ_OPTS="-e";;

        -v) VERBOSE=1;;
        -x) set -x;;
        +x) set +x;;

        *) die "Unknown option <$1>";;
    esac
    shift
done

## -- Main: ----------------------------------------------------------------

$GATHER_FN > $GATHER_FILE
COUNT=$(grep -c InstanceId $GATHER_FILE)

ACCOUNT_NAME=$( env | grep LINKED_ACCOUNT | sed 's/.*=//' )

if [ -z "$POST_OUTPUT_GREP" ]; then
    echo; echo "-- ${ACCOUNT_NAME} [count:$COUNT]-- $HEADER -----------------"
    $OUTPUT_FN < $GATHER_FILE | HIGHLIGHTS
else
    GATHER_GREP=$GATHER_DIR/last.grep
    $OUTPUT_FN < $GATHER_FILE | eval $POST_OUTPUT_GREP > $GATHER_GREP

    COUNT=$(wc -l < $GATHER_GREP)
    echo; echo "--[count:$COUNT]-- $HEADER -----------------"
        #sed -e 's/.*id"*,:"/resource "aws_instance" "/' \
        #sed -e 's/.*id"[^\,]+,:"/resource "aws_instance" "/' \
    # {"id":"i-0a9bebf576ac2e4b8","image":"ami-0e42deec9aa2c90ce","type":"t2.micro","state":"running","Tags":[{"Key":"aws-cli","Value":"true"}]}
            #-e 's/"image":"/ "item" {\n    image_id: "/' \
          #  -e 's/"image_id"/image_id/' \
    cat $GATHER_GREP |  \
        sed -e 's/.*id"[^\,]*,/resource "aws_instance"/' \
            -e 's/"image":"/ "item" {\n    ami: "/' \
            -e 's/","/"\n    "/' \
            -e 's/",".*/"\n}/' \
            -e 's/ami/ami/' \
            -e 's/"type"/instance_type/' \
            -e 's/:/ = /g' | HIGHLIGHTS
fi

[ "$GATHER_FILE" != "$GATHER_DIR/last.json" ] && cp $GATHER_FILE $GATHER_DIR/last.json
[ $VERBOSE -ne 0 ] && ls -al $GATHER_DIR/last.json

exit

# NOT RUNNING FILTER:
#  -filters Name=instance-state-name,Values=pending,running,shutting-down,stopping,stopped

#aws ec2 describe-instances > temp.instances.json
echo; echo "All instances"; aws ec2 describe-instances | show_instance_info
echo; echo "All running instances"; aws ec2 describe-instances --filter 'Name=instance-state-name,Values=running' | show_instance_info
echo; echo "All running Tagged/Terraform instances"; aws ec2 describe-instances --filter 'Name=instance-state-name,Values=running' 'Name=tag-key,Values=Terraform' | show_instance_info
#echo; echo "All non-running Tagged/Terraform instances"; aws ec2 describe-instances --filter 'Name=instance-state-name,Values!=running' 'Name=tag-key,Values=Terraform' | show_instance_info

exit


