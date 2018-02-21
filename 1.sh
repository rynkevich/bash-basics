function is_positive_integer
{
    return $([[ $1 =~ ^(0|[1-9][0-9]*)$ ]])
}

if [ $# -lt 2 ]
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
fi

files=$(find $1 -mindepth 1 -maxdepth $2 -type d -printf "%p\n")

for file in $files
do
    info=$(realpath $file)' '$(find $file -mindepth 1 -maxdepth 1 -type f | wc -l)
    if [ $# -eq 3 ]
    then
        echo $info >> $3
    else
        echo $info
    fi
done

if [ $2 -eq 0 ]
then
    echo 1
else
    echo $(find $1 -mindepth 0 -maxdepth $(( $2 - 1 )) -type d | wc -l)
fi