#!/usr/bin/env sh

MONETDB_DIR=/var/lib/monetdb
MONETDB_DBFARM_NAME=dbfarm
MONETDB_DB_NAME=db

MONETDB_EMBEDDED_R=${MONETDB_EMBEDDED_R:=true}
MONETDB_EMBEDDED_PYTHON3=${MONETDB_EMBEDDED_PYTHON3:=true}

set -e
if [ ! -d ${MONETDB_DIR}/${MONETDB_DBFARM_NAME} ]; then
  monetdbd create ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}
fi
if [ ! -d ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}/${MONETDB_DB_NAME} ]; then
  monetdbd start ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}
  monetdbd set logfile=/dev/stdout ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}
  monetdbd set listenaddr=all ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}
  monetdb create ${MONETDB_DB_NAME}

  if [ ${MONETDB_EMBEDDED_PYTHON3} = 'true' ]; then
    monetdb set embedpy3=true ${MONETDB_DB_NAME}
  fi

  if [ ${MONETDB_EMBEDDED_R} = 'true' ]; then
    monetdb set embedr=true ${MONETDB_DB_NAME}
  fi

  monetdb release ${MONETDB_DB_NAME}
  monetdbd stop ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}
fi
monetdbd start -n ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}
