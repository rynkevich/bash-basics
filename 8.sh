#!/bin/bash

function main
{
    validate_arguments $@

    files=$(find . -maxdepth 2 -type f -printf "%p\n")

    for file in $files
    do
        if is_proper_extension $file $1
        then
            create_hard_link $file $2
        fi
    done
}

function validate_arguments
{
    if [ $# -lt 2 ]
    then
        echo "$0: missing argument"
        exit 1
    elif [ ! -d $2 ]
    then
        echo "$0: directory '$2' not found"
        exit 1
    fi
}

function is_proper_extension
{
    local fname=$(basename $file)
    local ext=${fname##*.}
    return $([ $ext = $2 ])
}

function create_hard_link
{
    ln $file $2"/"$(basename $file)
}

main $@
