##!/usr/local/bin/bash
#!/usr/bin/bash

INPUT_FILE=$1
INPUT_LIST=$2
END_TIME_DEFAULT=00:02:35.0
SKIP_CUTTING=$(echo $3 | tr '[:upper:]' '[:lower:]')
SKIP_WATERMARKING=$(echo $4 | tr '[:upper:]' '[:lower:]')

if [[ $INPUT_FILE == "" || $INPUT_LIST == "" ]];
then
   echo "Usage: $0 <input_file> <cut index> <skip cutting> <skip watermarking>"
   echo ""
   echo "Cut index format: "
   echo "<start time> <team name> <watermark> <length of cut (optional)>"
   exit
fi


i=0
declare -a args_start_time
declare -a args_end_time
declare -a args_file_out
declare -a args_wmark
declare -a args_commented

while IFS='' read -r line || [[ -n "$line" ]] 
do
  start=$(echo $line | awk 'BEGIN {FS=" "}; {print $1}')
  team=$(echo $line | awk 'BEGIN {FS=" "}; {print $2}')
  wmark=$(echo $line | awk 'BEGIN {FS=" "}; {print $3}')
  length=$(echo $line | awk 'BEGIN {FS=" "}; {print $4}')
  
  out=cut_$i
  out+=_$team
  out+=_$INPUT_FILE

  if [[ $start == "" ]]; then 
    echo "Skiping empty start time"
    continue
  fi
  #echo "Set $line to $out vs $INPUT_FILE"
  args_start_time[$i]=$start
  args_end_time[$i]=$length
  args_file_out[$i]=$out
  args_commented[$i]=false
  if [[ $start =~ ^# ]]
  then
    args_commented[$i]=true
  fi
  args_wmark[$i]=$wmark
  ((i++))
done < $INPUT_LIST

for k in "${!args_file_out[@]}"
do
   #echo "Read array val $k"
   OUTPUT_FILE=${args_file_out[$k]}
   START_TIME=${args_start_time[$k]}
   LENGTH=${args_end_time[$k]}

   COMMENTED=${args_commented[$k]}

    if [[ $SKIP_CUTTING == "y" || $COMMENTED == true ]]
    then
        echo "Skip cutting of files.."
        continue
    fi

    if [[ $LENGTH == "" ]];
    then
        LENGTH=$END_TIME_DEFAULT
    else 
        LENGTH=$(echo $START_TIME $LENGTH | ~/.bin/GeneralScripts/duration.py | awk '{print $2}')
    fi

    echo "Cutting file $INPUT_FILE to $OUTPUT_FILE starting at $START_TIME with duration $LENGTH"
    echo "command:  ffmpeg -loglevel warning -ss $START_TIME -i $INPUT_FILE -c copy -t $LENGTH $OUTPUT_FILE"
    ffmpeg -loglevel warning -ss $START_TIME -i $INPUT_FILE -c copy -t $LENGTH $OUTPUT_FILE
done

if [[ $SKIP_WATERMARKING == "y" ]]
then
    exit;
fi

for i in "${!args_file_out[@]}"
do
   INPUT_FILE=${args_file_out[$i]}
   COMMENTED=${args_commented[$i]}
   WMARK_OUTPUT_FILE=wm_$INPUT_FILE
   WATERMARK=${args_wmark[$i]}
   WATERMARK=$(echo "$WATERMARK" | sed 's/_/ /g')
   if [[ $COMMENTED == true ]]
   then
        echo "Skip watermarking of files.."
        continue
   fi
   ~/.bin/GeneralScripts/watermark.sh $INPUT_FILE $WMARK_OUTPUT_FILE "$WATERMARK"
done
