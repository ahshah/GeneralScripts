#!/bin/bash
FILE="$1"
SLOW=slow_4x_"$1"
ffmpeg -i $1  -filter_complex "[0:v]setpts=4*PTS[v]" -map "[v]" $SLOW

