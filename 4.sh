#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGC=$#

readonly DIR1=$1
readonly DIR2=$2

readonly VALID_ARGC=2

function main
{
    validate_arguments

    local dir1_files=$(find $DIR1 -maxdepth 1 -type f -printf "%p\n")
    local dir2_files=$(find $DIR2 -maxdepth 1 -type f -printf "%p\n")

    for dir1_file in $dir1_files
    do
        for dir2_file in $dir2_files
        do
            if diff --brief $dir1_file $dir2_file
            then
                echo "Files $dir1_file and $dir2_file are identical"
            fi
        done
    done

    echo $(( $(wc -w <<< $dir1_files) + $(wc -w <<< $dir2_files) ))
}

function validate_arguments
{
    if [ $ARGC -lt $VALID_ARGC ]
    then
        echo "$PROGNAME: missing argument"
        exit 1
    elif [ ! -d $DIR1 ]
    then
        echo "$PROGNAME: directory '$DIR1' not found"
        exit 1
    elif [ ! -d $DIR2 ]
    then
        echo "$PROGNAME: directory '$DIR2' not found"
        exit 1
    fi
}

main
