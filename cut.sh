#!/bin/bash

INPUT_FILE=$1
OUTPUT_FILE=$2
START_TIME=$3
END_TIME=$4

if [[ $INPUT_FILE == "" || $OUTPUT_FILE == "" || $START_TIME == "" ]]
then
  echo "Usage is: $0 <input_file> <output file> <start_time> <optional duration>"
  exit
fi


if [[ $END_TIME == "" ]] 
then
    END_TIME=00:02:45.0
fi

echo "Cutting file $INPUT_FILE starting at $START_TIME"
ffmpeg -ss $START_TIME -i $INPUT_FILE -c copy -t $END_TIME $OUTPUT_FILE
