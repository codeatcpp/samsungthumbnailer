#!/bin/sh
# gen_thumbs.sh - generates thumbnails for Samsung TVs

# define "constants"
S_OK=0
S_SKIPPED=1
E_FAIL=2

# function for creating thumbnail for one file
create_file_thumb ()
{
  FILENAME=$1
  # get file size in bytes
  printf "$FILENAME\t"
  FILESIZE=$( stat -c%s "$FILENAME" 2>/dev/null )
  if [ $? -ne 0 ] ; then
	  echo "[FAIL]" # no file or access denied
	  return $E_FAIL
  fi

  # generate file extension, so Samsung TV could use thumbnail
  if [ $FILESIZE -lt 4294967296 ] ; then
	  EXT=$(( $FILESIZE / 1000 ))
  else
	  EXT=$(( ($FILESIZE - 4294967296) / 1000 ))
  fi

  NEWFN="${FILENAME%.*}.$EXT"
  if [ -f "$NEWFN" ] ; then
	  echo "[SKIP]" # already exist
	  return $S_SKIPPED
  else
	  ffmpegthumbnailer -s320 -cjpeg -i"$FILENAME" -o"$NEWFN" 2>/dev/null
	  result=$? # save result of ffmpegthumbnailer
	  # additionally check result file
	  if [ $(stat -c%s "$NEWFN" 2>/dev/null) -gt 0 ] ; then
	    if [ $result -eq 0 ] ; then
		    echo "[OK]"
		    return $S_OK
	    else
		    echo "[FAIL]"
		    return $E_FAIL
	    fi
    else
      rm "$NEWFN" # delete invalid file
      echo "[FAIL]"
      return $E_FAIL
    fi
  fi
}

if [ -f "$1" ]; then # process one file
  create_file_thumb "$1"
elif [ -d "$1" ] ; then # process directory
  FAILED=0
  OK=0
  SKIPPED=0
  count=0

  IFS='
'

  # process each file
  for NAME in $(find $1/ -type f -regex ".*\.\(avi\|mkv\|ts\)$")
  do
    create_file_thumb "$NAME"
    ecode=$? # keep exit code here because every command will change $?
    if [ "${ecode}" -eq $E_FAIL ] ; then FAILED=$(( $FAILED + 1 )); fi
    if [ "${ecode}" -eq $S_OK ] ; then OK=$(( $OK + 1 )); fi
    if [ "${ecode}" -eq $S_SKIPPED ] ; then SKIPPED=$(( $SKIPPED + 1)); fi
    count=$(( $count + 1 ))
  done

  # display results
  echo "Total files processed: $count"
  echo "Skipped: $SKIPPED"
  echo "Failed: $FAILED"
  echo "Images generated: $OK"
  
else # no or invalid arguments, so print usage info
  echo "Generates thumbnails for TV"
  echo "Usage: ./gen_thumbs.sh [file|directory]"
fi

