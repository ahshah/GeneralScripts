#!/bin/bash
IN=$1
OUT=$2
TEXT="$3"
FONT_FILE="/home/op/.bin/GeneralScripts/Roboto-Regular.ttf"
echo ffmpeg -i $IN -strict -2 -vf drawtext=text=$TEXT:x=10:y=H-th-10:fontfile=$FONT_FILE:fontsize=80:fontcolor=white:shadowcolor=black:shadowx=1:shadowy=1 $OUT
ffmpeg -i $IN -c:v libx264 -crf 20 -strict -2 -vf "drawtext=text=$TEXT:x=10:y=H-th-10:fontfile=$FONT_FILE:fontsize=80:fontcolor=white:shadowcolor=black:shadowx=1:shadowy=1" $OUT
