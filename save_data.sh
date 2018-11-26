# save data files
# back up to $archive folder
# allow an argument as a note

# time_file="times.txt"
cpu_file="cpu.txt"
sharing_file="sharing.txt"
total_time_file="total_time.txt"
num_resume_file="num_resume.txt"

archive="archive"

time=$(date +%m%d%H%M%S)

## main


if [ $# -ne 1 ]; then
    echo "need one argument, <note>"
    exit 1
fi

./pull.sh

mkdir $archive/$time
# cp $time_file $archive/$time
cp $cpu_file $archive/$time
cp $sharing_file $archive/$time
cp $num_resume_file $archive/$time
cp $total_time_file $archive/$time
echo "save files to " $archive/$time

echo "save note: " $1
echo $1 > $archive/$time/note
# ./data_summary.py

