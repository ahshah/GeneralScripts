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

for FILE in *;
do
  if [[ ! -f $FILE ]] ; then continue; fi 

  SUFFIX=$(echo $FILE |  awk 'BEGIN { FS="." } {print $NF}'| tr '[:upper:]' '[:lower:]' )
  SUFFIX_CASED=$(echo $FILE |  awk 'BEGIN { FS="." } {print $NF}')
  PREFIX=$(echo $FILE |  sed "s/\.$SUFFIX_CASED//")

  if [[ $SUFFIX != "mp4" ]] && [[ $SUFFIX != "m4v" ]]; then 
    #echo "Skipping $FILE, suffix ($SUFFIX) is not mp4 or m4v"; 
    continue; 
  fi

  ISO=""
  case $FILE in
  MA[FH]*) 
    echo "Here"
    DATE_TIME=$(exiftool $FILE | grep File\ Modification\ Date\/Time | cut -c35-)
    ;;
  C*) 
    echo "Here $FILE"
    xml="$PREFIX"M01.xml
    XML="$PREFIX"M01.XML
    if [[ ! -e $xml && ! -e $XML ]]; then  echo "Skipping $FILE, no associated XML file: $XML"; continue; fi
    DATE_TIME=$(xmllint $XML --xpath "//*[local-name()='NonRealTimeMeta']/*[local-name()='CreationDate']/@value" | awk 'BEGIN { FS="\"" } {print $2}')
    #echo "Got time: $DATE_TIME"
    DATE_TIME=$(echo $DATE_TIME | sed 's/-[0-9][0-9]:.*$/ /g')
    DATE_TIME=$(echo $DATE_TIME | sed 's/-/\:/g')
    DATE_TIME=$(echo $DATE_TIME | sed 's/T/ /g')
    ISO="UNKNOWN_ISO"
    HEX=$(xxd -p -s 401 -l 4 "$FILE" | sed 's/ //g' | awk 'BEGIN {FS =":"}; {print toupper($1)}' ); 
    ISO=$(echo "ibase=16; $HEX"|bc)
    if [[ $ISO == ""  ]]
    then
        ISO="UNKNOWN_ISO"
    fi
    echo "Got time: $DATE_TIME, ISO:$ISO"
    ;;
  *)
    continue
  esac

    if [[ $(echo "$DATE_TIME" | cut -c-2) != "20" ]]; then echo "Skipping $FILE, bad year"; continue; fi
    DATE=$(echo $DATE_TIME | awk '{print $1}' | sed 's/:/\./g' | cut -c3-)
    TIME=$(echo $DATE_TIME | awk '{print $2}' | sed 's/://g' | sed 's/-.*//g') 

    NAME=$(echo $DATE"_"$TIME.mp4)
    if [[ $ISO != "" ]];
    then
        NAME=$(echo $DATE"_"$TIME"_"$ISO.mp4)
    fi

    if [[ -e $NAME ]]; then echo "Skipping rename from $FILE to $NAME, duplciate found"; continue; fi

    echo "Going to move $FILE to $NAME"
    mv "$FILE" "$NAME"
done
