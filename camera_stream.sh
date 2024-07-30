#!/bin/bash
# Start the camera stream using RTSP
 raspivid -o - -t 0 -w 1280 -h 720 -fps 30 | ffmpeg -re -f h264 -i - -vcodec copy -an -f rtsp -analyzeduration 1000000 -probesize 1000000 rtsp://localhost:8554/mystream


