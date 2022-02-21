#!/usr/bin/env sh

MONETDB_DIR=/var/lib/monetdb
MONETDB_DBFARM_NAME=dbfarm
MONETDB_DB_NAME=db

set -e
if [ ! -d ${MONETDB_DIR}/${MONETDB_DBFARM_NAME} ]; then
  monetdbd create ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}
fi
if [ ! -d ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}/${MONETDB_DB_NAME} ]; then
  monetdbd start ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}
  monetdbd set logfile=/dev/stdout ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}
  monetdbd set listenaddr=all ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}
  monetdb create ${MONETDB_DB_NAME}
  monetdb set embedpy3=true ${MONETDB_DB_NAME}
  monetdb set embedr=true ${MONETDB_DB_NAME}
  monetdb release ${MONETDB_DB_NAME}
  monetdbd stop ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}
fi
monetdbd start -n ${MONETDB_DIR}/${MONETDB_DBFARM_NAME}
