#!/bin/bash
FILE="$1"
SLOW=slow_"$1"
ffmpeg -i $1  -filter_complex "[0:v]setpts=2*PTS[v];[0:a]atempo=0.5[a]" -map "[v]" -map "[a]" $SLOW

