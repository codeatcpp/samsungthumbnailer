# samsungthumbnailer

This is a Shell script which can automatically generate thumbnails for your video library on a NAS server or any other Linux server.

The script creates thumbnails in a format which can be used by the Samsung TVs. It uses the `ffmpegthumbnailer` project for extracting pictures from a video file and then formats a name of the file so it can be used by Samsung TV.

Usage: ./gen_thumbs.sh [file|directory]
