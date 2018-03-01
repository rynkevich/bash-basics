#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGC=$#

readonly OWNERNAME=$1
readonly SELECTED_DIRNAME=$2
readonly FOUT=$3

readonly VALID_ARGC=3

function main
{
    validate_arguments

    truncate -s 0 $FOUT
    
    local files=$(find $SELECTED_DIRNAME -maxdepth 2 -type f -printf "%p\n")

    for file in $files
    do
        if has_proper_owner $file $OWNERNAME
        then
            echo $(realpath $file) $(basename $file) $(stat --printf="%s bytes" $file) >> $FOUT
        fi
    done

    wc -w <<< $files
}

function validate_arguments
{
    if [ $ARGC -lt $VALID_ARGC ]
    then
        echo "$PROGNAME: missing argument"
        exit 1
    elif [ ! -d $SELECTED_DIRNAME ]
    then
        echo "$PROGNAME: directory '$SELECTED_DIRNAME' not found"
        exit 1
    fi
}

function has_proper_owner
{
    local file=$1
    local owner=$2

    return $([ $(stat --printf="%U" $file) = $owner ])
}

main
