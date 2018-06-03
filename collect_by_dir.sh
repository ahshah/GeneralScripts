#!/bin/bash
for file in *.mp4; 
do 
    uniqdate=$(echo $file | awk 'BEGIN {FS="_"}; {print $1};'); 
    echo $uniqdate; 
done | sort | uniq | while read line
do 
    mkdir $line; 
    mv $line*.mp4 $line; 
done
