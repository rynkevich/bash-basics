#!/bin/bash

function main
{
    validate_arguments $@

    files=$(find $1 -maxdepth 2 -type f -printf "%p\n")

    fcount=0
    for file in $files
    do
        echo $(stat --printf="%n %A %s bytes\n" $file)
        fcount=$(( $fcount + 1 ))
    done

    echo $fcount
}

function validate_arguments
{
    if [ $# -eq 0 ]
    then
        echo "$0: missing operand"
        exit 1
    elif [ ! -d $1 ]
    then
        echo "$0: directory '$1' not found"
        exit 1
    fi
}

main $@
