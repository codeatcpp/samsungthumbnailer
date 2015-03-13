# samsungthumbnailer

This is a Shell script which can automatically generate thumbnails for your video library on a NAS server or any other Linux server.

The script creates thumbnails in a format which can be used by the Samsung TVs. It uses the `ffmpegthumbnailer` project for extracting pictures from a video file and then formats a name of the file so it can be used by Samsung TV.

The reason for creation of this project is that Samsung TVs are use poor algorithm for generating thumbnails for an USB attached devices as well as for a mounted Samba shares (which are could be mounted using SamyGo project). 

Usage: 
    ./gen_thumbs.sh [file|directory]

You could start the script from command line to process one file as follows:
    ./gen_thumbs.sh /media/Video/test.avi

To process the directory recursively:
    ./gen_thumbs.sh /media/Video
