#!/bin/bash

FILE=$1
FILE_CLIPPED=clipped_$FILE

if [[ "" == $FILE ]]; then
  echo "No file provided"
  echo "Usage: ./$0  <inputfile>"
  exit
fi

SECS=$(sox $FILE -n stat 2>&1 | grep Length | awk '{print $3}')
PERIOD=$(echo "$SECS / 5" | bc)

DIRECTIVE=
for ((i=1; i < $PERIOD; i++))
do
    PAD_INTERVAL=$(echo $i*5 | bc);
    TRM_INTERVAL=$(echo $i*5+0.5 | bc);
    DIRECTIVE="$DIRECTIVE pad 0.5@$PAD_INTERVAL trim 0 $TRM_INTERVAL  0.5"
    #echo "pad 0.5@$PAD_INTERVAL trim 0 $TRM_INTERVAL 0.5"
done
sox $FILE $FILE_CLIPPED $DIRECTIVE
