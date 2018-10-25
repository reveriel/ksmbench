# save data files
# back up to $archive folder
# allow an argument as a note
time_file="times.txt"
cpu_file="cpu.txt"
sharing_file="sharing.txt"
archive="archive"
time=$(date +%m%d%H%M%S)

## main

./pull.sh

mkdir $archive/$time
cp $time_file $archive/$time
cp $cpu_file $archive/$time
cp $sharing_file $archive/$time
echo "save files to " $archive/$time

if [[ $# -eq 1 ]]; then
    echo "save note: " $1
    echo $1 > $archive/$time/note
fi


