if [ $# -lt 2 ]
then
    echo "$0: missing argument"
    exit 1
elif [ ! -d $1 ]
then
    echo "$0: directory '$1' not found"
    exit 1
elif [ ! -d $2 ]
then
    echo "$0: directory '$2' not found"
    exit 1
fi

dir1_files=$(find $1 -maxdepth 1 -type f -printf "%p\n")
dir2_files=$(find $2 -maxdepth 1 -type f -printf "%p\n")

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

dir1_fcount=0
dir2_fcount=0
for dir1_file in $dir1_files
do
    dir1_fcount=$(( $dir1_fcount + 1 ))
done
for dir2_file in $dir2_files
do
    dir2_fcount=$(( $dir2_fcount + 1 ))
done
fcount=$(( $dir1_fcount + $dir2_fcount ))

echo $fcount
