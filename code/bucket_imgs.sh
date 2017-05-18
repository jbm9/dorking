#!/bin/bash

filename=$1
cr2name=$(echo ${filename} | sed -e 's/JPG/CR2/')

if [ ! -f ${cr2name} ]; then
  echo "# No raw for ${filename}, skipping"
  exit
fi

exif_field () {
  exiftool ${filename} | grep '^'"$1"' *:' | sed -e 's/^.*://' | awk ' { print $1 } ' | head -1
}

exp=$(exif_field "Exposure Time" | sed -e 's,/,div,;')
aperture=$(exif_field "Aperture Value")
iso=$(exif_field "ISO")
focal_length=$(exif_field "Focal Length")

bucket="buckets/${exp}_${aperture}_${iso}_${focal_length}/"
echo mkdir -p ${bucket}

echo ln -s ../../${cr2name} ${bucket}

echo "# $1 ${exp} ${aperture} ${iso} ${focal_length}"
