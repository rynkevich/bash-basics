#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGC=$#

readonly SELECTED_DIRNAME=$1
readonly NESTING=$2
readonly FOUT=$3

readonly VALID_ARGC=3

function main
{
    validate_arguments

    truncate -s 0 $FOUT

    local dirs=$(find $SELECTED_DIRNAME -mindepth 1 -maxdepth $NESTING -type d -printf "%p\n")

    for dir in $dirs
    do
        local info=$(realpath $dir)' '$(find $dir -mindepth 1 -maxdepth 1 -type f | wc -l)
        echo $info >> $FOUT
    done

    if [ $NESTING -eq 0 ]
    then
        echo 1
    else
        echo $(find $SELECTED_DIRNAME -mindepth 0 -maxdepth $(( $NESTING - 1 )) -type d | wc -l)
    fi
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
    elif ! is_positive_integer $NESTING
    then
        echo "$PROGNAME: second argument must be a positive integer"
        exit 1
    fi
}

function is_positive_integer
{
    local num=$1

    return $([[ $num =~ ^(0|[1-9][0-9]*)$ ]])
}

main
