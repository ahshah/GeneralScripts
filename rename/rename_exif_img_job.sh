#!/bin/bash

# Rename by create date
RUN_PATH="$1"
if [[ $RUN_PATH == "" ]]; then
  echo "No path provided, exiting"
  exit -1
fi

echo "Running in: $RUN_PATH"
if [[ ! -d $RUN_PATH  ]]; then
  echo "Path provided ($RUN_PATH) is not a directory, exiting"
  exit -1
fi

cd "$RUN_PATH"
if [[ $? -ne 0 ]]; then
  echo "Unable to cd into path provided ($RUN_PATH)."
  exit -1
fi

for FILE in IMG*;
do
   SUFFIX=$(echo $FILE | cut -d . -f 2 | tr '[:upper:]' '[:lower:]' )

   if [[ $SUFFIX != "mov" ]]; then echo "Skipping $FILE, suffix ($SUFFIX) is not mov"; continue; fi
   DATE_TIME=$(exiftool $FILE | grep Creation\ Date | cut -c35-)

   if [[ $(echo "$DATE_TIME" | cut -c-2) != "20" ]]; then echo "Skipping $NAME"; continue; fi
   DATE=$(echo $DATE_TIME | awk '{print $1}' | sed 's/:/\./g' | cut -c3-)
   TIME=$(echo $DATE_TIME | awk '{print $2}' | sed 's/://g' | sed 's/-.*//g')

   NAME=$(echo $DATE"_"$TIME.mp4)
   if [[ -e $NAME ]]; then echo "Skipping rename from $FILE to $NAME, duplciate found"; continue; fi
   
   echo "Going to move $FILE to $NAME"
   mv "$FILE" "$NAME"
done
