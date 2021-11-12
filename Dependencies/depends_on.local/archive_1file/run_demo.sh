#!/bin/bash

cd $(dirname $0)

RUN() {
    echo "-- $*"
    echo "Press <enter>"
    read DUMMY
    [ "$DUMMY" = "q" ] && exit 0
    [ "$DUMMY" = "Q" ] && exit 0

    eval $*
}

MODIFY_MAIN_TF() {
    NEW_CONTENT=$*

    echo; echo "---- Modifying content of the local_file.file1 resource in main.tf"
    set -x
    sed -i "s/^  *content.*/    content=\"$NEW_CONTENT\"/" main.tf
    set +x
    #sed -i 's/^  *content.*/    content="'$NEW_CONTENT'"/' main.tf
    #sed -i 's/^  *content.*/    content="Modified content for file1 !!"/' main.tf
    RUN grep " content=" main.tf
    #RUN terraform apply
    #RUN ls -ltr files/
    #RUN unzip -l files/archive.zip
}

INIT() {
    [ ! -f .terraform.lock.hcl ] &&
        RUN terraform init
}

RM_FILES() {
    [ -d files/ ] &&
        RUN rm -rf files/
}

APPLY() {
    RUN terraform apply
    RUN ls -ltr files/
}

REAPPLY() {
    RUN terraform apply
    RUN ls -ltr files/
    RUN unzip -l files/archive.zip
    RUN unzip -p  files/archive.zip ; echo
}

## -- Main --------------------------------------------------

INIT

## Implicit_dependency

RM_FILES
echo; echo "======== Running 'implicit_dependency' test ========"
RUN cat main.tf.implicit_dependency
RUN cp -a main.tf.implicit_dependency main.tf

echo; echo "---- Applying 'implicit_dependency' config"
APPLY

MODIFY_MAIN_TF "[implicit_dependency] Modified content for file1"
REAPPLY

## No depends_on

RM_FILES
echo; echo "======== Running 'WITHOUT depends_on' test ========"

RUN cat main.tf.no_depends_on
RUN cp -a main.tf.no_depends_on main.tf

echo; echo "---- Applying 'no_depends_on' config"
APPLY

MODIFY_MAIN_TF "[no_depends] Modified content for file1"
REAPPLY

## With depends_on

RM_FILES
echo; echo "======== Running 'depends_on' test ========"

RUN cat main.tf.depends_on
RUN cp -a main.tf.depends_on main.tf

echo; echo "---- Applying 'depends_on' config"
APPLY

MODIFY_MAIN_TF "[depends] Modified content for file1"
REAPPLY

