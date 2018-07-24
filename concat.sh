#!/bin/bash
# Depends now on coreutils (for realpath):
#       $ brew install coreutils

INPUT_PATH=$1
OUTPUT_PATH=$2
OUTPUT_FN=$3

IN_PATH=$(realpath $INPUT_PATH 2>/dev/null)
if [[ $IN_PATH == "" ]]; then
    echo "Missing input path parameter: $INPUT_PATH is not valid"
    echo "Usage $0 <input path> <output path> <(optional) output file name>"
    exit
fi

OUT_PATH=$(realpath $OUTPUT_PATH)
if [[ $OUT_PATH == "" ]]; then
    echo "Missing output path parameter: $OUTPUT_PATH is not valid"
    echo "Usage $0 <input path> <output path> <(optional) output file name>"
    exit
fi

if [[ ! -e $OUT_PATH ]]; then
    echo "Output directory does not exist: $OUT_PATH attempting to make.."
    mkdir -p "$OUT_PATH"
fi;

if [[ ! -e $OUT_PATH ]]; then
    echo "Output directory does not exist: $OUT_PATH failed to make.."
    exit
fi;

if [[ ! -d $OUT_PATH ]]; then
    echo "Output directory is invalid: $OUT_PATH is not a directory"
    exit
fi


if [[ $OUTPUT_FN == "" ]]; then
    echo "Missing output file parameter.. taking a guess"
    OUTPUT_FN=$(ls "$IN_PATH" | sort | head -1)
    OUTPUT_FN=$(basename $OUTPUT_FN .mp4)_full.mp4
    echo "Determined output to be: $OUTPUT_FN"
fi

if [[ $OUTPUT_FN == "" ]]; then
    echo "Guessed output file invalid, exiting"
    exit
fi

OUTPUT_FILE_PATH=$OUT_PATH/$OUTPUT_FN
echo "OUTPUT: $OUTPUT_FILE_PATH"

TMP=$(mktemp)
echo "Tmp file is $TMP:"
i=0;
for file in $(ls "$IN_PATH" | grep mp4 | sort)
do
    file=$(realpath "$IN_PATH"/$file)
    if [[ ! -f $file ]];
    then
        echo "Skipping $file"
        continue;
    fi
    echo -e "\t [$i]: $file"
    echo "file '$file'" >> $TMP
    ((i++))
done

ffmpeg -f concat -safe 0 -i $TMP -c copy "$OUTPUT_FILE_PATH"
