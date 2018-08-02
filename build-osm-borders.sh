#!/bin/bash
set -e -u

# OHM planets take hours, so accept a one-day delay
DATE=`date +'%Y-%m-%d' --date='1 day ago'`
URL="http://dump.openhistoricalmap.org/planet/ohm_planet_$DATE.osm.bz2"

STORAGE_DIR="/import"
OSM_FILE="$STORAGE_DIR/ohm_planet.osm.bz2"
OSM_FILTERED_FILE="$STORAGE_DIR/filtered.osm.pbf"
OUTPUT_FILE="$STORAGE_DIR/osmborder_lines.csv"

rm -f $OUTPUT_FILE $OSM_FILTERED_FILE

echo "Downloading `basename $URL` to `basename $OSM_FILE`"
wget -nv $URL -O $OSM_FILE
if [ $? != 0 ]; then
    echo "ERROR: Download failed"
    exit
fi

echo "Extracting borders"
osmborder_filter -o $OSM_FILTERED_FILE $OSM_FILE

echo "Generating CSV $OUTPUT_FILE"
osmborder -o $OUTPUT_FILE $OSM_FILTERED_FILE

echo "Done generating $OUTPUT_FILE"
