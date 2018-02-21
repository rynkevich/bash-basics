#!/bin/bash

readonly MAX_FILES_TO_OUT=20

function main
{
    validate_arguments $@

    files=$(find $3 -mindepth 1 -type f -printf "%p\n")
    fcount=1
    for file in $files
    do
        fsize=$(wc -c < $file)
        if is_proper_fsize $1 $2
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
    if [ $# -lt 3 ]
    then
        echo "$0: missing operand"
        exit 1
    elif ! is_positive_integer $1
    then
        echo "$0: first argument must be a positive integer"
        exit 1
    elif ! is_positive_integer $2
    then
        echo "$0: second argument must be a positive integer"
        exit 1
    elif [ $2 -lt $1 ]
    then
        echo "$0: max size (arg 1) can not be greater than min size (arg 2)"
        exit 1
    elif [ ! -d $3 ]
    then
        echo "$0: directory '$3' not found"
        exit 1
    fi
}

function is_positive_integer
{
    return $([[ $1 =~ ^(0|[1-9][0-9]*)$ ]])
}

function is_proper_fsize
{
    return $([ $fsize -ge $1 ] && [ $fsize -le $2 ])
}

main $@
