#!/bin/bash

function main
{
    validate_arguments $@

    files=$(find $2 -maxdepth 2 -type f -printf "%p\n")

    for file in $files
    do
        if ! is_reading_allowed $file
        then
            echo $(realpath $file) $(basename $file) \
                $(stat --printf="%s bytes" $file) "No access!"
        elif has_specified_string $1 $file
        then
            echo $(realpath $file) $(basename $file) \
                $(stat --printf="%s bytes" $file)
        fi
    done
}

function validate_arguments
{
    if [ $# -lt 2 ]
    then
        echo "$0: missing operand"
        exit 1
    elif [ ! -d $2 ]
    then
        echo "$0: directory '$2' not found"
        exit 1
    fi
}

function is_reading_allowed
{
    return $([ -r $1 ])
}

function has_specified_string
{
    return $(grep -q $1 $2)
}

main $@
