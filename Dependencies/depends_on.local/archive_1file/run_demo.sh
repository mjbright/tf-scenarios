#!/bin/bash

# TODO: cat file with highlights
# TODO: 

cd $(dirname $0)


## -- Colours: -----------------------------------------------

#  NORMAL;           BOLD;                 INVERSE;
_black='\e[00;30m';  _L_black='\e[01;30m';  _I_black='\e[07;30m'
_white='\e[00;37m';  _L_white='\e[01;37m';  _I_white='\e[07;37m'
_red='\e[00;31m';    _L_red='\e[01;31m';    _I_red='\e[07;31m'
_green='\e[00;32m';  _L_green='\e[01;32m'   _I_green='\e[07;32m'
_yellow='\e[00;33m'; _L_yellow='\e[01;33m'  _I_yellow='\e[07;33m'
_blue='\e[00;34m'    _L_blue='\e[01;34m'    _I_blue='\e[07;34m'
_magenta='\e[00;35m' _L_magenta='\e[01;35m' _I_magenta='\e[07;35m'
_cyan='\e[00;36m'    _L_cyan='\e[01;36m'    _I_cyan='\e[07;36m'

_norm='\e[00m'

black()   { echo -en $_black;   echo -n "$*" ; echo -en $_norm; }
white()   { echo -en $_white;   echo -n "$*" ; echo -en $_norm; }
red()     { echo -en $_red;     echo -n "$*" ; echo -en $_norm; }
green()   { echo -en $_green;   echo -n "$*" ; echo -en $_norm; }
yellow()  { echo -en $_yellow;  echo -n "$*" ; echo -en $_norm; }
blue()    { echo -en $_blue;    echo -n "$*" ; echo -en $_norm; }
magenta() { echo -en $_magenta; echo -n "$*" ; echo -en $_norm; }
cyan()    { echo -en $_cyan;    echo -n "$*" ; echo -en $_norm; }

#red "Hello world "; yellow "from "; blue "BLUE!!"
#echo

## -- Functions: ---------------------------------------------

RUN() {
    PRESS "-- $*"

    case "$1" in
        unzip)
	    if [ "$2" = "-p" ]; then
		eval $* | sed \
		    -e 's/^/        /'  \
                    -e "s,.*,"'\x1B[33m&\x1B[0m,'
	    else
		eval $* | sed 's/^/        /'
	    fi
	    ;;
        ls)   eval $* | sed 's/^/        /' ;;
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

HCAT() {
    MATCH="$1"; shift
    FILE="$1"; shift

    #echo -e "${_red}TEST${_norm} <<== RED"
    cat $FILE | sed \
       -e "s/^/        /" \
       -e "s,${MATCH},"'\x1B[33m&\x1B[0m,'
       #-e "s,${MATCH},"'\x1B[31m&\x1B[0m,'
       #-e "s/localhost/${_red}XX&XX${_norm}/g"
       #-e "s/localhost/${_red}XX&XX${_norm}/g"
       #-e 's/localhost/'"${_red}"XX'&'XX"${_norm}"'/g'
       #-e 's/localhost/'"${_red}"'&'"${_norm}"'/g'
       #-e "s/localhost/${red}XXlocalhost${normal}/"
       #-e "s/localhost/${red}\1${normal}/"
       #-e "s/\($MATCH\)/${red}\1${normal}/"
}

#echo hello | sed -e 's,.*,\x1B[31m&\x1B[0m,'
#HCAT "localhost" /etc/hosts
#exit

MODIFY_MAIN_TF() {
    NEW_CONTENT=$*

    echo; echo "---- Modifying content of the local_file.file1 resource in main.tf"
    grep --color=ALWAYS " content.*=" main.tf | sed 's/^/    BEFORE:        /'
    #set -x
    sed -i "s/^  *content.*/    content=\"$NEW_CONTENT\"/" main.tf
    #set +x
    #echo '-- grep --color=ALWAYS " content=" main.tf'
    grep --color=ALWAYS " content.*=" main.tf | sed 's/^/    AFTER:         /'
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

## -- Main: --------------------------------------------------

INIT

## Implicit_dependency

START_AFRESH

echo; echo "-- Example main.tf.* files"
ls -altr main.tf.*

echo; green "================ Running 'implicit_dependency' test ================"; echo
RUN cp -a main.tf.implicit_dependency main.tf
#grep --color=ALWAYS source_file.* main.tf | sed 's/^/        /'
#RUN cat main.tf.implicit_dependency
HCAT "source_file.*" main.tf.implicit_dependency

echo; echo "---- Applying 'implicit_dependency' config" | grep Applying
APPLY

PRESS
MODIFY_MAIN_TF "[implicit_dependency] Modified content for file1"
REAPPLY
PRESS

## No depends_on

echo; green "================ Running 'WITHOUT depends_on' test ================"; echo

RUN cp -a main.tf.no_depends_on main.tf
#grep --color=ALWAYS source_file.* main.tf | sed 's/^/        /'
#RUN cat main.tf.no_depends_on
HCAT "source_file.*" main.tf.no_depends_on
#RUN diff main.tf.no_depends_on main.tf.implicit_dependency

START_AFRESH
echo; echo "---- Applying 'no_depends_on' config" | grep Applying

## APPLY will fail because it doesn't know to create file resource before creating zip:
APPLY
PRESS

## COMMENT because APPLY will have failed:
## MODIFY_MAIN_TF "[no_depends] Modified content for file1"
## REAPPLY

## With depends_on

echo; green "================ Running 'depends_on' test ================"; echo
START_AFRESH

RUN cp -a main.tf.depends_on main.tf
#grep --color=ALWAYS depends_on main.tf | sed 's/^/        /'
#RUN cat main.tf.depends_on
HCAT "depends_on.*=" main.tf.depends_on
#RUN diff main.tf main.tf.no_depends_on

echo; echo "---- Applying 'depends_on' config" | grep Applying
APPLY

PRESS
MODIFY_MAIN_TF "[depends] Modified content for file1"
REAPPLY

