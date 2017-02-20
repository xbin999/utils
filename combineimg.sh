#!/bin/bash

#echo $# arguments, $*

MAIN=""
WIDTH="800"
POSY="410"
HEIGHT="40"
while [[ $# -gt 1 ]]
do
  key="$1"

  case $key in
    -m|--main)
    MAIN="$2"
    shift # past argument
    ;;
    -w|--width)
    WIDTH="$2"
    shift # past argument
    ;;
    -y|--posy)
    POSY="$2"
    shift # past argument
    ;;
    -h|--sub_height)
    SUB_HEIGHT="$2"
    shift # past argument
    ;;
    *)
    # unknown option
    break
    ;;
  esac
  shift # past argument or value
done

echo MAIN = "${MAIN}"
echo WIDTH = "${WIDTH}"
echo POSY = "${POSY}"
echo SUB_HEIGHT = "${SUB_HEIGHT}"

if [ "$MAIN" == "" ]; then
  echo "Usage: $0 [options ...] file1 file2..."
  echo "  -m|--main : main image filename"
  echo "  -w|--width : resized width"
  echo "  -y|--posy : crop postion y"
  echo "  -h|--sub_height : crop height"
  exit
fi

convert $MAIN -resize $WIDTH "_xtmp_${MAIN}.jpg"

while [[ $# -gt 0 ]]
do
  CROPFILE="$1"
  echo "convert $CROPFILE -resize $WIDTH _xtmp_${CROPFILE}.jpg..."
  convert $CROPFILE -resize $WIDTH "_xtmp_${CROPFILE}.jpg"
  echo "convert _xtmp_${CROPFILE}.jpg -crop ${WIDTH}x${SUB_HEIGHT}+0+${POSY} _xtmp_crop_${CROPFILE}.jpg ..."
  convert "_xtmp_${CROPFILE}.jpg" -crop ${WIDTH}x${SUB_HEIGHT}+0+${POSY} "_xtmp_crop_${CROPFILE}.jpg"
  echo "convert _xtmp_${MAIN}.jpg _xtmp_crop_${CROPFILE}.jpg -append _xtmp_${MAIN}.jpg ..."
  convert "_xtmp_${MAIN}.jpg" "_xtmp_crop_${CROPFILE}.jpg" -append "_xtmp_${MAIN}.jpg"
  shift
done

mv "_xtmp_${MAIN}.jpg" "xbin_${MAIN}.jpg" 
rm _xtmp_*.jpg
echo "Combine image finished."