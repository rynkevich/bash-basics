#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGC=$#

readonly MIN_FSIZE=$1
readonly MAX_FSIZE=$2
readonly SELECTED_DIRNAME=$3

readonly VALID_ARGC=3
readonly MAX_FILES_TO_OUT=20

function main
{
    validate_arguments

    local files=$(find $SELECTED_DIRNAME -maxdepth 1 -type f -printf "%p\n")
    local fcount=1
    for file in $files
    do
        local fsize=$(stat --printf="%s" $file)
        if is_proper_fsize $fsize $MIN_FSIZE $MAX_FSIZE
        then
            echo "$fcount." $(realpath $file) $(basename $file) $fsize 'bytes'
            if [ $fcount -eq $MAX_FILES_TO_OUT ]
            then
                break
            else
                fcount=$(( $fcount + 1 ))
            fi
        fi
    done
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
    elif [ ! -d $3 ]
    then
        echo "$PROGNAME: directory '$SELECTED_DIRNAME' not found"
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
