FILE=$1

if [[ "" == $FILE ]]; then
  echo "No file provided"
  echo "Usage: ./$0  <inputfile>"
  exit
fi

if [[ ! -f $FILE ]]; then
  echo "Not a file: $FILE"
  exit
fi

~/.bin/HandBrakeCLI -i $FILE -o ./compressed_$FILE -Z "Fast 1080p30" --mixdown mono -Q 2
