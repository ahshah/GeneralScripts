#!/bin/bash
IN_PATH=$1
OUTPUT=$2
if [[ $IN_PATH == "" ]]; then
    echo "Missing input path parameter"
    echo "Usage $0 <input path> <output file>"
    exit
fi
IN_PATH=$PWD/$IN_PATH

if [[ $OUTPUT == "" ]]; then
    echo "Missing output file parameter.. taking a guess"
    OUTPUT=$(ls $IN_PATH | sort | head -1)
    OUTPUT=$(basename $OUTPUT .mp4)_full.mp4
    echo "Determined output to be: $OUTPUT"
fi

if [[ $OUTPUT == "" ]]; then
    echo "Guessed output file invalid, exiting"
    exit
fi

OUTPUT_DIR=$(dirname $OUTPUT)
if [[ ! -d $OUTPUT_DIR ]]; then
    echo "Output location $OUTPUT_DIR is not directory"
    exit
fi

TMP=$(mktemp)
i=0;
for file in $(ls $IN_PATH | grep mp4 | sort)
do
    if [[ ! -f $file ]];
    then
        echo "Skipping $file"
        continue;
    fi
    echo "[$i]: $PWD/$file"
    echo "file '$PWD/$file'" >> $TMP
    ((i++))
done
echo "Tmp file is $TMP"
echo "OUTPUT: $OUTPUT"

ffmpeg -f concat -safe 0 -i $TMP -c copy $OUTPUT
