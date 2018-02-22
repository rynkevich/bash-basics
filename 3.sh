#!/bin/bash

readonly PROGNAME=$(basename $0)
readonly ARGC=$#

readonly SUBSTR=$1
readonly SELECTED_DIRNAME=$2

readonly VALID_ARGC=2

function main
{
    validate_arguments

    local files=$(find $SELECTED_DIRNAME -maxdepth 2 -type f -printf "%p\n")

    for file in $files
    do
        if ! is_reading_allowed $file
        then
            echo $(realpath $file) $(basename $file) \
                $(stat --printf="%s bytes" $file) "No access!"
        elif has_specified_string $SUBSTR $file
        then
            echo $(realpath $file) $(basename $file) \
                $(stat --printf="%s bytes" $file)
        fi
    done
}

function validate_arguments
{
    if [ $ARGC -lt $VALID_ARGC ]
    then
        echo "$PROGNAME: missing operand"
        exit 1
    elif [ ! -d $SELECTED_DIRNAME ]
    then
        echo "$PROGNAME: directory '$SELECTED_DIRNAME' not found"
        exit 1
    fi
}

function is_reading_allowed
{
    local file=$1

    return $([ -r $file ])
}

function has_specified_string
{
    local str=$1
    local file=$2

    return $(grep -q $str $file)
}

main
