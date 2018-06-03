#!/usr/local/bin/bash

INPUT_FILE=$1
INPUT_LIST=$2
END_TIME_DEFAULT=00:02:35.0 

if [[ $INPUT_FILE == "" || $INPUT_LIST == "" ]];
then
   echo "Usage: $0 <input_file> <cut index>"
   echo ""
   echo "Cut index format: "
   echo "<start time> <file name> <length of cut (optional)>"
   exit
fi


i=0
declare -a args_start_time
declare -a args_end_time
declare -a args_file_out
while IFS='' read -r line || [[ -n "$line" ]] 
do
  start=$(echo $line | awk 'BEGIN {FS=" "}; {print $1}')
  team=$(echo $line | awk 'BEGIN {FS=" "}; {print $2}')
  length=$(echo $line | awk 'BEGIN {FS=" "}; {print $3}')
  if [[ $length == "" ]];
  then
     length=$END_TIME_DEFAULT
  fi
  
  out=cut_$i
  out+=_$team
  out+=_$INPUT_FILE

  if [[ $start == "" ]]; then 
    echo "Skiping empty start time"
    continue
  fi
  #echo "Set $line to $out vs $INPUT_FILE"
  args_start_time[$i]=$start
  args_end_time[$i]=$length
  args_file_out[$i]=$out
  ((i++))
done < $INPUT_LIST

for k in "${!args_file_out[@]}"
do
   #echo "Read array val $k"
   OUTPUT_FILE=${args_file_out[$k]}
   START_TIME=${args_start_time[$k]}
   LENGTH=${args_end_time[$k]}

   echo "Cutting file $INPUT_FILE to $OUTPUT_FILE starting at $START_TIME with duration $LENGTH"
   #echo "command:  ffmpeg -loglevel warning -ss $START_TIME -i $INPUT_FILE -c copy -t $LENGTH $OUTPUT_FILE"
   ffmpeg -loglevel warning -ss $START_TIME -i $INPUT_FILE -c copy -t $LENGTH $OUTPUT_FILE
done

