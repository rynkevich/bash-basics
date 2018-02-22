#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGC=$#

readonly SELECTED_DIRNAME=$1
readonly N1=$2
readonly N2=$3

readonly VALID_ARGC=3

function main
{
    validate_arguments

    local size_scoped_files=()

    local files=$(find $SELECTED_DIRNAME -mindepth 1 -type f -printf "%p\n")
    for file in $files
    do
        local fsize=$(stat --printf="%s" $file)
        if is_proper_fsize $fsize $N1 $N2
        then
            size_scoped_files+=($file)
        fi
    done

    local offset=0
    for (( i=0; i<${#size_scoped_files[@]}; i++ ))
    do
        for (( j=$offset; j<${#size_scoped_files[@]}; j++ ))
        do
            if [ ${size_scoped_files[i]} != ${size_scoped_files[j]} ] && \
                is_identical ${size_scoped_files[i]} ${size_scoped_files[j]}
            then
                echo ${size_scoped_files[i]} "is identical to" ${size_scoped_files[j]}
            fi
        done
        offset=$(( $offset + 1  ))
    done
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
    elif ! is_positive_integer $N1
    then
        echo "$PROGNAME: second argument must be a positive integer"
        exit 1
    elif ! is_positive_integer $N2
    then
        echo "$PROGNAME: third argument must be a positive integer"
        exit 1
    elif [ $N2 -lt $N1 ]
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

function is_proper_fsize
{
    local fsize=$1
    local minsize=$2
    local maxsize=$3

    return $([ $fsize -ge $minsize ] && [ $fsize -le $maxsize ])
}

function is_identical
{
    local file1=$1
    local file2=$2

    if ! cmp --silent $file1 $file2
    then
        return 1
    else
        return 0
    fi
}

main
