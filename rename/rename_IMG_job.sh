#!/bin/bash
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

for FILE in IMG_*;
do
  if [[ ! -f $FILE ]] ; then echo "Skipping rename, $FILE is not a file"; continue; fi 

   NAME=$(echo "$FILE" | cut -c5-)
   if [[ $(echo "$NAME" | cut -c-2) != "20" ]]; then echo "Skipping $NAME"; continue; fi
   
   NAME=$(echo "$NAME" | cut -c3-) 
   NAME=$(echo "$NAME" | sed 's/\([0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\)\(.*\)/\1\.\2\.\3\4'/)

  if [[ -e $NAME ]]; then echo "Skipping rename from $FILE to $NAME, duplciate found"; continue; fi
   echo "Going to move $FILE to $NAME"

   mv "$FILE" "$NAME"
done
