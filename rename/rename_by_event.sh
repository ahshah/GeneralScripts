#!/bin/bash
RUN_PATH="$1"
EVENT="$2"
if [[ $RUN_PATH == "" ]]; then
  echo "No path provided, exiting"
  echo "Usage: ./$0  <path> <event>"
  exit -1
fi

if [[ $EVENT == "" ]]; then
  echo "No event name provided, exiting"
  echo "Usage: ./$0  <path> <event>"
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
    DEVICE=$(xmllint $XML --xpath "//*[local-name()='NonRealTimeMeta']/*[local-name()='Device']/@modelName" | awk 'BEGIN { FS="\"" } {print $2}')
    #echo "Got time: $DATE_TIME"
    DATE_TIME=$(echo $DATE_TIME | sed 's/-[0-9][0-9]:.*$/ /g')
    DATE_TIME=$(echo $DATE_TIME | sed 's/-/\:/g')
    DATE_TIME=$(echo $DATE_TIME | sed 's/T/ /g')
    echo "Got time: $DATE_TIME"
    ;;
  *)
    continue
  esac

    if [[ $DEVICE == "" ]]; then
        DEVICE="UNKNOWN"
    fi

    case $DEVICE in
       ILCE-7RM2)
            DEVICE_NAME=A7R2
        ;;
    FDR-X3000)
            DEVICE_NAME=FDR
        ;;
    *)
            DEVICE_NAME=$DEVICE
    esac

    if [[ $(echo "$DATE_TIME" | cut -c-2) != "20" ]]; then echo "Skipping $FILE, bad year"; continue; fi
    DATE=$(echo $DATE_TIME | awk '{print $1}' | sed 's/:/\./g' | cut -c3-)
    TIME=$(echo $DATE_TIME | awk '{print $2}' | sed 's/://g' | sed 's/-.*//g') 

    NAME=$(echo $DATE"."$EVENT"."$DEVICE_NAME".master."$TIME".mp4")
    if [[ -e $NAME ]]; then echo "Skipping rename from $FILE to $NAME, duplciate found"; continue; fi
  
  echo "Going to move $FILE to $NAME"
  #mv "$FILE" "$NAME"
  echo "FAILED, ensure duplicate detection on line 83 is functional with out quotes for files with spaces"
  echo "FAILED, ensure duplicate detection on line 83 is functional with out quotes for files with spaces"
  echo "FAILED, ensure duplicate detection on line 83 is functional with out quotes for files with spaces"
  echo "FAILED, ensure duplicate detection on line 83 is functional with out quotes for files with spaces"
  echo "FAILED, ensure duplicate detection on line 83 is functional with out quotes for files with spaces"
  echo "FAILED, ensure duplicate detection on line 83 is functional with out quotes for files with spaces"
  echo "FAILED, ensure duplicate detection on line 83 is functional with out quotes for files with spaces"
done
