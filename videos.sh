#!/bin/bash

# Configuration
IMAGE_FOLDER="images"  # Folder containing image files
AUDIO_FOLDER="audio_tracks"  # Folder containing audio files
OUTPUT_FOLDER="output_videos"  # Folder to save the final videos

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_FOLDER"

# Get lists of image and audio files
IMAGES=("$IMAGE_FOLDER"/*.jpg)  # Assumes images are in JPG format
AUDIO_FILES=("$AUDIO_FOLDER"/*.mp3)  # Assumes audio files are in MP3 format

# Check if the number of images and audio files match
if [ ${#IMAGES[@]} -ne ${#AUDIO_FILES[@]} ]; then
  echo "Error: The number of images and audio files does not match."
  exit 1
fi

# Loop through images and audio files
for ((i=0; i<${#IMAGES[@]}; i++)); do
  IMAGE="${IMAGES[$i]}"
  AUDIO_FILE="${AUDIO_FILES[$i]}"

  # Get the base name of the audio file (without extension)
  BASENAME=$(basename "$AUDIO_FILE" .mp3)

  # Output video path
  OUTPUT="$OUTPUT_FOLDER/$BASENAME.mp4"

  # Use FFmpeg to create the video
  ffmpeg -loop 1 -i "$IMAGE" -i "$AUDIO_FILE" -c:v libx264 -tune stillimage -c:a aac -b:a 192k -shortest "$OUTPUT"

  echo "Created video: $OUTPUT"
done

echo "All videos have been created in the '$OUTPUT_FOLDER' folder."
