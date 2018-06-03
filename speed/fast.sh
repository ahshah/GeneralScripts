#!/bin/bash
FILE="$1"
FAST=fast_"$1"
ffmpeg -i $1  -filter_complex "[0:v]setpts=0.5*PTS[v];[0:a]atempo=2[a]" -map "[v]" -map "[a]" $FAST

