#!/usr/local/bin/bash

INPUT_FILE=$1
INPUT_LIST=$2
END_DURATION=$3
if [[ $INPUT_FILE == "" || $INPUT_LIST == "" ]]
then
  echo "Usage is: $0 <input_file> <cut index> (optional duration)"
  exit
fi

if [[ $END_DURATION == "" ]] 
then
    END_DURATION=00:02:35.0
fi

i=0
declare -a args_start_time
declare -a args_file_out
while IFS='' read -r line || [[ -n "$line" ]] 
do
  start=$(echo $line | awk 'BEGIN {FS=" "}; {print $1}')
  out=cut_$i
  out+=_$INPUT_FILE
  if [[ $start == "" ]]; then 
    echo "Skiping empty start time"
    continue
  fi
  echo "Set $line to $out vs $INPUT_FILE"
  args_start_time[$i]=$start
  args_file_out[$i]=$out
  ((i++))
done < $INPUT_LIST

for k in "${!args_file_out[@]}"
do
   #kecho "Read array val $k"
   OUTPUT_FILE=${args_file_out[$k]}
   START_TIME=${args_start_time[$k]}
   echo "Cutting file $INPUT_FILE to  $OUTPUT starting at $START_TIME"
   ffmpeg -loglevel warning -ss $START_TIME -i $INPUT_FILE -c copy -t $END_DURATION $OUTPUT_FILE
done

