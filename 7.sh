#!/bin/bash

function main
{
    validate_arguments $@

    touch $2
    dirs=$(find $1 -maxdepth 1 -type d -printf "%p\n")

    for dir in $dirs
    do
        output_dir_fsize_info $dir $2
    done
}

function validate_arguments
{
    if [ $# -lt 2 ]
    then
        echo "$0: missing argument"
        exit 1
    elif [ ! -d $1 ]
    then
        echo "$0: directory '$1' not found"
        exit 1
    fi
}

function output_dir_fsize_info
{
    local files=$(find $1 -maxdepth 1 -type f -printf "%p\n")

    local fsize_sum=0
    local fcount=0
    for file in $files
    do
        fcount=$(( $fcount + 1 ))
        fsize_sum=$(( $fsize_sum + $(stat --printf "%s" $file) ))
    done

    echo $(realpath $1) $fsize_sum $fcount >> $2
}

main $@
