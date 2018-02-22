#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGC=$#

readonly SELECTED_DIRNAME=$1

readonly VALID_ARGC=1

function main
{
    validate_arguments

    local files=$(find $SELECTED_DIRNAME -maxdepth 2 -type f -printf "%p\n")

    local fcount=0
    for file in $files
    do
        echo $(stat --printf="%n %A %s bytes\n" $file)
        fcount=$(( $fcount + 1 ))
    done

    echo $fcount
}

function validate_arguments
{
    if [ $ARGC -lt $VALID_ARGC ]
    then
        echo "$PROGNAME: missing operand"
        exit 1
    elif [ ! -d $SELECTED_DIRNAME ]
    then
        echo "$PROGNAME: directory '$SELECTED_DIRNAME' not found"
        exit 1
    fi
}

main
