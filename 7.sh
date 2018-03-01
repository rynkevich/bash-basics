#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGC=$#

readonly SELECTED_DIRNAME=$1
readonly FOUT=$2

readonly VALID_ARGC=2

function main
{
    validate_arguments

    truncate -s 0 $FOUT

    local dirs=$(find $SELECTED_DIRNAME -maxdepth 1 -type d -printf "%p\n")

    for dir in $dirs
    do
        output_dir_fsize_info $dir $FOUT
    done
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

function output_dir_fsize_info
{
    local dir=$1
    local fout=$2

    local files=$(find $1 -maxdepth 1 -type f -printf "%p\n")
    local fsize_sum=0
    local fcount=0
    for file in $files
    do
        fcount=$(( $fcount + 1 ))
        fsize_sum=$(( $fsize_sum + $(stat --printf "%s" $file) ))
    done

    echo $(realpath $dir) $fsize_sum $fcount >> $fout
}

main
