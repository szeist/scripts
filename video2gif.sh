#!/bin/bash

# https://engineering.giphy.com/how-to-make-gifs-with-ffmpeg

if [ $# -gt 2 ] || [ ${1} == "-h" ]; then
  echo "Converts video file to gif"
  echo "Usage:"
  echo "\t${0} [-h] [VIDEO_FILE] [OPTIONAL: OUTPUT GIF]"
  echo "\t\t-h\tPrints this help."
  exit 0;
fi

VIDEO_FILE="${1}"
GIF_FILE="${2}"

if [ ! -r "${VIDEO_FILE}" ]; then
  echo "Cannot read ${VIDEO_FILE}"
  exit 1;
fi

if [ $# -eq 1 ]; then
  GIF_FILE="${VIDEO_FILE%.*}.gif";
fi

ffmpeg -i "${VIDEO_FILE}" -filter_complex "[0:v] fps=10,scale=480:-1,split [a][b];[a] palettegen [p];[b][p] paletteuse" "${GIF_FILE}"
