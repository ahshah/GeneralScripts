#!/bin/bash
FILE=$1
FILE_MP3=$(basename $FILE .mp4).mp3

FILE_WITH_NOISE=with_noise_$FILE
AUDIO_FILE=$FILE_MP3
AUDIO_NOISE_FILE=audio_noise_$FILE_MP3
CLIPPED_AUDIO_NOISE_FILE=clipped_audio_noise_$FILE_MP3

if [[ "" == $FILE ]]; then
  echo "No file provided"
  echo "Usage: ./$0  <inputfile>"
  exit
fi

if [[ ! -f $FILE ]]; then
  echo "Not a file: $FILE"
  exit
fi

echo "Got $FILE"
echo "FINAL $FILE_WITH_NOISE"
echo "AUDIO $AUDIO_FILE"
echo "AUDIO_NOISE_FILE $AUDIO_NOISE_FILE"

echo "********************* Extracting audio ***"
ffmpeg -i $FILE -q:a 0 -map a $AUDIO_FILE

echo "********************* SOX audio ***"
sox $AUDIO_FILE -p synth whitenoise vol 0.02 | sox -m $AUDIO_FILE - $AUDIO_NOISE_FILE

echo "********************* CLIP SOX audio ***"
clipper.sh $AUDIO_NOISE_FILE 

echo "********************* REMUX audio ***"
#ffmpeg -i $FILE -i $AUDIO_NOISE_FILE -map 0:v -map 1:a -metadata:s:a:0 language=eng -metadata:s:a:1 language=sme -codec copy -shortest $FILE_WITH_NOISE
ffmpeg -i $FILE -i $CLIPPED_AUDIO_NOISE_FILE -map 0:0 -map 1:0 -c:v copy -c:a aac -b:a 256k -shortest $FILE_WITH_NOISE
