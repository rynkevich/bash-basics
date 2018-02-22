#!/bin/bash

function main
{
    validate_arguments $@

    touch $3
    files=$(find . -maxdepth 2 -type f -printf "%p\n")

    for file in $files
    do
        fsize=$(wc -c < $file)
        if is_proper_fsize $fsize $1 $2
        then
            echo $(realpath $file) $(basename $file) $fsize 'bytes' >> $3
        fi
    done

    wc -w <<< $files
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
    fi
}

function is_positive_integer
{
    return $([[ $1 =~ ^(0|[1-9][0-9]*)$ ]])
}

function is_proper_fsize
{
    return $([ $1 -ge $2 ] && [ $1 -le $3 ])
}

main $@