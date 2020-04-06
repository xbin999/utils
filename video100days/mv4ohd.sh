#!/bin/sh

# @xbin999 (xbin999@gmail.com)
# Pick random second from videos and concat. It can be used for 100 days exercises.
# based on ffmpeg

helpFunction()
{
   echo "-----------------------------------"
   echo "Usage: $0 [-w video_width] [-h video_height] [-d dpv] -s source -t target"
   echo "\t-w The width of video"
   echo "\t-h The height of video"
   echo "\t-d Duration fetched from per video"
   echo "\t-s Source video files(with comma), like \"/Users/xbin999/Downloads/jump/*.mp4\""
   echo "\t-m Target video filename"
   exit 1 # Exit script after printing help
}

while getopts w:h:d:s:t: opt
do
   case "$opt" in
      w) video_width="$OPTARG" ;;
      h) video_height="$OPTARG" ;;
      d) dpv="$OPTARG" ;;
      s) source="$OPTARG" ;;
      t) target="$OPTARG" ;;
      *) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if [ -z "$video_width" ] || [ -z "$video_height" ] 
then
   video_width=960
   video_height=544
fi

if [ -z "$dpv" ] 
then
   dpv=1
fi

# Print helpFunction in case parameters are empty
if [ -z "$source" ] || [ -z "$target" ]
then
   echo "Parameters 'source/output' are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
#echo "$video_width"
#echo "$video_height"
#echo "$dpv"
#echo "$source"
#echo "$target"

function scale() {
    local IN=$1
    local canvas_width=$2
    local canvas_height=$3
    local video_size=(${IN//x/ })
    local canvas_width_video_height=$((${canvas_width}*${video_size[1]}))
    local canvas_height_video_width=$((${canvas_height}*${video_size[0]}))
    local resized_height
    local resized_width

    # sh doesn't support float division, change comparision from aspect ration to multiply 
    if [ $canvas_width_video_height -gt $canvas_height_video_width ]
    then
        resized_height=${canvas_height}
        resized_width=$((${video_size[0]}*${resized_height}/${video_size[1]}))
    else
        resized_width=${canvas_width}
        resized_height=$((${video_size[1]}*${resized_width}/${video_size[0]}))
    fi    
    echo "${resized_width}x${resized_height}"
}

function fetchVideo() {
    local filename=$1
    local width=$2
    local height=$3
    local dpv=$4
    local title=`basename ${filename}| cut -d . -f1`
    local ext=`basename ${filename}| cut -d . -f2`

    echo "deal with $# 个参数：${filename} ${width} ${height} ${dpv} ..."
    local IN=`ffprobe -v error -show_entries stream=width,height -of csv=p=0:s=x ${filename}`
    local size=(${IN//x/ })
    echo "WIDTH=${size[0]} HEIGHT=${size[1]}"

    local _DURATION=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 ${filename}`
    local duration="${_DURATION%.*}"
    echo "DURATION=${duration}"

    local start=`jot -r 1 1 ${duration-1}`
    echo "START=${start}"

    local OUT=$(scale $IN $width $height)
    local n_size=(${OUT//x/ })
    local x=$(((${width}-${n_size[0]})/2))
    local y=$(((${height}-${n_size[1]})/2))
    echo "WIDTH=${n_size[0]} HEIGHT=${n_size[1]} x=${x} y=${y}"

    `ffmpeg -y -i ${filename}  \
        -ss ${start} -t ${dpv} \
        -vf "scale=${n_size[0]}:${n_size[1]},        \
        pad=${width}:${height}:${x}:${y}:black,      \
        drawtext=text=${title}:x=10:y=10:fontsize=24:fontcolor=white:shadowy=2" \
       tmp_${title}.mp4`
    
    `ffmpeg -y -i tmp_${title}.mp4 -vcodec copy -acodec copy -vbsf h264_mp4toannexb tmp_${title}.ts`

    echo "file 'tmp_${title}.ts'" >> list.txt 
    return 
}

> list.txt
for filename in `ls -v ${source}`; do 
    fetchVideo $filename $video_width $video_height $dpv 
    echo $filename
done;

# concat all videos
ffmpeg -y -safe 0 -f concat -i list.txt -c copy ${target}

# remove tmp files
rm tmp*.mp4 tmp*.ts 
exit 0

# run examples: 
# ./mv4ohd.sh -s "/Users/xbin999/Downloads/jump/*.mp4" -t output.mp4
# ./mv4ohd.sh -w 1024 -h 768 -d 1 -s "/Users/xbin999/Downloads/jump/*.mp4" -t output.mp4