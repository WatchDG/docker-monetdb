#!/usr/bin/env sh

set -e
if [ ! -d /monetdb/dbfarm ]; then
  monetdbd create /monetdb/dbfarm
fi
if [ ! -d /monetdb/dbfarm/db ]; then
  monetdbd start /monetdb/dbfarm
  monetdbd set logfile=/dev/stdout /monetdb/dbfarm
  monetdbd set listenaddr=0.0.0.0 /monetdb/dbfarm
  monetdb create db
  monetdb set embedr=true db
  monetdb release db
  monetdbd stop /monetdb/dbfarm
fi
monetdbd start -n /monetdb/dbfarm