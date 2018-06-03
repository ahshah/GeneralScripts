#!/bin/bash
FILE="$1"
SLOW=slow_"$1"
ffmpeg -i $1  -filter_complex "[0:v]setpts=1.5*PTS[v];[0:a]atempo=0.66666[a]" -map "[v]" -map "[a]" $SLOW

