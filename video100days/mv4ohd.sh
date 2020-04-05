#!/bin/sh

# make video for one hundred days

# video name should be sorted 
# pick one second per video
# combine all one-second videos
# need to know width:height of video and add pad
# file's basename will be added in the video as title
# based on ffmpeg

# parameters:
# width
# height
# dpv

function scale() {
    local IN=$1
    local width=$2
    local height=$3

    local size=(${IN//x/ })
    local n_height=${height}
    local n_width=$((${size[0]}*${n_height}/${size[1]}))
    echo "${n_width}x${n_height}"
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
    
    echo "file 'tmp_${title}.mp4'" >> list.txt 
    return 
}

w=960
h=544
dpv=1 # fetch duration from per video

> list.txt
filename="/Users/xbin999/Downloads/jump/2020-03-02.mp4"
fetchVideo $filename $w $h $dpv 
#echo "file 'tmp_${filename##*/}'" >> list.txt 
filename="/Users/xbin999/Downloads/jump/2020-03-12.mp4"
fetchVideo $filename $w $h $dpv 
#echo "file 'tmp_${filename##*/}'" >> list.txt 

ffmpeg -y -safe 0 -f concat -i list.txt -c copy output.mp4

exit

# the following are ffmpeg examples
ffmpeg -y -i ~/Downloads/jump/2020-03-01.mp4 -ss 00:00:02 -t 1 -vf 'scale=405:720,pad=1280:720:400:93:black' output1.mp4 
ffmpeg -i ~/Downloads/jump/2020-03-12.mp4 -ss 00:00:02 -t 1 -vf "drawtext=text='2020-03-01':x=700:y=200:fontsize=24:fontcolor=red" output2.mp4 

ffmpeg -y -i ~/Downloads/jump/2020-03-01.mp4 -ss 00:00:02 -t 1 -vf "drawtext=text='2020-03-01':x=700:y=200:fontsize=24:fontcolor=red" output1.mp4 
ffmpeg -y -i ~/Downloads/jump/2020-03-12.mp4 -ss 00:00:02 -t 1 -vf "drawtext=text='2020-03-01':x=700:y=200:fontsize=24:fontcolor=red" output2.mp4 

ffmpeg -safe 0 -f concat -i list.txt -c copy output.mp4

ffmpeg -y -i mavel4.mp4 -vf "drawtext=text='Avengers\: Endgame':x=700:y=200:fontsize=24:fontcolor=red" mavel4_drawtext.mp4

-vf drawtext=fontcolor=white:fontsize=40:fontfile=msyh.ttf:text='Hello World':x=0:y=100

ffprobe -v error -show_entries stream=width,height -of csv=p=0:s=x ~/Downloads/jump/2020-03-01.mp4 
ffprobe -v error -show_entries stream=width,height -of csv=p=0:s=x ~/Downloads/jump/2020-03-12.mp4 | awk '{split($0,a,"x");print a[1],a[2]}'

ffmpeg -i myfile1.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts temp1.ts
ffmpeg -i myfile2.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts temp2.ts
// now join
ffmpeg -i "concat:temp1.ts|temp2.ts" -c copy -bsf:a aac_adtstoasc output.mp4