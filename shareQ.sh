#!/bin/bash

set_square_h_size() {
  nw="$((w * 2 / 3))"
  image_w="$((w))"
  image_h="$((h))"
  text_w="$((w + nw))"
  text_h="$((h / 4))"
  date_w="$((nw))"
  date_h="$((h / 2))"
  qcode_w="$((nw))"
  qcode_h="$((h / 2))"
}

set_square_v_size() {
  image_w="$((w))"
  image_h="$((h))"
  text_w="$((w))"
  text_h="$((h * 2 / 3))"
  date_w="$((w / 2))"
  date_h="$((h / 3))"
  qcode_w="$((w / 2))"
  qcode_h="$((h / 3))"
}

set_rectangle_h_size() {
  nw="$((w * 3 / 4))"
  image_w="$((w))"
  image_h="$((h))"
  text_w="$((nw))"
  text_h="$((h - h / 4 - h / 4))"
  date_w="$((nw))"
  date_h="$((h / 4))"
  qcode_w="$((nw))"
  qcode_h="$((h / 4))"
}

set_rectangle_v_size() {
  image_w="$((w))"
  image_h="$((h))"
  text_w="$((w))"
  text_h="$((h * 1 / 4))"
  date_w="$((w / 2))"
  date_h="$((h * 1 / 4))"
  qcode_w="$((w / 2))"
  qcode_h="$((h * 1 / 4))"
}

joint_images_square_h() {
  convert -append _xtmp_canvas_date.png _xtmp_canvas_qcode.png _xtmp_canvas_date_qcode.png
  convert +append _xtmp_canvas_image.png _xtmp_canvas_date_qcode.png _xtmp_canvas_image_date_qcode.png
  convert -append _xtmp_canvas_image_date_qcode.png _xtmp_canvas_text.png _xtmp_canvas_result.png  
}

joint_images_square_v() {
  convert +append _xtmp_canvas_date.png _xtmp_canvas_qcode.png _xtmp_canvas_date_qcode.png
  convert -append _xtmp_canvas_image.png _xtmp_canvas_text.png _xtmp_canvas_date_qcode.png _xtmp_canvas_result.png
}

joint_images_rectangle_h() {
  convert -append _xtmp_canvas_date.png _xtmp_canvas_text.png _xtmp_canvas_qcode.png _xtmp_canvas_date_text_qcode.png
  convert +append _xtmp_canvas_image.png _xtmp_canvas_date_text_qcode.png _xtmp_canvas_result.png
}

joint_images_rectangle_v() {
  convert +append _xtmp_canvas_date.png _xtmp_canvas_qcode.png _xtmp_canvas_date_qcode.png
  convert -append _xtmp_canvas_image.png _xtmp_canvas_text.png _xtmp_canvas_date_qcode.png _xtmp_canvas_result.png
}

joint_images() {
  case $OPTION in
    SQUARE_H)
    joint_images_square_h
    ;;
    SQUARE_V)
    joint_images_square_v
    ;;
    RECTANGLE_H)
    joint_images_rectangle_h
    ;;
    RECTANGLE_V)
    joint_images_rectangle_v
    ;;
    *)
    # unknown option
    joint_images_square_h
    ;;
  esac  
}

add_border_box() {
  rv=`magick identify -format "%[fx:w]x%[fx:h]" _xtmp_canvas_result.png`
  ww=`echo $rv | cut -d'x' -f1`
  hh=`echo $rv | cut -d'x' -f2`
  posx=20
  posy=20

  box_w="$((ww + posx * 2))"
  box_h="$((hh + posy * 2))"
  BACKGROUND_COLOR="#FBFBFB"

  echo "${ww}x${hh} => ${box_w}x${box_h}"
  convert -size "${box_w}x${box_h}" xc:"${BACKGROUND_COLOR}" \
    -compose over _xtmp_canvas_result.png -gravity center \
    -geometry "+0+0" \
    -composite _xtmp_canvas_result.png  
}

draw_demo_image() {
  convert -size "${text_w}x${text_h}"   xc:blue   _xtmp_canvas_text.png
  convert -size "${date_w}x${date_h}"   xc:yellow _xtmp_canvas_date.png
  convert -size "${qcode_w}x${qcode_h}" xc:green  _xtmp_canvas_qcode.png
  joint_images
}

draw_text_image() {
  TEXT_FONT="/System/Library/Fonts/Hiragino Sans GB W3.ttc"
  TEXT_SIZE=48
  TEXT_COLOR="#5E5E5E"
  TEXT_GRAVITY="NorthWest"

  tw="$((text_w * 8 / 10))"
  th="$((text_h * 8 / 10))"
  posx="$((text_w * 1 / 10))"
  posy="$((text_h * 1 / 10))"

  convert -size "${text_w}x${text_h}" xc:none \
    -background transparent -fill "${TEXT_COLOR}" \
    -font "${TEXT_FONT}" -pointsize "${TEXT_SIZE}" \
    -size "${tw}x" -gravity "${TEXT_GRAVITY}" \
    -encoding utf8 caption:"${TEXT}" \
    -geometry "+${posx}+${posy}" \
    -composite _xtmp_canvas_text.png
}

draw_date_image() {
  TEXT_FONT="/System/Library/Fonts/Hiragino Sans GB W3.ttc"
  TEXT_SIZE=48
  TEXT_COLOR="#5E5E5E"
  TEXT_GRAVITY="North"

  WEEKDAYS=(星期日 星期一 星期二 星期三 星期四 星期五 星期六) 
  TEXT_DATE=`date +'%m月%d日'`
  WEEK_DAY=`date +'%w'`
  TEXT_YEAR=`date +'%Y年'`

  posy1="$((date_h * 2 / 10))"
  posy2="$((date_h * 5 / 10))"

  convert -size "${date_w}x${date_h}" xc:none \
    -fill "${TEXT_COLOR}" \
    -font "${TEXT_FONT}" \
    -gravity "${TEXT_GRAVITY}" \
    -pointsize 64 -draw "text 0,${posy1} '${TEXT_DATE}'" \
    -pointsize 32 -draw "text 0,${posy2} '${WEEKDAYS[$WEEK_DAY]} ${TEXT_YEAR}'" \
    _xtmp_canvas_date.png
}

draw_qcode_image() {
  TEXT_FONT="/System/Library/Fonts/Hiragino Sans GB W3.ttc"
  TEXT_SIZE=32
  TEXT_COLOR="#5E5E5E"
  TEXT_GRAVITY="West"

  if [ "${qcode_w}" -lt "${qcode_h}" ]; then
    qcode_size="${qcode_w}"
  else
    qcode_size="${qcode_h}"
  fi

  qcode_x="$((qcode_size * 8 / 10))"
  qcode_y="$((qcode_size * 8 / 10))"
  posx="$((qcode_w * 1 / 10))"
  echo "${qcode_w}x${qcode_h} - ${qcode_x}x${qcode_y}+0+0"

  convert -size "${qcode_w}x${qcode_h}" xc:none \
    -fill "${TEXT_COLOR}" -font "${TEXT_FONT}" \
    -gravity "${TEXT_GRAVITY}" \
    -pointsize 32 -draw "text ${posx},0 '半 玩 伴 学'" \
    -compose over qrcode.jpg -gravity East \
    -geometry "${qcode_x}x${qcode_y}+${posx}+0" \
    -composite _xtmp_canvas_qcode.png
}

#echo $# arguments, $*

MAIN=""
TEXT="皮皮，你说山越高是越冷还是越热？"
WIDTH=800
OPTION="SQUARE_H"
DEMO="N"

DEBUG="N"

while [[ $# -gt 1 ]]
do
  key="$1"

  case $key in
    -m|--main)
    MAIN="$2"
    shift # past argument
    ;;
    -t|--text)
    TEXT="$2"
    shift # past argument
    ;;
    -o|--option)
    OPTION="$2"
    shift # past argument
    ;;
    -d|--demo)
    DEMO="$2"
    shift # past argument
    ;;
    *)
    # unknown option
    break
    ;;
  esac
  shift # past argument or value
done

if [ "$DEBUG" == "Y" ]; then
  echo MAIN   = "${MAIN}"
  echo TEXT   = "${TEXT}"
  echo OPTION = "${OPTION}"
  echo DEMO   = "${DEMO}"
fi

if [ "$MAIN" == "" ]; then
  echo "Usage: $0 [options ...]"
  echo "  -m|--main   : main image filename"
  echo "  -t|--text   : text message"
  echo "  -o|--option : layout option, [SQUARE_H, SQUARE_V, RECTANGLE_H, RECTANGLE_V], default is SQUARE_H"
  echo "  -d|--demo   : draw a layout demo, [Y/N], default is N"
  exit
fi

echo "Resize image ..."
convert $MAIN -resize $WIDTH _xtmp_canvas_image.png 

rv=`magick identify -format "%[fx:w]x%[fx:h]" _xtmp_canvas_image.png`
w=`echo $rv | cut -d'x' -f1`
h=`echo $rv | cut -d'x' -f2`
echo "Get image size($w x $h) ..."

image_w=0
image_h=0
text_w=0
text_h=0
date_w=0
date_h=0
qcode_w=0
qcode_h=0

case $OPTION in
  SQUARE_H)
  set_square_h_size
  ;;
  SQUARE_V)
  set_square_v_size
  ;;
  RECTANGLE_H)
  set_rectangle_h_size
  ;;
  RECTANGLE_V)
  set_rectangle_v_size
  ;;
  *)
  # unknown option
  set_square_h_size
  ;;
esac

if [ "$DEMO" == "Y" ]; then
  echo "Draw frame demo ..."
  draw_demo_image
  mv _xtmp_canvas_result.png "demo_${MAIN}.png"
  rm _xtmp_*.png

  exit
fi

echo "Write text on image ..."
draw_text_image
echo "Write date on image ..."
draw_date_image
echo "Write qcode on image ..."
draw_qcode_image
echo "joint all images ..."
joint_images
add_border_box

if [ -f _xtmp_canvas_result.png ]; then 
  mv _xtmp_canvas_result.png "result_${MAIN}.png"
fi
if [ "$DEBUG" != "Y" ]; then
  rm _xtmp_*.png
fi

exit