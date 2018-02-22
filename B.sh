#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGC=$#

readonly SELECTED_DIRNAME=$1
readonly MIN_FSIZE=$2
readonly MAX_FSIZE=$3

readonly VALID_ARGC=3

function main
{
    validate_arguments

    local dirs=$(find $SELECTED_DIRNAME -maxdepth 1 -type d -printf "%p\n")

    for dir in $dirs
    do
        show_dir_fsize_info $dir $MIN_FSIZE $MAX_FSIZE
    done
}

function validate_arguments
{
    if [ $ARGC -lt $VALID_ARGC ]
    then
        echo "$PROGNAME: missing argument"
        exit 1
    elif [ ! -d $SELECTED_DIRNAME ]
    then
        echo "$PROGNAME: directory '$SELECTED_DIRNAME' not found"
        exit 1
    elif ! is_positive_integer $MIN_FSIZE
    then
        echo "$PROGNAME: second argument must be a positive integer"
        exit 1
    elif ! is_positive_integer $MAX_FSIZE
    then
        echo "$PROGNAME: third argument must be a positive integer"
        exit 1
    elif [ $MAX_FSIZE -lt $MIN_FSIZE ]
    then
        echo "$PROGNAME: min size (arg 2) can not be greater than max size (arg 3)"
        exit 1
    fi
}

function is_positive_integer
{
    local num=$1

    return $([[ $num =~ ^(0|[1-9][0-9]*)$ ]])
}

function show_dir_fsize_info
{
    local dir=$1
    local minsize=$2
    local maxsize=$3

    local files=$(find $dir -maxdepth 1 -type f -printf "%p\n")
    local fsize_sum=0
    local fcount=0
    for file in $files
    do
        local fsize=$(stat --printf="%s" $file)
        if is_proper_fsize $fsize $minsize $maxsize
        then
            fcount=$(( $fcount + 1 ))
            fsize_sum=$(( $fsize_sum + $fsize ))
        fi
    done

    echo $(realpath $dir) $fsize_sum $fcount
}

function is_proper_fsize
{
    local fsize=$1
    local minsize=$2
    local maxsize=$3

    return $([ $fsize -ge $minsize ] && [ $fsize -le $maxsize ])
}

main
