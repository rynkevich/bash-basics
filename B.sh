#!/bin/bash

function main
{
    validate_arguments $@

    dirs=$(find $1 -maxdepth 1 -type d -printf "%p\n")

    for dir in $dirs
    do
        show_dir_fsize_info $dir $2 $3
    done
}

function validate_arguments
{
    if [ $# -lt 3 ]
    then
        echo "$0: missing argument"
        exit 1
    elif [ ! -d $1 ]
    then
        echo "$0: directory '$1' not found"
        exit 1
    elif ! is_positive_integer $2
    then
        echo "$0: second argument must be a positive integer"
        exit 1
    elif ! is_positive_integer $3
    then
        echo "$0: third argument must be a positive integer"
        exit 1
    elif [ $3 -lt $2 ]
    then
        echo "$0: min size (arg 2) can not be greater than max size (arg 3)"
        exit 1
    fi
}

function is_positive_integer
{
    return $([[ $1 =~ ^(0|[1-9][0-9]*)$ ]])
}

function show_dir_fsize_info
{
    local files=$(find $1 -maxdepth 1 -type f -printf "%p\n")

    local fsize_sum=0
    local fcount=0
    for file in $files
    do
        local fsize=$(stat --printf="%s" $file)
        if is_proper_fsize $fsize $2 $3
        then
            fcount=$(( $fcount + 1 ))
            fsize_sum=$(( $fsize_sum + $fsize ))
        fi
    done

    echo $(realpath $1) $fsize_sum $fcount
}

function is_proper_fsize
{
    return $([ $1 -ge $2 ] && [ $1 -le $3 ])
}

main $@
