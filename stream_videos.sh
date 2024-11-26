#!/bin/bash
#===========================================================
#
#          FILE:  stream_videos.sh

#   DESCRIPTION:  Streams videos to twitch.tv in alphaumeric order from the command line using ffmpeg
#
#  REQUIREMENTS:  ffmpeg, TwitchTV Stream Key
#        AUTHOR:  gothickitty93, ChatGPT
#       VERSION:  24.1126
#       LICENSE:
#===========================================================
# Function to stream the video
stream_video() {
  local file=$1
  ffmpeg -re -i "$file" -vf "scale='if(gte(iw/ih,16/9),1600,-1)':'if(gte(iw/ih,16/9),-1,900)',pad=1600:900:(ow-iw)/2:(oh-ih)/2" -r 60 -c:v h264_videotoolbox -b:v 8000k -maxrate 8000k -bufsize 16000k -g 120 -preset high -c:a copy -f flv rtmp://live.twitch.tv/app/your_stream_key
}

# Get the list of video files in alphanumeric order
videos=($(ls | grep -E "\.(mp4|m4v|mkv)$" | sort -V))

# Find the starting file
start_index=0
if [ "$#" -eq 1 ]; then
  for i in "${!videos[@]}"; do
    if [ "${videos[$i]}" == "$1" ]; then
      start_index=$i
      break
    fi
  done
fi

# Stream each video file starting from the specified one
for ((i = start_index; i < ${#videos[@]}; i++)); do
  stream_video "${videos[$i]}"
done
