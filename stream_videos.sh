#!/bin/bash
#===========================================================
#
#          FILE:  stream_videos.sh
#
#   DESCRIPTION:  Streams videos to twitch.tv in alphanumeric order from the current directory using ffmpeg.
#
#  REQUIREMENTS:  ffmpeg, TwitchTV Stream Key, and video files in the current directory.
#        AUTHOR:  gothickitty93, ChatGPT
#       VERSION:  24.1126a
#       LICENSE:  Creative Commons Attribution-ShareAlike 4.0 International
#
#   USAGE:
#     1. Make this script executable: chmod +x stream_videos.sh
#     2. Run the script: ./stream_videos.sh [optional_start_file]
#     3. Replace `your_stream_key` with your Twitch stream key in the ffmpeg command.
#
#===========================================================

# Function to stream the video
# Arguments:
#   $1 - The file name of the video to stream.
stream_video() {
  local file=$1
  
  # Adjust the video scaling and pad to maintain a 16:9 aspect ratio
  # ffmpeg command streams video to Twitch with defined quality settings
  ffmpeg -re -i "$file" \
    -vf "scale='if(gte(iw/ih,16/9),1600,-1)':'if(gte(iw/ih,16/9),-1,900)',pad=1600:900:(ow-iw)/2:(oh-ih)/2" -r 60 -c:v h264_videotoolbox -b:v 8000k -maxrate 8000k -bufsize 16000k \-g 120 -preset high -c:a copy -f flv rtmp://live.twitch.tv/app/your_stream_key
}

# Collect the list of video files in the current directory
# Supports mp4, m4v, mkv formats and sorts them alphanumerically.
videos=($(ls | grep -E "\.(mp4|m4v|mkv)$" | sort -V))

# Determine the starting file index if specified in the script arguments
# Arguments:
#   $1 (optional) - Start from this file in the list.
start_index=0
if [ "$#" -eq 1 ]; then
  for i in "${!videos[@]}"; do
    if [ "${videos[$i]}" == "$1" ]; then
      start_index=$i
      break
    fi
  done
fi

# Loop through and stream each video file starting from the specified index
# Ensure the `your_stream_key` placeholder in `ffmpeg` is replaced before running.
for ((i = start_index; i < ${#videos[@]}; i++)); do
  stream_video "${videos[$i]}"
done
