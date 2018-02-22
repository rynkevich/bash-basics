#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGC=$#

readonly MIN_FSIZE=$1
readonly MAX_FSIZE=$2
readonly FOUT=$3

readonly VALID_ARGC=3

function main
{
    validate_arguments

    touch $FOUT
    local files=$(find . -maxdepth 2 -type f -printf "%p\n")

    for file in $files
    do
        local fsize=$(wc -c < $file)
        if is_proper_fsize $fsize $MIN_FSIZE $MAX_FSIZE
        then
            echo $(realpath $file) $(basename $file) $fsize 'bytes' >> $FOUT
        fi
    done

    wc -w <<< $files
}

function validate_arguments
{
    if [ $ARGC -lt $VALID_ARGC ]
    then
        echo "$PROGNAME: missing operand"
        exit 1
    elif ! is_positive_integer $MIN_FSIZE
    then
        echo "$PROGNAME: first argument must be a positive integer"
        exit 1
    elif ! is_positive_integer $MAX_FSIZE
    then
        echo "$PROGNAME: second argument must be a positive integer"
        exit 1
    elif [ $MAX_FSIZE -lt $MIN_FSIZE ]
    then
        echo "$PROGNAME: min size (arg 1) can not be greater than max size (arg 2)"
        exit 1
    fi
}

function is_positive_integer
{
    local num=$1

    return $([[ $num =~ ^(0|[1-9][0-9]*)$ ]])
}

function is_proper_fsize
{
    local fsize=$1
    local minsize=$2
    local maxsize=$3

    return $([ $fsize -ge $minsize ] && [ $fsize -le $maxsize ])
}

main
