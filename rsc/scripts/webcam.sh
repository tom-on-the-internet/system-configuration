#!/usr/bin/env bash

set -ofeux pipefail

WEBCAM="C922 Pro Stream"
DEVICE=$(v4l2-ctl --list-devices | grep -A1 "$WEBCAM" | grep -v "$WEBCAM" | xargs)

MIN_ZOOM=100
MAX_ZOOM=180
ZOOM_STEP=5

show_web_cam() {
  mpv --demuxer-lavf-format=video4linux2 --demuxer-lavf-o-set=input_format=mjpeg av://v4l2:"$DEVICE" --profile=low-latency --untimed --vf=hflip --no-keepaspect-window
}

zoom_in() {
  current_zoom=$(v4l2-ctl --device "$DEVICE" --get-ctrl zoom_absolute | grep -oP "zoom_absolute: \K...")

  new_zoom=$((current_zoom + ZOOM_STEP))

  if ((new_zoom > MAX_ZOOM)); then
    new_zoom=$MAX_ZOOM
  fi

  v4l2-ctl --device "$DEVICE" --set-ctrl zoom_absolute="$new_zoom"

  exit
}

zoom_out() {
  current_zoom=$(v4l2-ctl --device "$DEVICE" --get-ctrl zoom_absolute | grep -oP "zoom_absolute: \K...")

  new_zoom=$((current_zoom - ZOOM_STEP))

  if ((new_zoom < MIN_ZOOM)); then
    new_zoom=$MIN_ZOOM
  fi

  v4l2-ctl --device "$DEVICE" --set-ctrl zoom_absolute="$new_zoom"

  exit
}

if [ "$1" = "show" ]; then
  show_web_cam
  exit
fi

if [ "$1" = "zoom_in" ]; then
  zoom_in
  exit
fi

if [ "$1" = "zoom_out" ]; then
  zoom_out
  exit
fi

echo Sorry, but I don\'t know what "$1" means...
