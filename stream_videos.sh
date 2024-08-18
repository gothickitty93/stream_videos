#!/bin/bash
#===========================================================
#
#          FILE:  stream_videos.sh

#   DESCRIPTION:  Streams videos to twitch.tv in alphaumeric order from the command line using ffmpeg
#
#  REQUIREMENTS:  ffmpeg, TwitchTV Stream Key
#        AUTHOR:  gothickitty93, ChatGPT
#       VERSION:  1.0.1
#       LICENSE:  This work is licensed under Creative Commons Attribution-ShareAlike 4.0 International
#===========================================================
# Function to stream the video
stream_video() {
  local file=$1
  ffmpeg -re -i "$file" -vf "scale=1280:-1" -r 60 -c:v h264_videotoolbox -preset fastest -b:v 1500k -maxrate 3000k -bufsize 6000k -g 120 -c:a copy -f flv rtmp://live.twitch.tv/app/live_stream_key
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
