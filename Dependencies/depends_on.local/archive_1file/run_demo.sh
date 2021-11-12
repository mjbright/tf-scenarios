#!/bin/bash

cd $(dirname $0)

RUN() {
    PRESS "-- $*"

    case "$1" in
        cat)  eval $* | sed 's/^/        /' ;;
        diff) eval $* | sed 's/^/        /' ;;
        *)    eval $* ;;
    esac
}

PRESS() {
    [ ! -z "$1" ] && echo $*
    echo "Press <enter>"
    read DUMMY
    [ "$DUMMY" = "q" ] && exit 0
    [ "$DUMMY" = "Q" ] && exit 0
}

MODIFY_MAIN_TF() {
    NEW_CONTENT=$*

    echo; echo "---- Modifying content of the local_file.file1 resource in main.tf"
    grep --color=ALWAYS " content.*=" main.tf | sed 's/^/BEFORE:        /'
    #set -x
    sed -i "s/^  *content.*/    content=\"$NEW_CONTENT\"/" main.tf
    #set +x
    echo '-- grep --color=ALWAYS " content=" main.tf'
    grep --color=ALWAYS " content.*=" main.tf | sed 's/^/AFTER:         /'
    PRESS ""
}

INIT() {
    [ ! -f .terraform.lock.hcl ] &&
        RUN terraform init
}

START_AFRESH() {
    # echo; echo "Cleaning up"
    [ ! -d files/ ] && {
        echo; echo "-- No files/ directory present"
        return
    }

    RUN rm -rf files/
    [ -f terraform.tfstate ] && RUN mv terraform.tfstate terraform.tfstate.backup
}

APPLY() {
    #ls -altr terraform.tfstate*
    RUN terraform apply
    RUN ls -ltr files/
}

REAPPLY() {
    #ls -altr terraform.tfstate*
    RUN terraform apply
    RUN ls -ltr files/
    RUN unzip -l files/archive.zip
    RUN unzip -p  files/archive.zip ; echo
}

## -- Main --------------------------------------------------

INIT

## Implicit_dependency

START_AFRESH

echo; echo "-- Example main.tf.* files"
ls -altr main.tf.*

echo; echo "======== Running 'implicit_dependency' test ========"
RUN cp -a main.tf.implicit_dependency main.tf
grep --color=ALWAYS source_file.* main.tf | sed 's/^/        /'
RUN cat main.tf.implicit_dependency

echo; echo "---- Applying 'implicit_dependency' config" | grep Applying
APPLY
PRESS

MODIFY_MAIN_TF "[implicit_dependency] Modified content for file1"
REAPPLY

## No depends_on

echo; echo "======== Running 'WITHOUT depends_on' test ========"

RUN cp -a main.tf.no_depends_on main.tf
grep --color=ALWAYS source_file.* main.tf | sed 's/^/        /'
RUN cat main.tf.no_depends_on
RUN diff main.tf.no_depends_on main.tf.implicit_dependency

START_AFRESH
echo; echo "---- Applying 'no_depends_on' config" | grep Applying

## APPLY will fail because it doesn't know to create file resource before creating zip:
APPLY
PRESS

## COMMENT because APPLY will have failed:
## MODIFY_MAIN_TF "[no_depends] Modified content for file1"
## REAPPLY

## With depends_on

echo; echo "======== Running 'depends_on' test ========"
START_AFRESH

RUN cat main.tf.depends_on
RUN cp -a main.tf.depends_on main.tf
RUN diff main.tf main.tf.no_depends_on

echo; echo "---- Applying 'depends_on' config" | grep Applying
APPLY

MODIFY_MAIN_TF "[depends] Modified content for file1"
REAPPLY

