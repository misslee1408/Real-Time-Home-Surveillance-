#!/bin/bash
raspivid -o - -t 0 -w 1280 -h 720 -fps 30 | ffmpeg -re -f h264 -i - -vcodec copy -an -f rtsp rtsp://localhost:8554/mystream

 

