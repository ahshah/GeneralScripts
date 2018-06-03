#!/bin/bash
RUN_PATH="$1"
VID_PATH="$RUN_PATH/../Videos/"
if [[ $RUN_PATH == "" ]]; then
  echo "No path provided, exiting"
  exit -1
fi
DATE=$(date)
echo "Running in: $RUN_PATH on $DATE"
if [[ ! -d $RUN_PATH  ]]; then
  echo "Path provided ($RUN_PATH) is not a directory, exiting"
  exit -1
fi

echo "Moving to: $VID_PATH"
if [[ ! -d $VID_PATH  ]]; then
  echo "Path provided ($VID_PATH) is not a directory, exiting"
  exit -1
fi
cd "$VID_PATH"
VID_PATH=$(pwd)

cd "$RUN_PATH"
if [[ $? -ne 0 ]]; then
  echo "Unable to cd into path provided ($RUN_PATH)."
  exit -1
fi

for FILE in VID_*;
do
  if [[ ! -f $FILE ]] ; then echo "Skipping rename, $FILE is not a file"; continue; fi 

   NAME=$(echo "$FILE" | cut -c5-)
   if [[ $(echo "$NAME" | cut -c-2) != "20" ]]; then echo "Skipping $NAME"; continue; fi
   
   NAME=$(echo "$NAME" | cut -c3-) 
   NAME=$(echo "$NAME" | sed 's/\([0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)\(.*\)/\1\.\2\.\3\4'/)
   echo "Going to move $FILE to $NAME"

  if [[ -e $NAME ]]; then echo "Skipping rename from $FILE to $NAME, duplciate found"; continue; fi

   mv "$FILE" "$NAME"
   echo "Going to move $NAME to $VID_PATH/$NAME"

  if [[ -e "$VID_PATH/$NAME" ]]; then echo "Skipping rename from $NAME to $VID_PATH/$NAME, duplciate found"; continue; fi

   mv "$NAME" "$VID_PATH/$NAME"
done
