#!/bin/bash

function main
{
    validate_arguments $@

    touch $3
    files=$(find $2 -maxdepth 2 -type f -printf "%p\n")

    for file in $files
    do
        if is_proper_owner $file $1
        then
            echo $(realpath $file) $(basename $file) $(stat --printf="%s bytes" $file) >> $3
        fi
    done

    wc -w <<< $files
}

function validate_arguments
{
    if [ $# -lt 3 ]
    then
        echo "$0: missing argument"
        exit 1
    elif [ ! -d $2 ]
    then
        echo "$0: directory '$2' not found"
        exit 1
    fi
}

function is_proper_owner
{
    return $([ $(stat --printf="%U" $1) = $2 ])
}

main $@
