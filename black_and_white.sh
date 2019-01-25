#!/bin/bash
INPUT=$1
OUTPUT=bw_$INPUT

ffmpeg -i "$1" -vf hue=s=0 -c:a copy $OUTPUT
