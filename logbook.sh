#!/bin/bash

LOGDIR="${HOME}/Documents/Logbook"

DATE=$(date "+%Y%m%d")
FILENAME="${LOGDIR}/logbook_${DATE}.md"

if [ ! -e "${FILENAME}" ]; then
  echo $DATE > $FILENAME
  echo "========" >> $FILENAME
  echo "" >> $FILENAME;
  echo "" >> $FILENAME;
fi

$EDITOR "+normal G$" +startinsert "${FILENAME}"

