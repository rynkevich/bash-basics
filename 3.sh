if [ $# -lt 2 ]
then
    echo "$0: missing operand"
    exit 1
elif [ ! -d $2 ]
then
    echo "$0: directory '$1' not found"
    exit 1
fi

files=$(find $2 -maxdepth 2 -type f -printf "%p\n")

for file in $files
do
    if [ ! -r $file ]
    then
        echo $(realpath $file) $(basename $file) \
            $(stat --printf="%s bytes" $file) "No access!"
    fi

    if grep -q $1 $file
    then
        echo $(realpath $file) $(basename $file) \
            $(stat --printf="%s bytes" $file)
    fi
done
