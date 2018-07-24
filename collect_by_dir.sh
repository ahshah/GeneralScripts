#!/bin/bash
RUN_PATH="$1"
if [[ $RUN_PATH == "" ]]; then
  echo "No path provided, exiting"
  exit -1
fi

echo "Running in: $RUN_PATH"
if [[ ! -d $RUN_PATH  ]]; then
  echo "Path provided ($RUN_PATH) is not a directory, exiting"
  exit -1
fi

cd "$RUN_PATH"
if [[ $? -ne 0 ]]; then
  echo "Unable to cd into path provided ($RUN_PATH)."
  exit -1
fi

for file in *.mp4; 
do 
    uniqdate=$(echo $file | awk 'BEGIN {FS="_"}; {print $1};'); 
    echo $uniqdate; 
done | sort | uniq | while read line
do 
    if [[ $line == "*.mp4" ]]; then 
        echo "Skip making *.mp4"
        continue;
    fi
    echo "Going to make DIR: $line";
    mkdir $line;
    mv $line*.mp4 $line;
done
