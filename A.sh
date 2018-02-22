#!/bin/bash

function main
{
    validate_arguments $@

    size_scoped_files=()

    files=$(find $1 -mindepth 1 -type f -printf "%p\n")
    for file in $files
    do
        fsize=$(stat --printf="%s" $file)
        if is_proper_fsize $fsize $2 $3
        then
            size_scoped_files+=($file)
        fi
    done

    offset=0
    for (( i=0; i<${#size_scoped_files[@]}; i++ ))
    do
        for (( j=$offset; j<${#size_scoped_files[@]}; j++ ))
        do
            if [ ${size_scoped_files[i]} != ${size_scoped_files[j]} ] && \
                is_identical ${size_scoped_files[i]} ${size_scoped_files[j]}
            then
                echo ${size_scoped_files[i]} "is identical to" ${size_scoped_files[j]}
            fi
        done
        offset=$(( $offset + 1  ))
    done
}

function validate_arguments
{
    if [ $# -lt 3 ]
    then
        echo "$0: missing operand"
        exit 1
    elif [ ! -d $1 ]
    then
        echo "$0: directory '$1' not found"
        exit 1
    elif ! is_positive_integer $2
    then
        echo "$0: second argument must be a positive integer"
        exit 1
    elif ! is_positive_integer $3
    then
        echo "$0: third argument must be a positive integer"
        exit 1
    elif [ $3 -lt $2 ]
    then
        echo "$0: min size (arg 2) can not be greater than max size (arg 3)"
        exit 1
    fi
}

function is_positive_integer
{
    return $([[ $1 =~ ^(0|[1-9][0-9]*)$ ]])
}

function is_proper_fsize
{
    return $([ $1 -ge $2 ] && [ $1 -le $3 ])
}

function is_identical
{
    if ! cmp --silent $1 $2
    then
        return 1
    else
        return 0
    fi
}

main $@
