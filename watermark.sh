#!/bin/bash
IN=$1
OUT=$2
TEXT="$3"
FONT_FILE="$HOME/.bin/GeneralScripts/Roboto-Regular.ttf"
# List codecs via: ffmpeg -codecs
# Also here: https://gist.github.com/Brainiarc7/95c9338a737aa36d9bb2931bed379219
HW_ACCEL="-codec:v h264_videotoolbox -b:v 8000k"
#HW_ACCEL="-codec:v h2
echo ffmpeg -i $IN -strict -2 -vf drawtext=text=$TEXT:x=10:y=H-th-10:fontfile=$FONT_FILE:fontsize=80:fontcolor=white:shadowcolor=black:shadowx=1:shadowy=1 $HW_ACCEL $OUT
ffmpeg -i $IN -c:v libx264 -crf 20 -strict -2 -vf "drawtext=text=$TEXT:x=10:y=H-th-10:fontfile=$FONT_FILE:fontsize=80:fontcolor=white:shadowcolor=black:shadowx=1:shadowy=1" $HW_ACCEL $OUT
