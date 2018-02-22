#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGC=$#

readonly EXT=$1
readonly HARD_LINK_DIRNAME=$2

readonly VALID_ARGC=2

function main
{
    validate_arguments

    local files=$(find . -maxdepth 2 -type f -printf "%p\n")

    for file in $files
    do
        if is_proper_extension $file $EXT
        then
            create_hard_link $file $HARD_LINK_DIRNAME
        fi
    done
}

function validate_arguments
{
    if [ $ARGC -lt $VALID_ARGC ]
    then
        echo "$PROGNAME: missing argument"
        exit 1
    elif [ ! -d $HARD_LINK_DIRNAME ]
    then
        echo "$PROGNAME: directory '$HARD_LINK_DIRNAME' not found"
        exit 1
    fi
}

function is_proper_extension
{
    local file=$1
    local proper_ext=$2

    local fname=$(basename $file)
    local ext=${fname##*.}

    return $([ $ext = $proper_ext ])
}

function create_hard_link
{
    local $source=$1
    local $hard_link_dirname=$2

    ln $source $hard_link_dirname"/"$(basename $source)
}

main
