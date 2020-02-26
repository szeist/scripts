#!/bin/bash

LOGDIR="${HOME}/Insync/iSzenasi@emarsys.com/OneDrive Biz/Logbook"

DATE=$(date "+%Y%m%d")
FILENAME="${LOGDIR}/logbook_${DATE}.md"

case $1 in
  "browse")
    ranger --cmd="sort sort_reverse basename" "$LOGDIR"
  ;;

  *)
    if [ ! -e "${FILENAME}" ]; then
      echo "# ${DATE}" >> "${FILENAME}"
      echo "" >> "${FILENAME}";
      echo "" >> "${FILENAME}";
    fi
    
    $EDITOR "+normal G$" +startinsert "${FILENAME}"
  ;;
esac

